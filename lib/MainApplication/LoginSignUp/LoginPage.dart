import 'package:data_base_project/DataHandler/QueryHandler.dart';
import 'package:data_base_project/GlobalWidgets/AnimationNavigation.dart';
import 'package:data_base_project/MainApplication/LoginSignUp/SignUpPage.dart';
import 'package:data_base_project/SourceDesign/Admin.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:data_base_project/SourceDesign/Manager.dart';
import 'package:data_base_project/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool isLoading = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CustomWaveClipper(),
                  child: Assets.images.loginPageTop.image(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 450 / 917,
                      fit: BoxFit.fill),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  right: MediaQuery.of(context).size.width * 0.04,
                  child: Text(
                    'خوش اومدی به',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFB4141),
                        fontWeight: FontWeight.w800,
                        fontSize: 23),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.01,
                  right: MediaQuery.of(context).size.width * 0.08,
                  child: Text(
                    'مش ممد فود',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: const Color(0xFFFB4141),
                        fontWeight: FontWeight.w800,
                        fontSize: 37),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 300 / 412,
              height: MediaQuery.of(context).size.height * 50 / 900,
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
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  label: Text(
                    'نام کاربریت چیه؟',
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
              height: errorText == null
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
                    'رمزتم بزن!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  counter: null,
                  errorText: errorText,
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                          color: Color(0xFFEDEDED), width: 1.6)),
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
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 300 / 412,
              height: MediaQuery.of(context).size.height * 50 / 900,
              child: ElevatedButton(
                  onPressed: !isLoading
                      ? () async {
                          if (_usernameController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            setState(() {
                              errorText = 'نام کاربری و پسورد را وارد کنید';
                            });
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final result = await LoginQuery.login(
                                username: _usernameController.text,
                                password: _passwordController.text);
                            print(result);
                            if (result is Customer) {
                              //TODO
                            } else if (result is Manager) {
                              //TODO
                            } else if (result is Admin) {
                              //TODO
                            } else {
                              setState(() {
                                errorText = 'اطلاعات وارد شده نادرست است';
                              });
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
                      backgroundColor: const Color(0xFFFFC145),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      ),
                  child: isLoading
                      ? LoadingAnimationWidget.hexagonDots(
                          color: Colors.white, size: 25)
                      : Text(
                          "بزن بریم",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white, fontSize: 20),
                        )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 0, MediaQuery.of(context).size.width * 0.15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "اکانت نداری؟ ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: const Color(0xFFFFC145), fontSize: 18),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? () {}
                        : () {
                            AnimationNavigation.navigatePush(
                                const SignUpPage(), context);
                          },
                    child: Text(
                      "یکی بساز",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFFFFC145),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          decoration:
                              TextDecoration.underline, // Adds underline
                          decorationColor: const Color(
                              0xFFFFC145), // Match underline color with text color
                          decorationThickness: 1),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class CustomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height); // Start at the bottom-left corner

    // First curve (from left to middle of the width)
    var firstControlPoint = Offset(size.width / 4, size.height * 0.8);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.7);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve (from middle to right edge)
    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.6);
    var secondEndPoint = Offset(size.width, size.height * 0.6);

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0); // Connect to the top-right corner
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
