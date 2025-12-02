import 'dart:io';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/GlobalBottomNavigation.dart';
import 'package:data_base_project/GlobalWidgets/Map.dart';
import 'package:data_base_project/GlobalWidgets/UintToFile.dart';
import 'package:data_base_project/MainApplication/Customer/Dashboard/Dashboard.dart';
import 'package:data_base_project/SourceDesign/Address.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.customer});

  final Customer customer;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? customerImage;

  Future<void> _initializeCustomerImage() async {
    customerImage = await uint8ListToFile(this.customer.image);
    setState(() {});
  }

  late TextEditingController usernameController;
  late TextEditingController phoneNumberController;
  late List<TextEditingController> addressControllers;
  late List<LatLng> addressLocations;
  late int selectedAddress;

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

  late Customer customer;

  @override
  void initState() {
    customer = widget.customer;
    usernameController = TextEditingController(text: this.customer.username);
    phoneNumberController =
        TextEditingController(text: this.customer.phoneNumber);
    addressControllers = [];
    addressLocations = [];
    for (var i in this.customer.addresses) {
      addressControllers.add(TextEditingController(text: i.address));
      addressLocations.add(i.point);
      if (i.isSelected) {
        selectedAddress = this.customer.addresses.indexOf(i);
      }
    }
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
            manager: null,
            isManager: false,
            customer: widget.customer,
            image: customerImage,
            username: this.customer.username,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'عکس پروفایل',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFFFEC37D),
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
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
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'آدرس',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: const Color(0xFFFEC37D),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 19),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              addressControllers.add(TextEditingController());
                              addressLocations.add(const LatLng(0, 0));
                              customer.addresses.add(Address(
                                  addressId: -1,
                                  isSelected: false,
                                  address: "",
                                  point: const LatLng(0, 0)));
                            });
                          },
                          icon: const Icon(
                            CupertinoIcons.add,
                            size: 20,
                            color: Color(0xFFFEC37D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      itemCount: addressControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    260 /
                                    412,
                                height: MediaQuery.of(context).size.height *
                                    60 /
                                    900,
                                child: TextField(
                                  controller: addressControllers[index],
                                  obscureText: false,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: "DanaFaNum",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff484848),
                                    suffixIcon: addressControllers[index]
                                            .text
                                            .isNotEmpty
                                        ? null
                                        : IconButton(
                                            onPressed: () {
                                              Customer myCus = Customer(
                                                  customerId:
                                                      customer.customerId,
                                                  username: customer.username,
                                                  phoneNumber:
                                                      customer.phoneNumber);
                                              myCus.selectedAddress =
                                                  customer.selectedAddress;
                                              for (var i
                                                  in customer.addresses) {
                                                if (i.address.isNotEmpty) {
                                                  myCus.addresses.add(i);
                                                }
                                              }
                                              AnimationNavigation.navigatePush(
                                                  MapBuilder(
                                                    restaurantMinPurchase: null,
                                                    isInProfile: true,
                                                    customer: myCus,
                                                    startHour: const [],
                                                    endHour: const [],
                                                    day: const [],
                                                    restaurantIdConfirm: null,
                                                    restaurantPic: null,
                                                    image: null,
                                                    manager: null,
                                                    isInRestaurantPage: false,
                                                    restaurantDeliveryFee: null,
                                                    restaurantDeliveryRadius:
                                                        null,
                                                    restaurantName: null,
                                                    restaurantHours: null,
                                                    username: widget
                                                        .customer.username,
                                                    password: null,
                                                    confirmPassword: null,
                                                    phoneNumber: widget
                                                        .customer.phoneNumber,
                                                  ),
                                                  context);
                                            },
                                            icon: const Icon(
                                              Icons.location_on,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    prefix: addressControllers[index]
                                            .text
                                            .isEmpty
                                        ? null
                                        : customer.addresses[index].isSelected
                                            ? Assets.images.greenDot
                                                .image(width: 16, height: 16)
                                            : GestureDetector(
                                                onTap: () {
                                                  for (var i
                                                      in customer.addresses) {
                                                    if (i.isSelected = true) {
                                                      i.isSelected = false;
                                                    }
                                                  }
                                                  setState(() {
                                                    customer.addresses[index]
                                                        .isSelected = true;
                                                    customer.selectedAddress =
                                                        customer
                                                            .addresses[index];
                                                  });
                                                },
                                                child: Assets.images.whiteDot
                                                    .image(
                                                        width: 16, height: 16),
                                              ),
                                    labelText: 'آدرست رو انتخاب کن',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFEDEDED),
                                            width: 1)),
                                  ),
                                  readOnly: true,
                                ),
                              ),
                              customer.addresses[index].isSelected
                                  ? const SizedBox()
                                  : IconButton(
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          addressControllers.removeAt(index);
                                          customer.addresses.removeAt(index);
                                          addressLocations.removeAt(index);
                                        });
                                      },
                                    ),
                            ],
                          ),
                        );
                      },
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
                                  if (addressControllers.isEmpty) {
                                    flag = true;
                                  }
                                  if (flag) {
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    final data = await Customer.updateCustomer(
                                        username: usernameController.text,
                                        customerId: customer.customerId,
                                        phoneNumber: phoneNumberController.text,
                                        image: _image);
                                    List<int> inp = [];
                                    for (var i in customer.addresses) {
                                      if (i.addressId != -1) {
                                        inp.add(i.addressId);
                                      }
                                    }
                                    final data1 = await Address.updateAddresses(
                                        customerId: customer.customerId,
                                        addresses: customer.addresses,
                                        existingIds: inp);
                                    AnimationNavigation.navigateReplace(
                                        Dashboard(customer: this.customer),
                                        context);
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
            GlobalBottomNavigator(
              customer: this.customer,
              isInHome: false,
              isInHistory: false,
              isInProfile: true,
              isInShoppinCart: false,
            ),
          ],
        ),
      ),
    );
  }
}
