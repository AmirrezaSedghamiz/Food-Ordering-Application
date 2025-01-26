// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_base_project/SourceDesign/Category.dart';
import 'package:data_base_project/SourceDesign/DayHour.dart';
import 'package:data_base_project/SourceDesign/Item.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage(
      {super.key,
      required this.restaurant,
      required this.dayHour,
      required this.allHours,
      required this.categories});
  final Restaurant restaurant;
  final String dayHour;
  final List<String> allHours;
  final List<Category> categories;
  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<int, int> quantities = {};

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFF56949),
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    const Expanded(child: SizedBox()),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _isExpanded ? 180 : 50, // Expand or shrink
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
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                    itemCount: widget.categories[selectedIndex].items.length,
                    itemBuilder: (context, index1) {
                      final item =
                          widget.categories[selectedIndex].items[index1];
                      final itemId = item.hashCode;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                        child: ItemCart(
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.015)
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        restaurant: widget.restaurant,
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
        width: 87,
        height: 35,
        decoration: BoxDecoration(
            color: selectedIndex == index
                ? const Color(0xFFF56949)
                : const Color(0xFF484848),
            borderRadius: BorderRadius.circular(18)),
        child: Center(
          child: Text(
            category.name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: selectedIndex == index ? Colors.black : Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final Restaurant restaurant;

  const CustomDialog({super.key, required this.restaurant});

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

class ItemCart extends StatelessWidget {
  final Item item;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const ItemCart({
    super.key,
    required this.item,
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
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFF56949),
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
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
            top: 4,
            left: 17,
            child: item.image == null
                ? Assets.images.defaultFood.image(width: 120, height: 120)
                : Image.memory(
                    item.image!,
                    width: 120,
                    height: 120,
                  ),
          ),
          Positioned(
            bottom: 15,
            left: 32,
            child: quantity == 0
                ? Row(
                    children: [
                      InkWell(
                          child: Assets.images.comments
                              .image(width: 34, height: 34)),
                      const SizedBox(
                        width: 12,
                      ),
                      InkWell(
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
