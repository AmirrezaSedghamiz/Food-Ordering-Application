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
  String previousValueItem = '';
  int selectedCategoryIndex = -1;
  int selectedItemIndex = -1;
  List<TextEditingController> categoryController = [];
  List<List<TextEditingController>> itemNameController = [];
  List<List<TextEditingController>> itemRecipeController = [];
  List<List<TextEditingController>> itemCostController = [];
  List<Item> newItems = [];
  List<TextEditingController> newItemsController = [];

  File? _image;

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

  Future _getFromGallery() async {
    bool hasPermission = await _requestStoragePermission(context);
    if (!hasPermission) {
      return;
    }
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _compressImage((pickedFile != null) ? File(pickedFile.path) : null);
  }

  Future<void> _compressImage(File? image) async {
    if (image == null) {
      setState(() {
        _image = null;
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
        _image = File(compressedFile.path);
      });
    }
  }

  _getFromCamera() async {
    bool hasPermission = await _requestCameraPermission(context);
    if (!hasPermission) {
      return;
    }
    final pickedFiles = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    _compressImage((pickedFiles != null) ? File(pickedFiles.path) : null);
  }

  GestureDetector _showSnackBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final snackBar = SnackBar(
            backgroundColor: Colors.orange,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () => _getFromCamera(),
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
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: "DanaFaNum"))
                          ],
                        ))),
                const SizedBox(
                  width: 32,
                ),
                GestureDetector(
                    onTap: () => _getFromGallery(),
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
                                  color: Colors.white,
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
          image: AssetImage("assets/img/editpicIcon.png"),
          fit: BoxFit.cover,
        )),
      ),
    );
  }

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
      itemRecipeController.add(tempRecipe);
      itemCostController.add(tempCost);
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
                              itemCostController.add([]);
                              itemNameController.add([]);
                              itemRecipeController.add([]);
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      60 /
                                      900,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: TextField(
                                    controller: categoryController[index],
                                    obscureText: false,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontFamily: "DanaFaNum",
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white),
                                    readOnly:
                                        (selectedCategoryIndex != index) &&
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
                                const SizedBox(
                                  width: 12,
                                ),
                                InkWell(
                                    onTap: () {
                                      if (selectedCategoryIndex != index) {
                                        setState(() {
                                          previousValue =
                                              categoryController[index].text;
                                          selectedItemIndex = -1;
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
                                              categoryController
                                                  .removeAt(index);
                                              itemCostController
                                                  .removeAt(index);
                                              itemNameController
                                                  .removeAt(index);
                                              itemRecipeController
                                                  .removeAt(index);
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
                                        itemCostController.removeAt(index);
                                        itemNameController.removeAt(index);
                                        itemRecipeController.removeAt(index);
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
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height *
                                65 *
                                categories[index].items.length /
                                900,
                            child: ListView.builder(
                              itemCount: categories[index].items.length,
                              itemBuilder: (context, index1) => Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  0,
                                  MediaQuery.of(context).size.height * 0.005,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                        readOnly:
                                            selectedCategoryIndex != index,
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
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
