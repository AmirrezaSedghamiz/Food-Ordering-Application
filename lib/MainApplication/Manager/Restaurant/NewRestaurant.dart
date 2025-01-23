// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:data_base_project/MainApplication/Manager/Dashboard/ManagerDashboard.dart';
import 'package:data_base_project/SourceDesign/DayHour.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/GlobalAppBar.dart';
import 'package:data_base_project/GlobalWidgets/Map.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class NewRestaurant extends StatefulWidget {
  File? image;
  Manager manager;
  String? name;
  String? address;
  String? maxDistance;
  String? phoneNumber;
  String? deliveryFee;
  List<TextEditingController>? timeControllers;
  LatLng? location;
  File? restaurantPic;
  int? restaurantIdConfirm;
  List<String?> startHour;
  List<String?> endHour;
  List<String?> day;

  NewRestaurant({
    Key? key,
    required this.image,
    required this.startHour,
    required this.endHour,
    required this.day,
    required this.location,
    required this.restaurantPic,
    required this.restaurantIdConfirm,
    required this.manager,
    required this.phoneNumber,
    required this.name,
    required this.address,
    required this.maxDistance,
    required this.deliveryFee,
    required this.timeControllers,
  }) : super(key: key);

  @override
  State<NewRestaurant> createState() => _NewRestaurantState();
}

