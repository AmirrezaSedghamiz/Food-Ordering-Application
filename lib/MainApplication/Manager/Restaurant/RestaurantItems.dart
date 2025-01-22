import 'dart:io';

import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/SourceDesign/Category.dart';
import 'package:data_base_project/SourceDesign/Item.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RestaurantItems extends StatefulWidget {
  const RestaurantItems(
      {super.key,
      required this.image,
      required this.categories,
      required this.manager});

  final File? image;
  final Manager manager;
  final List<Category> categories;

  @override
  State<RestaurantItems> createState() => _RestaurantItemsState();
}

class _RestaurantItemsState extends State<RestaurantItems> {
  late List<Category> categories;
  String previousValue = '';
  int selectedCategoryIndex = -1;
  List<TextEditingController> categoryController = [];
  List<List<TextEditingController>> itemNameController = [];

  String previousValueItem = '';
  String previousValueCost = '';
  String previousValueRecipe = '';
  int selectedItemIndex = -1;
  List<Item> allItems = [];
  List<Category?> selectedCategory = [];
  List<TextEditingController> allItemsNameController = [];
  List<TextEditingController> allItemsRecipeController = [];
  List<TextEditingController> allItemsCostController = [];

  @override
  void initState() {
    categories = widget.categories;
    for (var i in categories) {
      categoryController.add(TextEditingController(text: i.name));
      List<TextEditingController> tempName = [];
      List<TextEditingController> tempRecipe = [];
      List<TextEditingController> tempCost = [];
      for (var j in i.items) {
        tempName.add(TextEditingController(text: j.name));
        tempRecipe.add(TextEditingController(text: j.recipe));
        tempCost.add(TextEditingController(text: j.cost.toString()));
      }
      itemNameController.add(tempName);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF201F22),
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Center(
            child: GlobalAppBar(
              image: widget.image,
              username: widget.manager.username,
              shouldPop: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.02,
                MediaQuery.of(context).size.height * 0.02,
                MediaQuery.of(context).size.width * 0.02,
                MediaQuery.of(context).size.height * 0.03),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'دسته بندی منو',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFFEC37D),
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    IconButton(
                        onPressed: () {
                          if (selectedCategoryIndex == -1) {
                            for (var i in categories) {
                              if (i.name.isEmpty) return;
                            }
                            setState(() {
                              categories.add(Category(name: '', items: []));
                              categoryController.add(TextEditingController());
                              itemNameController.add([]);
                              selectedCategoryIndex = categories.length - 1;
                            });
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.plus,
                          color: Color(0xFFFEC37D),
                          size: 25,
                        ))
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ListView.builder(
                  shrinkWrap:
                      true, // Let the ListView take only as much space as needed
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            0,
                            0,
                            MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    60 /
                                    900,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextField(
                                  controller: categoryController[index],
                                  obscureText: false,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                  readOnly: (selectedCategoryIndex != index) &&
                                      (categoryController[index]
                                          .text
                                          .isNotEmpty),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff484848),
                                    label: Text(
                                      '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                    counter: null,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              InkWell(
                                  onTap: () {
                                    if (selectedCategoryIndex != index) {
                                      setState(() {
                                        previousValue =
                                            categoryController[index].text;
                                        selectedCategoryIndex = index;
                                      });
                                    } else {
                                      setState(() {
                                        if (categoryController[index]
                                                .text
                                                .isNotEmpty &&
                                            previousValue.isNotEmpty) {
                                          categoryController[
                                                  selectedCategoryIndex]
                                              .text = previousValue;
                                          selectedCategoryIndex = -1;
                                        }
                                        if (categoryController[index]
                                                .text
                                                .isEmpty &&
                                            previousValue.isEmpty) {
                                          setState(() {
                                            categories.removeAt(index);
                                            categoryController.removeAt(index);
                                            itemNameController.removeAt(index);
                                            selectedCategoryIndex = -1;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: (selectedCategoryIndex != index
                                          ? Assets.images.edit
                                          : Assets.images.abort)
                                      .image(width: 30, height: 30)),
                              const SizedBox(
                                width: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  if (selectedCategoryIndex != index) {
                                    setState(() {
                                      categories.removeAt(index);
                                      categoryController.removeAt(index);
                                      itemNameController.removeAt(index);
                                    });
                                  } else {
                                    setState(() {
                                      if (categoryController[index]
                                          .text
                                          .isNotEmpty) {
                                        selectedCategoryIndex = -1;
                                        categories[index].name =
                                            categoryController[index].text;
                                      }
                                    });
                                  }
                                },
                                child: (selectedCategoryIndex != index
                                        ? Assets.images.delete
                                        : Assets.images.submit)
                                    .image(width: 30, height: 30),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        ListView.builder(
                          shrinkWrap:
                              true, // Let the ListView take only as much space as needed
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: categories[index].items.length,
                          itemBuilder: (context, index1) => Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              MediaQuery.of(context).size.height * 0.005,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: MediaQuery.of(context).size.height *
                                      60 /
                                      900,
                                  child: TextField(
                                    controller: itemNameController[index]
                                        [index1],
                                    obscureText: false,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: "DanaFaNum",
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xff484848),
                                      label: Text(
                                        '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      counter: null,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEDEDED),
                                              width: 1.6)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEDEDED),
                                              width: 1.6)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEDEDED),
                                              width: 1.6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        )
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'آیتم های منو',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFFEC37D),
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    IconButton(
                        onPressed: () {
                          if (selectedItemIndex == -1) {
                            for (var i in allItemsNameController) {
                              if (i.text.isEmpty) return;
                            }
                            setState(() {
                              allItems.add(Item(
                                  name: '',
                                  recipe: '',
                                  cost: 0,
                                  isDeleted: false));
                              allItemsCostController
                                  .add(TextEditingController(text: ''));
                              allItemsNameController
                                  .add(TextEditingController(text: ''));
                              allItemsRecipeController
                                  .add(TextEditingController(text: ''));
                              selectedCategory.add(null);
                              selectedItemIndex = allItems.length - 1;
                            });
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.plus,
                          color: Color(0xFFFEC37D),
                          size: 25,
                        ))
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allItems.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            0,
                            0,
                            index == selectedItemIndex
                                ? MediaQuery.of(context).size.height * 0.01
                                : MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    60 /
                                    900,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextField(
                                  controller: allItemsNameController[index],
                                  obscureText: false,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                  readOnly: (selectedItemIndex != index) &&
                                      (allItemsNameController[index]
                                          .text
                                          .isNotEmpty),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff484848),
                                    label: Text(
                                      '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                    counter: null,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              InkWell(
                                  onTap: () {
                                    if (selectedItemIndex != index) {
                                      setState(() {
                                        previousValueItem =
                                            allItemsNameController[index].text;
                                        previousValueCost =
                                            allItemsCostController[index].text;
                                        previousValueRecipe =
                                            allItemsRecipeController[index]
                                                .text;
                                        selectedItemIndex = index;
                                      });
                                    } else {
                                      setState(() {
                                        if ((allItemsCostController[index]
                                                    .text
                                                    .isNotEmpty &&
                                                previousValueCost.isNotEmpty) ||
                                            (allItemsNameController[index]
                                                    .text
                                                    .isNotEmpty &&
                                                previousValueItem.isNotEmpty) ||
                                            (allItemsRecipeController[index]
                                                    .text
                                                    .isNotEmpty &&
                                                previousValueRecipe
                                                    .isNotEmpty)) {
                                          allItemsCostController[
                                                  selectedItemIndex]
                                              .text = previousValueCost;
                                          allItemsNameController[
                                                  selectedItemIndex]
                                              .text = previousValueItem;
                                          allItemsRecipeController[
                                                  selectedItemIndex]
                                              .text = previousValueRecipe;
                                          selectedItemIndex = -1;
                                        }
                                        if ((allItemsCostController[index]
                                                    .text
                                                    .isEmpty &&
                                                previousValueCost.isEmpty) ||
                                            (allItemsNameController[index]
                                                    .text
                                                    .isEmpty &&
                                                previousValueItem.isEmpty) ||
                                            (allItemsRecipeController[index]
                                                    .text
                                                    .isEmpty &&
                                                previousValueRecipe.isEmpty) ||
                                            selectedCategory[index] == null) {
                                          setState(() {
                                            allItems.removeAt(index);
                                            allItemsNameController
                                                .removeAt(index);
                                            allItemsCostController
                                                .removeAt(index);
                                            allItemsRecipeController
                                                .removeAt(index);
                                            selectedCategory.removeAt(index);
                                            selectedItemIndex = -1;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: (selectedItemIndex != index
                                          ? Assets.images.edit
                                          : Assets.images.abort)
                                      .image(width: 30, height: 30)),
                              const SizedBox(
                                width: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  if (selectedItemIndex != index) {
                                    setState(() {
                                      int temp = 0;
                                      for (var i in allItems) {
                                        if (i == allItems[index]) {
                                          break;
                                        }
                                        if (selectedCategory[index]!
                                            .items
                                            .contains(i)) {
                                          temp++;
                                        }
                                      }
                                      itemNameController[categories
                                              // ignore: collection_methods_unrelated_type
                                              .indexOf(
                                                  selectedCategory[index]!)]
                                          .removeAt(temp);
                                      categories[categories.indexOf(
                                              selectedCategory[index]!)]
                                          .items
                                          .removeAt(categories.indexOf(
                                              selectedCategory[index]!));
                                      allItems.removeAt(index);
                                      allItemsNameController.removeAt(index);
                                      allItemsCostController.removeAt(index);
                                      allItemsRecipeController.removeAt(index);
                                      selectedCategory.removeAt(index);
                                    });
                                  } else {
                                    setState(() {
                                      if (allItemsCostController[index].text.isNotEmpty &&
                                          allItemsNameController[index]
                                              .text
                                              .isNotEmpty &&
                                          allItemsRecipeController[index]
                                              .text
                                              .isNotEmpty &&
                                          selectedCategory[index] != null) {
                                        selectedItemIndex = -1;
                                        allItems[index].name =
                                            allItemsNameController[index].text;
                                        allItems[index].cost = double.parse(
                                            allItemsCostController[index].text);
                                        allItems[index].recipe =
                                            allItemsRecipeController[index]
                                                .text;
                                        categories[categories.indexOf(
                                                selectedCategory[index]!)]
                                            .items
                                            .add(allItems[index]);
                                        itemNameController[categories.indexOf(
                                                selectedCategory[index]!)]
                                            .add(TextEditingController(
                                                text: allItems[index].name));
                                      }
                                    });
                                  }
                                },
                                child: (selectedItemIndex != index
                                        ? Assets.images.delete
                                        : Assets.images.submit)
                                    .image(width: 30, height: 30),
                              ),
                            ],
                          ),
                        ),
                        if (index == selectedItemIndex) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'مواد اولیه : ',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "DanaFaNum",
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    60 /
                                    900,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextField(
                                  controller: allItemsRecipeController[index],
                                  obscureText: false,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                  readOnly: (selectedItemIndex != index) &&
                                      (allItemsRecipeController[index]
                                          .text
                                          .isNotEmpty),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff484848),
                                    label: Text(
                                      '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                    counter: null,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'قیمت : ',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "DanaFaNum",
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    60 /
                                    900,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextField(
                                  controller: allItemsCostController[index],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  obscureText: false,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                  readOnly: (selectedItemIndex != index) &&
                                      (allItemsCostController[index]
                                          .text
                                          .isNotEmpty),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff484848),
                                    label: Text(
                                      '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                    counter: null,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1.6)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'دسته‌بندی : ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "DanaFaNum",
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    60 /
                                    900,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: DropdownButtonFormField<Category>(
                                  value: selectedCategory[index],
                                  items: categories
                                      .map((category) =>
                                          DropdownMenuItem<Category>(
                                            value: category,
                                            child: Text(
                                              category.name,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontFamily: "DanaFaNum",
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory[index] =
                                          value!; // Update the selected category
                                    });
                                  },
                                  dropdownColor: const Color(
                                      0xff484848), // Matches the UI background color
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: "DanaFaNum",
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff484848),
                                    label: Text(
                                      '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                    counter: null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED),
                                        width: 1.6,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED),
                                        width: 1.6,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED),
                                        width: 1.6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ]);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
