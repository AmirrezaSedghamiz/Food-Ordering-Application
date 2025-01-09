import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/GlobalWidgets/Map.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'باید',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: const Color(0xFFFB4141),
                              fontWeight: FontWeight.w800,
                              fontSize: 28),
                        ),
                        Text(
                          'مشخصاتت',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: const Color(0xFFFB4141),
                              fontWeight: FontWeight.w800,
                              fontSize: 28),
                        ),
                        Text(
                          'رو وارد کنی',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: const Color(0xFFFB4141),
                              fontWeight: FontWeight.w800,
                              fontSize: 28),
                        ),
                      ],
                    ),
                    Assets.images.signUpPageTop.image(
                        width: MediaQuery.of(context).size.width * 228 / 412,
                        height: MediaQuery.of(context).size.height * 304 / 900,
                        fit: BoxFit.fill)
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
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
                  ),
                  decoration: InputDecoration(
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
                  ),
                  decoration: InputDecoration(
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
                        icon: _isObscure
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
                  ),
                  decoration: InputDecoration(
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
                        icon: _isObscure
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
                  ),
                  decoration: InputDecoration(
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 300 / 412,
                height: errorTextPhoneNumber == null
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
                  ),
                  decoration: InputDecoration(
                    errorText: errorTextPhoneNumber,
                    prefixIcon: const Icon(
                      CupertinoIcons.location,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          AnimationNavigation.navigatePush(
                              MapBuilder(
                                username: _usernameController.text,
                                password: _passwordController.text,
                                confirmPassword: _confirmPasswordController.text,
                                phoneNumber: _phoneNumberController.text,
                              ), context);
                        },
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        )),
                    label: Text(
                      'آدرست رو بنویس',
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              ElevatedButton(
                  onPressed: !isLoading
                      ? () async {
                          bool flag = false;
                          if (_usernameController.text.isEmpty) {
                            flag = true;
                            setState(() {
                              errorTextUsername = 'نام کاربری را وارد کنید';
                            });
                          }
                          if (_passwordController.text.isEmpty) {
                            flag = true;
                            setState(() {
                              errorTextPassword = 'رمز مورد نظر خود را وارد کنید';
                            });
                          } else if (_passwordController.text.length < 8) {
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
                          if (_addressController.text.isEmpty) {
                            flag = true;
                            setState(() {
                              errorTextAddress = 'آدرس خود را وارد کنید';
                            });
                          }
                          if (flag) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          //TODO
                        }
                      : () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC145),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: Size(
                          MediaQuery.of(context).size.width * 300 / 412,
                          MediaQuery.of(context).size.height * 50 / 900)),
                  child: Text(
                    "بزن بریم",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white, fontSize: 20),
                  )),
            ],
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
      // Revert to old value if prefix is removed
      return oldValue;
    }
    return newValue;
  }
}