class _NewRestaurantState extends State<NewRestaurant> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController maxDistanceController = TextEditingController();
  final TextEditingController deliveryFeeController = TextEditingController();
  List<TextEditingController> timeControllers = [];
  List<String?> startHour = [];
  List<String?> endHour = [];
  List<String?> day = [];

  String? errorTextName;
  String? errorTextAddress;
  String? errorTextMaxDistance;
  String? errorTextPhoneNumber;
  String? errorTextDeliveryFee;

  List<String> hours = [
    '6 صبح',
    '7 صبح',
    '8 صبح',
    '9 صبح',
    '10 صبح',
    '11 صبح',
    '12 ظهر',
    '13 ظهر',
    '14 ظهر',
    '15 ظهر',
    '16 شب',
    '17 شب',
    '18 شب',
    '19 شب',
    '20 شب',
    '21 شب',
    '22 شب',
    '23 شب',
    '24 شب',
  ];

  List<String> days = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  List<String> filteredDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  @override
  void initState() {
    startHour = widget.startHour;
    endHour = widget.endHour;
    day = widget.day;
    phoneNumberController.text = widget.phoneNumber ?? '';
    nameController.text = widget.name ?? "";
    addressController.text = widget.address ?? "";
    maxDistanceController.text = widget.maxDistance ?? "";
    deliveryFeeController.text = widget.deliveryFee ?? "";
    timeControllers = widget.timeControllers ?? [];
    _image = widget.restaurantPic;
    super.initState();
    applyFilter();
  }

  void applyFilter() {
    setState(() {
      filteredDays = [];
      for (var i in days) {
        if (!(day.contains(i))) {
          filteredDays.add(i);
        }
      }
    });
  }

  File? _image;
  bool isLoading = false;

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
                MediaQuery.of(context).size.width * 0.07,
                0,
                MediaQuery.of(context).size.width * 0.07,
                MediaQuery.of(context).size.height * 0.03),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    'نام رستوران',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFEC37D),
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: errorTextName == null
                        ? MediaQuery.of(context).size.height * 50 / 900
                        : MediaQuery.of(context).size.height * 72 / 900,
                    child: TextField(
                      controller: nameController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "DanaFaNum",
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff484848),
                        errorText: errorTextName,
                        label: Text(
                          'اسم رستورانت',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                        ),
                        counter: null,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  Text(
                    'شماره تماس',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFEC37D),
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: errorTextPhoneNumber == null
                        ? MediaQuery.of(context).size.height * 50 / 900
                        : MediaQuery.of(context).size.height * 72 / 900,
                    child: TextField(
                      controller: phoneNumberController,
                      obscureText: false,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "DanaFaNum",
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff484848),
                        errorText: errorTextPhoneNumber,
                        label: Text(
                          'شماره تماس رستوران',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                        ),
                        counter: null,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  Text(
                    'نشانی رستوران',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFEC37D),
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: errorTextAddress == null
                        ? MediaQuery.of(context).size.height * 60 / 900
                        : MediaQuery.of(context).size.height * 72 / 900,
                    child: TextField(
                      controller: addressController,
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
                        errorText: errorTextAddress,
                        suffixIcon: IconButton(
                            onPressed: () {
                              AnimationNavigation.navigatePush(
                                  MapBuilder(
                                    startHour: startHour,
                                    endHour: endHour,
                                    day: day,
                                    restaurantIdConfirm:
                                        widget.restaurantIdConfirm,
                                    restaurantPic: _image,
                                    image: widget.image,
                                    manager: widget.manager,
                                    isInRestaurantPage: true,
                                    restaurantDeliveryFee:
                                        deliveryFeeController.text,
                                    restaurantDeliveryRadius:
                                        maxDistanceController.text,
                                    restaurantName: nameController.text,
                                    restaurantHours: timeControllers,
                                    username: null,
                                    password: null,
                                    confirmPassword: null,
                                    phoneNumber: phoneNumberController.text,
                                  ),
                                  context);
                            },
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            )),
                        label: Text(
                          'آدرست رو انتخاب کن',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey),
                        ),
                        counter: null,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    'عکس پروفایل رستوران',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFEC37D),
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
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
                          right: 10, bottom: 10, child: _showSnackBar(context)),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ساعت کاری',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xFFFEC37D),
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                      if (timeControllers.length < 7)
                        IconButton(
                            onPressed: () {
                              for (var i in timeControllers) {
                                if (i.text == '') return;
                              }
                              setState(() {
                                timeControllers.add(TextEditingController());
                                day.add(null);
                                startHour.add(null);
                                endHour.add(null);
                              });
                              applyFilter();
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
                    height: MediaQuery.of(context).size.height /
                            12 *
                            timeControllers.length +
                        60,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: timeControllers.length,
                      itemBuilder: (context, index) {
                        if (timeControllers[index].text != '') {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              0,
                              0,
                              MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 60 / 900,
                              child: TextField(
                                controller: timeControllers[index],
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
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          timeControllers.removeAt(index);
                                          startHour.removeAt(index);
                                          endHour.removeAt(index);
                                          day.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      )),
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
                          );
                        } else {
                          return Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        120 /
                                        412,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff484848),
                                      borderRadius: BorderRadius.circular(1),
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                    ),
                                    child: Center(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          dropdownColor:
                                              const Color(0xff484848),
                                          isExpanded: true,
                                          elevation: 0,
                                          value: day[index],
                                          hint: Text(
                                            "روز",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.white),
                                          ),
                                          alignment:
                                              AlignmentDirectional.center,
                                          items:
                                              filteredDays.map((String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      value,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ));
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              day[index] = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        100 /
                                        412,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff484848),
                                      borderRadius: BorderRadius.circular(1),
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                    ),
                                    child: Center(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          dropdownColor:
                                              const Color(0xff484848),
                                          isExpanded: true,
                                          elevation: 0,
                                          value: startHour[index],
                                          hint: Text(
                                            "شروع",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.white),
                                          ),
                                          alignment:
                                              AlignmentDirectional.center,
                                          items: hours.map((String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      value,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ));
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              startHour[index] = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        100 /
                                        412,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff484848),
                                      borderRadius: BorderRadius.circular(1),
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                    ),
                                    child: Center(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          dropdownColor:
                                              const Color(0xff484848),
                                          isExpanded: true,
                                          elevation: 0,
                                          value: endHour[index],
                                          hint: Text(
                                            "پایان",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.white),
                                          ),
                                          alignment:
                                              AlignmentDirectional.center,
                                          items: hours.map((String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      value,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ));
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              endHour[index] = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          timeControllers.removeAt(index);
                                          startHour.removeAt(index);
                                          endHour.removeAt(index);
                                          day.removeAt(index);
                                        });
                                      },
                                      child: Assets.images.abort
                                          .image(width: 30, height: 30)),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (startHour[index] != null &&
                                          endHour[index] != null &&
                                          day[index] != null) {
                                        if (hours.indexOf(startHour[index]!) <
                                            hours.indexOf(endHour[index]!)) {
                                          setState(() {
                                            timeControllers[index].text =
                                                '${day[index]} : ${startHour[index]} - ${endHour[index]}';
                                          });
                                        }
                                      }
                                    },
                                    child: Assets.images.submit
                                        .image(width: 30, height: 30),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Text(
                    'پیک رستوران',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFEC37D),
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'نهایت مسافت',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFEC37D),
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: errorTextMaxDistance == null
                        ? MediaQuery.of(context).size.height * 50 / 900
                        : MediaQuery.of(context).size.height * 72 / 900,
                    child: TextField(
                      controller: maxDistanceController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "DanaFaNum",
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff484848),
                        errorText: errorTextMaxDistance,
                        suffixText: 'کیلومتر',
                        suffixStyle: const TextStyle(
                          fontSize: 13,
                          fontFamily: "DanaFaNum",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        label: Text(
                          'نهایت مسافت پیک',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                        ),
                        counter: null,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'هزینه پیک',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFEC37D),
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: errorTextDeliveryFee == null
                        ? MediaQuery.of(context).size.height * 50 / 900
                        : MediaQuery.of(context).size.height * 72 / 900,
                    child: TextField(
                      controller: deliveryFeeController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      keyboardType: const TextInputType.numberWithOptions(),
                      style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "DanaFaNum",
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xff484848),
                        errorText: errorTextDeliveryFee,
                        suffixText: 'تومان',
                        suffixStyle: const TextStyle(
                          fontSize: 13,
                          fontFamily: "DanaFaNum",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        label: Text(
                          'هزینه ارسال',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                        ),
                        counter: null,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 230 / 412,
                      height: MediaQuery.of(context).size.height * 50 / 900,
                      child: ElevatedButton(
                          onPressed: !isLoading
                              ? () async {
                                  bool flag = false;
                                  if (_image == null ||
                                      timeControllers.isEmpty) {
                                    flag = true;
                                  }
                                  if (nameController.text.isEmpty) {
                                    flag = true;
                                    setState(() {
                                      errorTextName =
                                          'اسم رستوران خود را انتخاب کنید';
                                    });
                                  }
                                  if (addressController.text.isEmpty ||
                                      widget.location == null) {
                                    flag = true;
                                    setState(() {
                                      errorTextAddress =
                                          'آدرس خود را انتخاب کنید';
                                    });
                                  }
                                  if (phoneNumberController.text.isEmpty) {
                                    flag = true;
                                    setState(() {
                                      errorTextPhoneNumber =
                                          'شماره تماس رستوران را وارد کنید';
                                    });
                                  }
                                  if (maxDistanceController.text.isEmpty) {
                                    flag = true;
                                    setState(() {
                                      errorTextMaxDistance =
                                          'نهایت مسافت را بنویسید';
                                    });
                                  }
                                  if (deliveryFeeController.text.isEmpty) {
                                    flag = true;
                                    setState(() {
                                      errorTextDeliveryFee =
                                          'هزینه پیک را بنویسید';
                                    });
                                  }
                                  if (flag) {
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    Restaurant? restaurant =
                                        await Restaurant.insertRestaurant(
                                            name: nameController.text,
                                            address: addressController.text,
                                            phoneNumber:
                                                phoneNumberController.text,
                                            point: widget.location!,
                                            deliveryRadius: int.parse(
                                                maxDistanceController.text),
                                            deliveryFee: double.parse(
                                                deliveryFeeController.text),
                                            image: _image!,
                                            managerId:
                                                widget.manager.managerid);
                                    final data = await DayHour.deleteDayHours(
                                        restaurantId: restaurant!.restaurantId);
                                    for (int i = 0; i < startHour.length; i++) {
                                      DayHour.upsertDayHours(
                                          startTime: convertHoursToPostgresTime(
                                              startHour[i]!),
                                          endTime: convertHoursToPostgresTime(
                                              endHour[i]!),
                                          dayOfWeek: days.indexOf(day[i]!) + 1,
                                          restaurantId:
                                              restaurant.restaurantId);
                                    }
                                    if (restaurant != null) {
                                      Navigator.pop(context);
                                      AnimationNavigation.navigateReplace(
                                          ManagerDashboard(
                                              manager: widget.manager,
                                              restaurantId:
                                                  restaurant.restaurantId),
                                          context);
                                    }
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String convertHoursToPostgresTime(String hour) {
    int hour24;
    if (hour.contains('صبح')) {
      hour24 = int.parse(hour.split(' ')[0]);
      if (hour24 == 12) {
        hour24 = 0;
      }
    } else if (hour.contains('ظهر') || hour.contains('شب')) {
      hour24 = int.parse(hour.split(' ')[0]);
    } else {
      hour24 = int.parse(hour.split(' ')[0]);
    }
    String timeStr = "${hour24.toString().padLeft(2, '0')}:00:00";
    return timeStr;
  }
}
