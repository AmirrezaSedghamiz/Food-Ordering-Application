import 'dart:async';
import 'dart:io';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/GlobalBottomNavigation.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/MainApplication/Customer/RestaurantPage/RestaurantPage.dart';
import 'package:data_base_project/SourceDesign/Category.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/DayHour.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.customer});
  Customer customer;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  File? customerImage;
  Timer? _debounce;

  List<Restaurant> nearRestaurants = [];
  List<Restaurant> searchedRestaurants = [];

  late ScrollController _scrollController;
  bool isLoadingMore = false;
  int currentPage = 1;
  final int pageSize = 4;

  late ScrollController _scrollControllerSearch;
  bool isLoadingMoreSearch = false;
  int currentPageSearch = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _scrollControllerSearch = ScrollController()..addListener(_onScrollSearch);

    _initializeCustomerImage();
    getData(); // Load initial data
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _scrollControllerSearch.dispose();
    super.dispose();
  }

  Future<void> _initializeCustomerImage() async {
    customerImage = await uint8ListToFile(widget.customer.image);
    setState(() {}); // Update state after loading image
  }

  void _onScrollSearch() {
    if (_scrollControllerSearch.position.pixels >=
            _scrollControllerSearch.position.maxScrollExtent &&
        !isLoadingMoreSearch) {
      loadMoreDataSearch();
    }
  }

  Future<void> getDataSearch() async {
    setState(() {
      isLoadingMoreSearch = true;
    });
    List<Restaurant>? fetchedRestaurants =
        await Restaurant.searchRestaurantByName(
            name: _searchController.text, pageNumber: currentPageSearch);

    if (fetchedRestaurants != null && fetchedRestaurants.isNotEmpty) {
      setState(() {
        searchedRestaurants.addAll(fetchedRestaurants);
        currentPageSearch++;
      });
    }

    setState(() {
      isLoadingMoreSearch = false;
    });
  }

  void loadMoreDataSearch() async {
    if (!isLoadingMoreSearch) {
      await getDataSearch();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      loadMoreData();
    }
  }

  Future<void> getData() async {
    setState(() {
      isLoadingMore = true;
    });
    LatLng myLoc = widget.customer.selectedAddress!.point;
    for (var i in widget.customer.addresses) {
      if (i.isSelected) {
        myLoc = i.point;
        break;
      }
    }
    List<Restaurant>? fetchedRestaurants = await Restaurant.getNeaRestaurant(
        location: myLoc,
        pageNumber: currentPage);

    if (fetchedRestaurants != null && fetchedRestaurants.isNotEmpty) {
      setState(() {
        nearRestaurants.addAll(fetchedRestaurants);
        currentPage++; // Increment the page number
      });
    }

    setState(() {
      isLoadingMore = false;
    });
  }

  void loadMoreData() async {
    if (!isLoadingMore) {
      await getData();
    }
  }

  List<String> myDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  String convertPostgresTimeToHours(String timeStr) {
    int hour24 = int.parse(timeStr.split(':')[0]);
    String hour;
    String suffix;

    if (hour24 == 0) {
      hour = '24';
      suffix = 'شب';
    } else if (hour24 == 12) {
      hour = '12';
      suffix = 'ظهر';
    } else if (hour24 < 12) {
      hour = hour24.toString();
      suffix = 'صبح';
    } else if (hour24 < 16) {
      hour = (hour24).toString();
      suffix = 'ظهر';
    } else {
      hour = (hour24).toString();
      suffix = 'شب';
    }
    return '$hour $suffix';
  }

  AbsorbPointer restaurantWidgetBuilder(Restaurant restaurant) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: GestureDetector(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          List<DayHour> dayHours = await DayHour.getDayHours(
                  restaurantId: restaurant.restaurantId) ??
              [];
          dayHours
              .sort((a, b) => a.dayOfWeek.index.compareTo(b.dayOfWeek.index));
          int today = getTodayAsInt();
          List<WeekDay> weekDay = [
            WeekDay.SUNDAY,
            WeekDay.SATURADY,
            WeekDay.MONDAY,
            WeekDay.TUESDAY,
            WeekDay.WEDNSDAY,
            WeekDay.THURSDAY,
            WeekDay.FRIDAY
          ];
          List<String> allDays = [];
          String todayHours = 'امروز سرویس دهی نداریم';
          for (var i in dayHours) {
            allDays.add(
                "${myDays[weekDay.indexOf(i.dayOfWeek)]} : ${convertPostgresTimeToHours(i.startHour)} - ${convertPostgresTimeToHours(i.endHour)}");
            if (today - 1 == weekDay.indexOf(i.dayOfWeek)) {
              todayHours =
                  "${myDays[today - 1]} : ${convertPostgresTimeToHours(i.startHour)} - ${convertPostgresTimeToHours(i.endHour)}";
            }
          }
          List<Category> categories =
              await Category.getCategoriesByRestaurantId(
                      restaurantId: restaurant.restaurantId,
                      page: 1,
                      pageSize: 30) ??
                  [];
          setState(() {
            isLoading = false;
          });
          AnimationNavigation.navigatePush(
              RestaurantPage(
                customer: widget.customer,
                categories: categories,
                restaurant: restaurant,
                allHours: allDays,
                dayHour: todayHours,
              ),
              context);
        },
        child: Container(
          width: 220,
          height: 200,
          child: Stack(
            children: [
              Container(
                width: 220,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  image: DecorationImage(
                    image: MemoryImage(restaurant.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 220,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF636363).withOpacity(0.8),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(3),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          color: Color(0xFFFEC37D),
                          fontSize: 16,
                          fontFamily: 'DanaFaNum',
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              restaurant.address,
                              style: const TextStyle(
                                color: Color(0xFFF8F3F0),
                                fontFamily: 'DanaFaNum',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF201F22),
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(75),
            child: GlobalAppBar(
              manager: null,
              isManager: false,
              customer: widget.customer,
              image: customerImage,
              username: widget.customer.username,
              shouldPop: false,
            ),
          ),
          body: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.05,
                      MediaQuery.of(context).size.height * 0.03,
                      MediaQuery.of(context).size.width * 0.05,
                      MediaQuery.of(context).size.height * 0.18,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 50 / 900,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) async {
                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel(); // Cancel any active timer
                              }

                              _debounce = Timer(
                                  const Duration(milliseconds: 1000), () async {
                                setState(() {
                                  searchedRestaurants = [];
                                });
                                if (value.isEmpty) {
                                  return;
                                }
                                currentPageSearch =
                                    1; // Reset the page to the first
                                await getDataSearch();
                              });
                            },
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 13,
                                fontFamily: "DanaFaNum",
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xff484848),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              label: Text(
                                'دنبال چی میگردی؟',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                              counter: null,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFEDEDED), width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFEDEDED), width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFEDEDED), width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFEDEDED), width: 1)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (searchedRestaurants.isNotEmpty &&
                            _searchController.text != '')
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 200,
                            child: ListView.builder(
                              controller: _scrollControllerSearch,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: isLoadingMore
                                  ? searchedRestaurants.length + 1
                                  : searchedRestaurants.length,
                              itemBuilder: (context, index) {
                                if (index == searchedRestaurants.length) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(25, 8, 25, 8),
                                    child: Center(
                                      child: LoadingAnimationWidget
                                          .fourRotatingDots(
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 8, 0, 8),
                                  child: restaurantWidgetBuilder(
                                      searchedRestaurants[index]),
                                );
                              },
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'رستوران های نزدیکت',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: const Color(0xFFFEC37D),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                CupertinoIcons.backward,
                                color: Color(0xFFFEC37D),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 200,
                          child: ListView.builder(
                            controller:
                                _scrollController, // Attach the scroll controller
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: isLoadingMore
                                ? nearRestaurants.length + 1
                                : nearRestaurants.length,
                            itemBuilder: (context, index) {
                              if (index == nearRestaurants.length) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 8, 25, 8),
                                  child: Center(
                                    child:
                                        LoadingAnimationWidget.fourRotatingDots(
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(25, 8, 0, 8),
                                child: restaurantWidgetBuilder(
                                    nearRestaurants[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GlobalBottomNavigator(
                  customer: widget.customer,
                  isInHome: true,
                  isInHistory: false,
                  isInProfile: false,
                  isInShoppinCart: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int getTodayAsInt() {
    int weekday = DateTime.now().weekday;
    return (weekday + 2) % 7;
  }

  double _exitPromptOpacity = 0.0;
  DateTime? _lastPressedTime;

  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    if (_lastPressedTime == null ||
        currentTime.difference(_lastPressedTime!) >
            const Duration(seconds: 2)) {
      _lastPressedTime = currentTime;
      setState(() {
        _exitPromptOpacity = 1.0;
      });

      // Hide the prompt after 2 seconds with animation
      Future.delayed(const Duration(milliseconds: 2000), () {
        // Completely remove the prompt after the fade-out animation
        Future.delayed(const Duration(milliseconds: 300), () {});
      });

      return Future.value(false);
    }
    return Future.value(true);
  }
}
