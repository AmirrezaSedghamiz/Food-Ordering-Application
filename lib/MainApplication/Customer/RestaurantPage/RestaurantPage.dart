// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/FeedBack.dart';
import 'package:data_base_project/SourceDesign/ItemOrder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_base_project/SourceDesign/Category.dart';
import 'package:data_base_project/SourceDesign/DayHour.dart';
import 'package:data_base_project/SourceDesign/Item.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage(
      {super.key,
      required this.restaurant,
      required this.dayHour,
      required this.allHours,
      required this.customer,
      required this.categories});

  final Customer customer;
  final Restaurant restaurant;
  final String dayHour;
  final List<String> allHours;
  final List<Category> categories;
  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool isLoading = false;
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<int, int> quantities = {};

  Map<Item, int> getSelectedItems() {
    Map<Item, int> selectedItems = {};
    for (var category in widget.categories) {
      for (var item in category.items) {
        int itemId = item.hashCode;
        if (quantities.containsKey(itemId) && quantities[itemId]! > 0) {
          selectedItems[item] = quantities[itemId]!;
        }
      }
    }
    return selectedItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: const Color(0xFF201F22),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 200 / 900,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(widget.restaurant.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 25,
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      26,
                      0,
                      26,
                      5,
                    ),
                    child: Text(
                      widget.restaurant.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFF56949),
                          fontWeight: FontWeight.w600,
                          fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      26,
                      0,
                      26,
                      8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showCustomDialogDays(context);
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.dayHour,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () {
                            showCustomDialog(context);
                          },
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      26,
                      0,
                      26,
                      12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'دسته بندی ها',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: const Color(0xFFF56949),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                        ),
                        const Expanded(child: SizedBox()),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _isExpanded ? 180 : 50,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF484848),
                            border: Border.all(color: Colors.white),
                            borderRadius: _isExpanded
                                ? BorderRadius.circular(16)
                                : BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: IconButton(
                                    icon: Icon(
                                      _isExpanded ? Icons.close : Icons.search,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isExpanded = !_isExpanded;
                                        if (!_isExpanded) {
                                          _searchController.clear();
                                        }
                                      });
                                    },
                                  ),
                                ),
                                if (_isExpanded)
                                  Expanded(
                                    child: Center(
                                      child: TextField(
                                        autofocus: true,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: "DanaFaNum",
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'چه غذایی میخوای ...',
                                          hintStyle: TextStyle(
                                              fontSize: 10,
                                              fontFamily: "DanaFaNum",
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 25, 0),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: categoryBar(widget.categories[index], index),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.012,
                  ),
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            widget.categories[selectedIndex].items.length,
                        itemBuilder: (context, index1) {
                          final item =
                              widget.categories[selectedIndex].items[index1];
                          final itemId = item.hashCode;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                            child: ItemCart(
                              customerId: widget.customer.customerId,
                              item: item,
                              quantity: quantities[itemId] ??
                                  0, // Get the quantity for this item
                              onQuantityChanged: (newQuantity) {
                                setState(() {
                                  quantities[itemId] = newQuantity;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  if (!(quantities.values.every((value) => value == 0))) 
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                ],
              ),
            ),
          ),
          if (!(quantities.values.every((value) => value == 0)))
            Positioned(
                left: 0,
                right: 0,
                bottom: 25,
                child: Center(
                  child: AbsorbPointer(
                    absorbing: isLoading,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          Map<Item, int> myItems = getSelectedItems();
                          List<Map<String, dynamic>> json =
                              myItems.entries.map((entry) {
                            return {
                              'itemid': entry.key.itemid,
                              'quantity': entry.value,
                              'itemordercost': entry.key.cost * entry.value,
                            };
                          }).toList();
                          double sum = 0;
                          for (var i in json) {
                            sum += i['itemordercost'];
                          }
                          if (sum < widget.restaurant.minimumPurchase) {
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          final data = await ItemOrder.insertOrder(
                              addressId:
                                  widget.customer.selectedAddress!.addressId,
                              restaurantId: widget.restaurant.restaurantId,
                              itemQuantity: myItems);
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 300 / 412,
                        height: 60,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF56949),
                            borderRadius: BorderRadius.circular(9)),
                        child: Center(
                          child: Text(
                            'تکمیل خرید',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 19),
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  void onCompletePurchase() {
    Map<Item, int> selectedItems = getSelectedItems();

    // Now you have a map of selected items with their quantities
    for (var entry in selectedItems.entries) {
      print('Item: ${entry.key.name}, Quantity: ${entry.value}');
    }
  }

  void showCustomDialog(BuildContext context) {
    final Distance distance = Distance();
    final double distanceInMeters = distance.as(
      LengthUnit.Kilometer, // Unit: Kilometer
      widget.restaurant.point,
      widget.customer.selectedAddress!.point,
    );
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        restaurant: widget.restaurant,
        isInRange: widget.restaurant.deliveryRadius >= distanceInMeters,
      ),
    );
  }

  void showCustomDialogDays(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialogDays(
        dayHours: widget.allHours,
      ),
    );
  }

  int selectedIndex = 0;

  GestureDetector categoryBar(Category category, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: selectedIndex == index
                ? const Color(0xFFF56949)
                : const Color(0xFF484848),
            borderRadius: BorderRadius.circular(18)),
        child: Padding( 
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Center(
            child: Text(
              category.name,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemCart extends StatelessWidget {
  final Item item;
  final int quantity;
  final int customerId;
  final ValueChanged<int> onQuantityChanged;

  const ItemCart({
    super.key,
    required this.item,
    required this.customerId,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF505050),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 30, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFFF56949),
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                        maxLines: 3,
                      ),
                    ),
                    Text(
                      item.recipe,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFF8F3F0),
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                      maxLines: 2,
                    ),
                    Text(
                      '${item.cost.toInt()} هزار تومان',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFFEC37D),
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 25,
            child: SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: item.image == null
                    ? const SizedBox()
                    /* Image.asset(
                        'assets/images/Remove-bg.ai_1736362397779 2.png',
                        width: 100.0,
                        height: 93.0,
                        fit: BoxFit.cover,
                      ) */
                    : Image.memory(
                        item.image!,
                        width: 100.0,
                        height: 93.0,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 32,
            child: quantity == 0
                ? Row(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            final data = await FeedBack.isAssociated(
                                itemid: item.itemid, customerId: customerId);
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              backgroundColor: const Color(0xBF484848),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0)),
                              ),
                              builder: (context) => FeedbackBottomSheet(
                                  itemId: item.itemid,
                                  customerId: customerId,
                                  orderId: data,
                                  canSend: data != null),
                            );
                          },
                          child: Assets.images.comments
                              .image(width: 34, height: 34)),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          onQuantityChanged(1);
                        },
                        child: Assets.images.addToShoppingCart
                            .image(width: 34, height: 34),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          onQuantityChanged(quantity + 1);
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFF56949)),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.plus,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        quantity.toString(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (quantity > 0) {
                            onQuantityChanged(quantity - 1);
                          }
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFF56949)),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.minus,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final Restaurant restaurant;
  final bool isInRange;

  const CustomDialog(
      {super.key, required this.restaurant, required this.isInRange});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6), // Custom rounded borders
      ),
      backgroundColor: const Color(0xDFF56949), // Custom background color
      child: Padding(
        padding: const EdgeInsets.all(30.0), // Padding inside the dialog
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, // Shrink-wrap the dialog to its contents
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: MapWidget(location: restaurant.point)),
            const SizedBox(height: 16),
            Text(
              restaurant.address,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Text(
              'حداقل هزینه سفارش : ${restaurant.minimumPurchase} تومان',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Assets.images.addressShit.image(width: 25, height: 25),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'هزینه ارسال : ${restaurant.deliveryFee.toInt()} هزار تومان',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ],
            ),
            if (!isInRange) ...[
              const SizedBox(height: 16),
              Text(
                'پیک رستوران خارج از محدوده ی کنونی شماست',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class CustomDialogDays extends StatelessWidget {
  final List<String> dayHours;

  const CustomDialogDays({super.key, required this.dayHours});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6), // Custom rounded borders
      ),
      backgroundColor: const Color(0xDFF56949), // Custom background color
      child: Padding(
          padding: const EdgeInsets.all(30.0), // Padding inside the dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dayHours.length,
                itemBuilder: (context, index) {
                  if (index != dayHours.length - 1) {
                    return Column(
                      children: [
                        Text(
                          dayHours[index],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1,
                        )
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Text(
                        dayHours[index],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                    ],
                  );
                },
              ),
            ],
          )),
    );
  }
}

