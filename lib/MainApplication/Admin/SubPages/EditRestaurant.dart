import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/MainApplication/Manager/Restaurant/RestaurantItems.dart';
import 'package:data_base_project/SourceDesign/Category.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/SourceDesign/Admin.dart';

class EditRestaurant extends StatefulWidget {
  const EditRestaurant({super.key, required this.admin});
  final Admin admin;

  @override
  State<EditRestaurant> createState() => _EditRestaurantState();
}

class _EditRestaurantState extends State<EditRestaurant> {
  final ScrollController _scrollController = ScrollController();
  List<ManagerRestaurant> _restaurants = [];
  List<TextEditingController> _controllers = [];
  bool _isLoading = false;
  bool isLoading = false;
  int _pageNumber = 1;
  final int _pageSize = 10;
  String previousValue = '';
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  Future<void> _fetchCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<ManagerRestaurant> restaurants =
          (await Admin.getManagerRestaurantsForRestaurants(
              pageSize: _pageSize, pageNumber: _pageNumber))!;
      for (int i = 0; i < restaurants.length; i++) {
        _controllers
            .add(TextEditingController(text: restaurants[i].restaurant!.name));
      }
      setState(() {
        _restaurants.addAll(restaurants);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoading) {
      _pageNumber++;
      await _fetchCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF201F22),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: GlobalAppBarForAdmin(
            username: widget.admin.username,
            shouldPop: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: _restaurants.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _restaurants.length && _isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              ManagerRestaurant restaurant = _restaurants[index];

              if (selectedIndex == index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 320 / 412,
                        height: MediaQuery.of(context).size.height * 65 / 900,
                        decoration: BoxDecoration(
                          color: const Color(0xff484848),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: const Color(0xFFEDEDED), width: 1),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(6, 3, 14, 0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: MemoryImage(
                                            restaurant.restaurant!.image)
                                        as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 220 / 412,
                              height:
                                  MediaQuery.of(context).size.height * 55 / 900,
                              child: TextField(
                                textAlignVertical: TextAlignVertical.top,
                                controller: _controllers[index],
                                obscureText: false,
                                readOnly: selectedIndex != index,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: "DanaFaNum",
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                                decoration: const InputDecoration(
                                  counter: null,
                                  border: null, // Removes the default underline
                                  focusedBorder: null,
                                  enabledBorder: null,
                                  disabledBorder: null,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            if (selectedIndex != index)
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedIndex != -1) {
                                        _controllers[selectedIndex].text =
                                            previousValue;
                                      }
                                      previousValue = _controllers[index].text;
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Assets.images.edit
                                      .image(width: 30, height: 30)),
                            if (selectedIndex != index)
                              const SizedBox(
                                width: 6,
                              ),
                            if (selectedIndex != index)
                              GestureDetector(
                                onTap: () async {
                                  Admin.deleteRestaurant(
                                      restaurantId:
                                          restaurant.restaurant!.restaurantId);
                                },
                                child: Assets.images.delete
                                    .image(width: 30, height: 30),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: AbsorbPointer(
                        absorbing: isLoading,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            List<Category> categories =
                                await Category.getCategoriesByRestaurantId(
                                        restaurantId:
                                            restaurant.restaurant!.restaurantId,
                                        page: 1,
                                        pageSize: 30) ??
                                    [];
                            setState(() {
                              isLoading = false;
                            });
                            AnimationNavigation.navigatePush(
                                RestaurantItems(
                                    image: await uint8ListToFile(
                                        widget.admin.image),
                                    categories: categories,
                                    restaurantId:
                                        restaurant.restaurant!.restaurantId,
                                    manager: restaurant.manager),
                                context);
                          },
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 320 / 412,
                            height:
                                MediaQuery.of(context).size.height * 65 / 900,
                            decoration: BoxDecoration(
                              color: const Color(0xff484848),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: const Color(0xFFEDEDED), width: 1),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'منو رستوران',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "DanaFaNum",
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 320 / 412,
                        height: MediaQuery.of(context).size.height * 65 / 900,
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controllers[index].text = previousValue;
                                    selectedIndex = -1;
                                  });
                                },
                                child: Assets.images.abort
                                    .image(width: 30, height: 30)),
                            const SizedBox(
                              width: 6,
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _restaurants[index].restaurant!.name =
                                      _controllers[index].text;
                                  selectedIndex = -1;
                                });
                                Admin.updateManager(
                                    managerId:
                                        _restaurants[index].manager.managerid,
                                    restaurantName: _controllers[index].text,
                                    managerName:
                                        _restaurants[index].manager.username);
                              },
                              child: Assets.images.submit
                                  .image(width: 30, height: 30),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 320 / 412,
                  height: MediaQuery.of(context).size.height * 65 / 900,
                  decoration: BoxDecoration(
                    color: const Color(0xff484848),
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(color: const Color(0xFFEDEDED), width: 1),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 3, 14, 0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: MemoryImage(restaurant.restaurant!.image)
                                  as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 220 / 412,
                        height: MediaQuery.of(context).size.height * 55 / 900,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.top,
                          controller: _controllers[index],
                          obscureText: false,
                          readOnly: selectedIndex != index,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: "DanaFaNum",
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                          decoration: const InputDecoration(
                            counter: null,
                            border: null,
                            focusedBorder: null,
                            enabledBorder: null,
                            disabledBorder: null,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      if (selectedIndex != index)
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedIndex != -1) {
                                  _controllers[selectedIndex].text =
                                      previousValue;
                                }
                                previousValue = _controllers[index].text;
                                selectedIndex = index;
                              });
                            },
                            child: Assets.images.edit
                                .image(width: 30, height: 30)),
                      if (selectedIndex != index)
                        const SizedBox(
                          width: 6,
                        ),
                      if (selectedIndex != index)
                        GestureDetector(
                          onTap: () async {
                            Admin.deleteRestaurant(
                                restaurantId:
                                    restaurant.restaurant!.restaurantId);
                          },
                          child:
                              Assets.images.delete.image(width: 30, height: 30),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
