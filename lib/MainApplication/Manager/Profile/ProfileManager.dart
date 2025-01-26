import 'dart:io';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/GlobalBottomNavigation.dart';
import 'package:data_base_project/GlobalWidgets/Map.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/MainApplication/Customer/Dashboard/Dashboard.dart';
import 'package:data_base_project/SourceDesign/Address.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileManager extends StatefulWidget {
  const ProfileManager({super.key, required this.manager});

  final Manager manager;

  @override
  State<ProfileManager> createState() => _ProfileStateManager();
}

class _ProfileStateManager extends State<ProfileManager> {
  Future<void> _initializeCustomerImage() async {
    _image = await uint8ListToFile(this.manager.image);

    setState(() {});
  }

  late TextEditingController usernameController;
  late TextEditingController phoneNumberController;
  int selectedAddress = 0;

  bool isLoading = false;

  String? errorTextUsername;
  String? errorTextPhoneNumber;

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
            backgroundColor: Colors.white,
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
                                    color: Color(0xFF201F22),
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

  late Manager manager;

  @override
  void initState() {
    manager = widget.manager;
    usernameController = TextEditingController(text: this.manager.username);
    phoneNumberController =
        TextEditingController(text: this.manager.phoneNumber);
    _initializeCustomerImage();
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
          child: GlobalAppBar(
            manager: manager,
                    isManager: true,
                    customer: null,
            image: _image,
            username: this.manager.username,
            shouldPop: true,
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'عکس پروفایل رستوران',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFFFEC37D),
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        width: 144,
                        height: 144,
                        child: ClipRRect(
                          child: _image == null
                              ? const SizedBox()
                              : Image.file(
                                  File(_image!.path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: _image != null
                              ? Container(
                                  height: 32,
                                  width: 32,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _image = null;
                                          });
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.delete,
                                          color: Colors.white,
                                          size: 16,
                                        )),
                                  ),
                                )
                              : _showSnackBar(context)),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'نام کاربری',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFFFEC37D),
                            fontWeight: FontWeight.w400,
                            fontSize: 19),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 350 / 412,
                      height: errorTextUsername == null
                          ? MediaQuery.of(context).size.height * 50 / 900
                          : MediaQuery.of(context).size.height * 72 / 900,
                      child: TextField(
                        controller: usernameController,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 13,
                            fontFamily: "DanaFaNum",
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xff484848),
                          errorText: errorTextUsername,
                          labelText: 'نام کاربری',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'شماره تلفن',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFFFEC37D),
                            fontWeight: FontWeight.w400,
                            fontSize: 19),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 350 / 412,
                      height: errorTextPhoneNumber == null
                          ? MediaQuery.of(context).size.height * 50 / 900
                          : MediaQuery.of(context).size.height * 72 / 900,
                      child: TextField(
                        controller: phoneNumberController,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 13,
                            fontFamily: "DanaFaNum",
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xff484848),
                          errorText: errorTextPhoneNumber,
                          labelText: 'شماره تلفن',
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                  color: Color(0xFFEDEDED), width: 1)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 230 / 412,
                      height: MediaQuery.of(context).size.height * 50 / 900,
                      child: ElevatedButton(
                          onPressed: !isLoading
                              ? () async {
                                  bool flag = false;
                                  if (usernameController.text.isEmpty) {
                                    flag = true;
                                    setState(() {
                                      errorTextUsername =
                                          'نام کاربری نباید خالی باشد';
                                    });
                                  }
                                  if (phoneNumberController.text.isEmpty) {
                                    flag = true;
                                    setState(() {
                                      errorTextPhoneNumber =
                                          'شماره تلفن نباید خالی باشد';
                                    });
                                  }
                                  if (flag) {
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    final data = await Manager.updateManager(
                                        username: usernameController.text,
                                        managerId: manager.managerid,
                                        phoneNumber: phoneNumberController.text,
                                        image: _image);
                                    Navigator.pop(context);
                                  } catch (e) {
                                    setState(() {
                                      errorTextUsername =
                                          'نام کاربری یا شماره تلفن تکراری است';
                                    });
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.175,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
