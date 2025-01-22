import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/HttpClient.dart';
import 'package:data_base_project/GlobalWidgets/Map.dart';
import 'package:data_base_project/MainApplication/Customer/Dashboard/Dashboard.dart';
import 'package:data_base_project/MainApplication/Manager/Dashboard/ManagerDashboard.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/SourceDesign/Restaurant.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignUpPage extends StatefulWidget {
  final String? username;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? address;
  final LatLng? location;

  const SignUpPage({
    super.key,
    this.username,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.address,
    this.location,
  });
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;

  bool _isObscure = true;
  bool isLoading = false;
  String? errorTextUsername;
  String? errorTextPassword;
  String? errorTextConfirmPassword;
  String? errorTextPhoneNumber;
  String? errorTextAddress;
  LatLng? selectedLocation;
  bool isManager = false;

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.username ?? '');
    _passwordController = TextEditingController(text: widget.password ?? '');
    _confirmPasswordController =
        TextEditingController(text: widget.confirmPassword ?? '');
    _phoneNumberController =
        TextEditingController(text: widget.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.address ?? '');
    selectedLocation = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF201F22),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 200 / 412,
                            height:
                                MediaQuery.of(context).size.height * 50 / 900,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isManager = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !isManager
                                      ? Colors.orange
                                      : const Color(0xFFFFC145),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                child: Text(
                                  "میخوام غذا بگیرم",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.white, fontSize: 14),
                                )),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 150 / 412,
                            height:
                                MediaQuery.of(context).size.height * 50 / 900,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isManager = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isManager
                                      ? Colors.orange
                                      : const Color(0xFFFFC145),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                child: Text(
                                  "رستوران دارم",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.white, fontSize: 14),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 300 / 412,
                        height: errorTextUsername == null
                            ? MediaQuery.of(context).size.height * 50 / 900
                            : MediaQuery.of(context).size.height * 72 / 900,
                        child: TextField(
                          controller: _usernameController,
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
                            errorText: errorTextUsername,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'نام کاربریت چی میخوای باشه؟',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            counter: null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 300 / 412,
                        height: errorTextPassword == null
                            ? MediaQuery.of(context).size.height * 50 / 900
                            : MediaQuery.of(context).size.height * 72 / 900,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: "DanaFaNum",
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xff484848),
                            errorText: errorTextPassword,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                icon: !_isObscure
                                    ? const Icon(
                                        CupertinoIcons.eye,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        CupertinoIcons.eye_slash,
                                        color: Colors.grey,
                                      )),
                            label: Text(
                              'رمز مورد علاقت',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            counter: null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 300 / 412,
                        height: errorTextConfirmPassword == null
                            ? MediaQuery.of(context).size.height * 50 / 900
                            : MediaQuery.of(context).size.height * 72 / 900,
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: _isObscure,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 13,
                              fontFamily: "DanaFaNum",
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xff484848),
                            errorText: errorTextConfirmPassword,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                icon: !_isObscure
                                    ? const Icon(
                                        CupertinoIcons.eye,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        CupertinoIcons.eye_slash,
                                        color: Colors.grey,
                                      )),
                            label: Text(
                              'تکرار رمز مورد علاقت',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            counter: null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 300 / 412,
                        height: errorTextPhoneNumber == null
                            ? MediaQuery.of(context).size.height * 50 / 900
                            : MediaQuery.of(context).size.height * 72 / 900,
                        child: TextField(
                          controller: _phoneNumberController,
                          obscureText: false,
                          keyboardType: const TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
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
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            label: Text(
                              'شماره تلفنت',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey),
                            ),
                            counter: null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xFFEDEDED), width: 1.6)),
                          ),
                        ),
                      ),
                      if (!isManager) ...[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 300 / 412,
                          height: errorTextAddress == null
                              ? MediaQuery.of(context).size.height * 60 / 900
                              : MediaQuery.of(context).size.height * 72 / 900,
                          child: TextField(
                            controller: _addressController,
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
                              errorText: errorTextAddress,
                              prefixIcon: const Icon(
                                CupertinoIcons.location,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    AnimationNavigation.navigatePush(
                                        MapBuilder(
                                          startHour: const [],
                                          endHour: const [],
                                          day: const [],
                                          restaurantIdConfirm: null,
                                          restaurantPic: null,
                                          image: null,
                                          manager: null,
                                          isInRestaurantPage: false,
                                          restaurantDeliveryFee: null,
                                          restaurantDeliveryRadius: null,
                                          restaurantName: null,
                                          restaurantHours: null,
                                          username: _usernameController.text,
                                          password: _passwordController.text,
                                          confirmPassword:
                                              _confirmPasswordController.text,
                                          phoneNumber:
                                              _phoneNumberController.text,
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
                                      color: Color(0xFFEDEDED), width: 1.6)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFEDEDED), width: 1.6)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFEDEDED), width: 1.6)),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 300 / 412,
                        height: MediaQuery.of(context).size.height * 50 / 900,
                        child: ElevatedButton(
                            onPressed: !isLoading
                                ? () async {
                                    bool flag = false;
                                    if (_usernameController.text.isEmpty) {
                                      flag = true;
                                      setState(() {
                                        errorTextUsername =
                                            'نام کاربری را وارد کنید';
                                      });
                                    }
                                    if (_passwordController.text.isEmpty) {
                                      flag = true;
                                      setState(() {
                                        errorTextPassword =
                                            'رمز مورد نظر خود را وارد کنید';
                                      });
                                    } else if (_passwordController.text.length <
                                        8) {
                                      flag = true;
                                      setState(() {
                                        errorTextPassword =
                                            'رمز شما باید بیشتر از 8 کارکتر باشد';
                                      });
                                    }
                                    if (_confirmPasswordController.text !=
                                        _passwordController.text) {
                                      flag = true;
                                      setState(() {
                                        errorTextConfirmPassword =
                                            'رمز و تکرار رمز باید یکسان باشند';
                                      });
                                    }
                                    if (_phoneNumberController.text.isEmpty) {
                                      flag = true;
                                      setState(() {
                                        errorTextPhoneNumber =
                                            'شماره تلفن خود را وارد کنید';
                                      });
                                    }
                                    if (!isManager &&
                                        _addressController.text.isEmpty) {
                                      flag = true;
                                      setState(() {
                                        errorTextAddress =
                                            'آدرس خود را وارد کنید';
                                      });
                                    }
                                    if (flag) {
                                      return;
                                    }
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      if (!isManager) {
                                        LocationSeri loc;
                                        loc = LocationSeri.fromMap(
                                            (await HttpClient.geoCoding.get(
                                                    'geocoding?address=${_addressController.text}',
                                                    options: HttpClient
                                                        .globalHeader))
                                                .data['location']);
                                        Customer? customer =
                                            await Customer.insertCustomer(
                                                username:
                                                    _usernameController.text,
                                                password:
                                                    _passwordController.text,
                                                phoneNumber:
                                                    _phoneNumberController.text,
                                                addressString:
                                                    _addressController.text,
                                                latLng: widget.location ??
                                                    LatLng(loc.y, loc.x));
                                        if (customer != null) {
                                          AnimationNavigation
                                              .navigatePopAllReplace(
                                                  Dashboard(customer: customer),
                                                  context);
                                        } else {
                                          setState(() {
                                            errorTextPhoneNumber = null;
                                            errorTextConfirmPassword = null;
                                            errorTextPassword = null;
                                            errorTextAddress = null;
                                            errorTextUsername =
                                                'این نام کاربری تکراری می باشد';
                                          });
                                        }
                                      } else {
                                        Manager? manager =
                                            await Manager.insertManager(
                                          username: _usernameController.text,
                                          password: _passwordController.text,
                                          phoneNumber:
                                              _phoneNumberController.text,
                                        );
                                        if (manager != null) {
                                          Restaurant? restaurant =
                                              await Restaurant
                                                  .getRestaurantByManagerId(
                                                      managerId:
                                                          manager.managerid);
                                          AnimationNavigation
                                              .navigatePopAllReplace(
                                                  ManagerDashboard(
                                                    manager: manager,
                                                    restaurantId: restaurant
                                                        ?.restaurantId,
                                                  ),
                                                  context);
                                        } else {
                                          setState(() {
                                            errorTextPhoneNumber = null;
                                            errorTextConfirmPassword = null;
                                            errorTextPassword = null;
                                            errorTextAddress = null;
                                            errorTextUsername =
                                                'این نام کاربری تکراری می باشد';
                                          });
                                        }
                                      }
                                    } catch (e) {
                                      print(e);
                                      setState(() {
                                        errorTextUsername =
                                            'نام کاربری تکراری می باشد';
                                      });
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                : () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: isLoading
                                ? LoadingAnimationWidget.fourRotatingDots(
                                    color: Colors.white, size: 20)
                                : Text(
                                    "بزن بریم",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Colors.white, fontSize: 20),
                                  )),
                      ),
                      const SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                ),
                Positioned(
                    bottom: 50,
                    left: 20,
                    child: Assets.images.signUpImage
                        .image(width: 200, height: 100))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrefixFormatter extends TextInputFormatter {
  final String prefix;

  PrefixFormatter({required this.prefix});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.text.startsWith(prefix)) {
      return oldValue;
    }
    return newValue;
  }
}