class MapWidget extends StatelessWidget {
  final LatLng location;
  final MapController mapController = MapController();

  MapWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 170,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
            initialCenter: location,
            initialZoom: 18,
            interactionOptions:
                const InteractionOptions(flags: InteractiveFlag.none)),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.data_base_project',
          ),
          MarkerLayer(markers: [
            Marker(
                point: location,
                child: const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red,
                ))
          ])
        ],
      ),
    );
  }
}

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet(
      {super.key,
      required this.itemId,
      required this.customerId,
      required this.canSend,
      required this.orderId});
  final int itemId;
  final int customerId;
  final bool canSend;
  final int? orderId;

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  List<FeedBack> feedbackList = [];
  int pageNumber = 1;
  int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchFeedback(pageNumber); // Initial load
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchFeedback(int page) async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<FeedBack> newFeedback = (await FeedBack.getComments(
        itemId: widget.itemId,
        pageSize: pageSize,
        pageNumber: pageNumber,
      ))!;

      setState(() {
        if (newFeedback.isEmpty) {
          hasMoreData = false; // No more data to load
        } else {
          feedbackList.addAll(newFeedback);
        }
      });
    } catch (e) {
      print("Error fetching feedback: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      pageNumber++;
      _fetchFeedback(pageNumber);
    }
  }

  int selectedStars = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.4, sigmaY: 2.4),
            child: Container(
              color: Colors.black.withOpacity(0), // You can adjust opacity here
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.6, // 60% of the screen
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  "نظرات",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "DanaFaNum"),
                ),
              ),
              const Divider(thickness: 1, color: Colors.white, endIndent: 0.1),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: feedbackList.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == feedbackList.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: LoadingAnimationWidget.fourRotatingDots(
                              color: Colors.white, size: 26),
                        ),
                      );
                    }
                    final feedback = feedbackList[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: (feedback.customer.image == null)
                                          ? const AssetImage(
                                              "assets/images/defaultProfile.png")
                                          : MemoryImage(
                                                  feedback.customer.image!)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(feedback.customer.username,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontFamily: "DanaFaNum")),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      feedback.comment,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontFamily: "DanaFaNum"),
                                      maxLines: 3,
                                    )
                                  ],
                                ),
                                const SizedBox(),
                                const SizedBox(),
                                const SizedBox(),
                                const SizedBox(),
                                const SizedBox(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star_border,
                                      size: 18,
                                      color: Color(0xFFFEC37D),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(feedback.rating.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFFEC37D),
                                            fontFamily: "DanaFaNum"))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        if (index != feedbackList.length - 1) ...[
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 0.1,
                            endIndent: 0.1,
                          )
                        ]
                      ],
                    );
                  },
                ),
              ),
              if (widget.canSend && widget.orderId != null) ...[
                const SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedStars = 1;
                              });
                            },
                            icon: selectedStars < 1
                                ? const Icon(Icons.star_border,
                                    size: 15, color: Color(0xFFFEC37D))
                                : const Icon(Icons.star,
                                    size: 15, color: Color(0xFFFEC37D))),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedStars = 2;
                              });
                            },
                            icon: selectedStars < 2
                                ? const Icon(Icons.star_border,
                                    size: 15, color: Color(0xFFFEC37D))
                                : const Icon(Icons.star,
                                    size: 15, color: Color(0xFFFEC37D))),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedStars = 3;
                              });
                            },
                            icon: selectedStars < 3
                                ? const Icon(Icons.star_border,
                                    size: 15, color: Color(0xFFFEC37D))
                                : const Icon(Icons.star,
                                    size: 15, color: Color(0xFFFEC37D))),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedStars = 4;
                              });
                            },
                            icon: selectedStars < 4
                                ? const Icon(Icons.star_border,
                                    size: 15, color: Color(0xFFFEC37D))
                                : const Icon(Icons.star,
                                    size: 15, color: Color(0xFFFEC37D))),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedStars = 5;
                              });
                            },
                            icon: selectedStars < 5
                                ? const Icon(Icons.star_border,
                                    size: 15, color: Color(0xFFFEC37D))
                                : const Icon(Icons.star,
                                    size: 15, color: Color(0xFFFEC37D))),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 75 / 900,
                      child: TextField(
                        controller: _commentController,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 13,
                            fontFamily: "DanaFaNum",
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                if (selectedStars == 0 ||
                                    _commentController.text.isEmpty) {
                                  return;
                                }
                                final data = await FeedBack.insertComment(
                                    itemOrderId: widget.orderId!,
                                    rating: selectedStars,
                                    body: _commentController.text);
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              )),
                          label: const Text(
                            'نظر خود را وارد کنید',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: "DanaFaNum",
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          counter: null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
