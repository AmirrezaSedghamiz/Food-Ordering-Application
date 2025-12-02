import 'dart:io';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
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
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class RestaurantItems extends StatefulWidget {
  const RestaurantItems(
      {super.key,
      required this.image,
      required this.categories,
      required this.restaurantId,
      required this.manager});

  final File? image;
  final int restaurantId;
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

  bool isLoading = false;
  String previousValueItem = '';
  String previousValueCost = '';
  String previousValueRecipe = '';
  File? previousImage;
  int selectedItemIndex = -1;
  List<Item> allItems = [];
  List<Category?> selectedCategory = [];
  List<TextEditingController> allItemsNameController = [];
  List<TextEditingController> allItemsRecipeController = [];
  List<TextEditingController> allItemsCostController = [];
  List<bool> isBeingEdited = [];
  List<File?> _image = [];

  @override
  void initState() {
    categories = widget.categories;
    getImages();
    for (var i in categories) {
      categoryController.add(TextEditingController(text: i.name));
      List<TextEditingController> tempName = [];
      for (var j in i.items) {
        allItems.add(j);
        allItemsNameController.add(TextEditingController(text: j.name));
        allItemsRecipeController.add(TextEditingController(text: j.recipe));
        allItemsCostController
            .add(TextEditingController(text: j.cost.toString()));
        selectedCategory.add(i);
        isBeingEdited.add(true);
        tempName.add(TextEditingController(text: j.name));
      }
      itemNameController.add(tempName);
    }
    super.initState();
  }

  Future<bool> getImages() async {
    for (var i in categories) {
      for (var j in i.items) {
        final data = _image.add(await uint8ListToFile(j.image));
      }
    }
    return true;
  }

  Future<int> getAndroidVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidVersion = int.parse(androidInfo.version.release);

    return androidVersion;
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (await getAndroidVersion() >= 13) {
      // Android 13+
      final imagesPermission = await Permission.photos.request();
      final videoPermission = await Permission.videos.request();

      if (imagesPermission.isGranted && videoPermission.isGranted) {
        return true;
      }

      if (context.mounted) {
        _showPermissionDialog(context);
      }
      return false;
    } else {
      final status = await Permission.storage.request();
      if (status != PermissionStatus.granted && context.mounted) {
        _showPermissionDialog(context);
      }
      return status == PermissionStatus.granted;
    }
  }

  Future<bool> _requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted && context.mounted) {
      _showPermissionDialog(context);
    }
    return status == PermissionStatus.granted;
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Disable dismissal by tapping outside the dialog
      builder: (context) {
        return Localizations.override(
          context: context,
          locale: const Locale("en"),
          child: AlertDialog(
            title: const Text('Permissions Required'),
            content: const Text(
              'Camera and storage permissions are required to proceed. Please grant them in your app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the dialog
                  final success = await openAppSettings();
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to open app settings.'),
                      ),
                    );
                  }
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future _getFromGallery(int index) async {
    bool hasPermission = await _requestStoragePermission(context);
    if (!hasPermission) {
      return;
    }
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _compressImage((pickedFile != null) ? File(pickedFile.path) : null, index);
  }

  Future<void> _compressImage(File? image, int index) async {
    if (image == null) {
      setState(() {
        _image[index] = null;
      });
      return;
    }
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      image!.absolute.path,
      "${image.absolute.path}_compressed.jpg",
      quality: 60,
    );
    if (compressedFile != null) {
      setState(() {
        _image[index] = File(compressedFile.path);
      });
    }
  }

  _getFromCamera(int index) async {
    bool hasPermission = await _requestCameraPermission(context);
    if (!hasPermission) {
      return;
    }
    final pickedFiles = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    _compressImage(
        (pickedFiles != null) ? File(pickedFiles.path) : null, index);
  }

  GestureDetector _showSnackBar2(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(
            backgroundColor: Colors.white,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () => _getFromCamera(index),
                    child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.camera,
                              size: 50,
                              color: Color(0xFF201F22),
                            ),
                            Text("دوربین",
                                style: TextStyle(
                                    color: Color(0xFF201F22),
                                    fontSize: 12,
                                    fontFamily: "DanaFaNum"))
                          ],
                        ))),
                const SizedBox(
                  width: 32,
                ),
                GestureDetector(
                    onTap: () => _getFromGallery(index),
                    child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.photo,
                              size: 50,
                              color: Color(0xFF201F22),
                            ),
                            Text(
                              "گالری",
                              style: TextStyle(
                                  color: Color(0xFF201F22),
                                  fontSize: 12,
                                  fontFamily: "DanaFaNum"),
                            )
                          ],
                        ))),
              ],
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 60 / 900,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: const Color(
              0xff484848), // Background color similar to `fillColor`
          borderRadius: BorderRadius.circular(1),
          border: Border.all(
            color: const Color(0xFFEDEDED), // Border color
            width: 0.1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Padding inside the container
        alignment: Alignment.centerLeft, // Align text to the left
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "بارگذاری عکس", // Placeholder text
              style: TextStyle(
                fontSize: 13,
                fontFamily: "DanaFaNum",
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.upload,
              size: 20,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _showSnackBar(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(
            backgroundColor: Colors.white,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () => _getFromCamera(index),
                    child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.camera,
                              size: 50,
                              color: Color(0xFF201F22),
                            ),
                            Text("دوربین",
                                style: TextStyle(
                                    color: Color(0xFF201F22),
                                    fontSize: 12,
                                    fontFamily: "DanaFaNum"))
                          ],
                        ))),
                const SizedBox(
                  width: 32,
                ),
                GestureDetector(
                    onTap: () => _getFromGallery(index),
                    child: Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.photo,
                              size: 50,
                              color: Color(0xFF201F22),
                            ),
                            Text(
                              "گالری",
                              style: TextStyle(
                                  color: Color(0xFF201F22),
                                  fontSize: 12,
                                  fontFamily: "DanaFaNum"),
                            )
                          ],
                        ))),
              ],
            ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/editpicIcon.png"),
          fit: BoxFit.cover,
        )),
      ),
    );
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
              manager: widget.manager,
              isManager: true,
              customer: null,
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
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.02,
                MediaQuery.of(context).size.width * 0.05,
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
                                width: MediaQuery.of(context).size.width * 0.6,
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
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
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
                              GestureDetector(
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
                                      MediaQuery.of(context).size.width * 0.6,
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
                                              width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEDEDED),
                                              width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: Color(0xFFEDEDED),
                                              width: 1)),
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
                                  itemid: -1,
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
                              _image.add(null);
                              isBeingEdited.add(false);
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
                const SizedBox(
                  height: 14,
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
                                width: MediaQuery.of(context).size.width * 0.6,
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
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
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
                                        previousImage = _image[index];
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
                                          _image[selectedItemIndex] =
                                              previousImage;
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
                                            _image.removeAt(index);
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
                              GestureDetector(
                                onTap: () async {
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
                                      itemNameController[categories.indexOf(
                                              selectedCategory[index]!)]
                                          .removeAt(temp);
                                      categories[categories.indexOf(
                                              selectedCategory[index]!)]
                                          .items
                                          .removeAt(temp);
                                      allItems.removeAt(index);
                                      allItemsNameController.removeAt(index);
                                      allItemsCostController.removeAt(index);
                                      allItemsRecipeController.removeAt(index);
                                      _image.removeAt(index);
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
                                        if (!isBeingEdited[index]) {
                                          selectedItemIndex = -1;
                                          allItems[index].name =
                                              allItemsNameController[index]
                                                  .text;
                                          allItems[index].cost = double.parse(
                                              allItemsCostController[index]
                                                  .text);
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

                                          isBeingEdited[index] = true;
                                        } else {
                                          print("in here");
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
                                          print("in here3");
                                          itemNameController[categories.indexOf(
                                                      selectedCategory[index]!)]
                                                  [temp]
                                              .text = allItemsNameController[
                                                  index]
                                              .text;
                                          categories[categories.indexOf(
                                                  selectedCategory[index]!)]
                                              .items
                                              .replaceRange(temp, temp + 1,
                                                  [allItems[index]]);
                                          selectedItemIndex = -1;
                                          print("in here2");
                                        }
                                      }
                                    });
                                    if (allItemsCostController[index].text.isNotEmpty &&
                                        allItemsNameController[index]
                                            .text
                                            .isNotEmpty &&
                                        allItemsRecipeController[index]
                                            .text
                                            .isNotEmpty &&
                                        selectedCategory[index] != null) {
                                      allItems[index].image =
                                          await _image[index]?.readAsBytes();
                                      allItems[index].name =
                                          allItemsNameController[index].text;
                                      allItems[index].recipe =
                                          allItemsRecipeController[index].text;
                                      allItems[index].cost = double.parse(
                                          allItemsCostController[index].text);
                                    }
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
                                width: MediaQuery.of(context).size.width * 0.6,
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
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
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
                                width: MediaQuery.of(context).size.width * 0.6,
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
                                            width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
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
                                width: MediaQuery.of(context).size.width * 0.6,
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
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFEDEDED),
                                        width: 1,
                                      ),
                                    ),
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
                                  'عکس آیتم : ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "DanaFaNum",
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                        ),
                                        child: ClipRRect(
                                          child: _image[index] == null
                                              ? _showSnackBar2(context, index)
                                              : Image.file(
                                                  File(_image[index]!.path),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      if (_image[index] != null)
                                        Positioned(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            bottom: 10,
                                            child:
                                                _showSnackBar(context, index)),
                                    ],
                                  ),
                                )
                              ]),
                          if (selectedItemIndex == index)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            )
                        ],
                      ]);
                    }),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 230 / 412,
                    height: MediaQuery.of(context).size.height * 50 / 900,
                    child: ElevatedButton(
                        onPressed: !isLoading
                            ? () async {
                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  final data = Category.insertCategories(
                                      restaurantId: widget.restaurantId,
                                      categories: categories);
                                  Navigator.pop(context);
                                } catch (e) {
                                  print(e);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF56949),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: isLoading
                            ? LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white, size: 20)
                            : Text(
                                "ثبت اطلاعات",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Colors.white, fontSize: 20),
                              )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
