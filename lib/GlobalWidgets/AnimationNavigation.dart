import 'package:flutter/material.dart';

class AnimationNavigation {
  static void navigatePush(
    Widget page,
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _fadeScaleTransition(animation, child);
      },
      transitionDuration: duration,
    ));
  }

  static void navigateReplace(
    Widget page,
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _fadeScaleTransition(animation, child);
      },
      transitionDuration: duration,
    ));
  }

  static void navigateMakeFirst(
    Widget page,
    BuildContext context, {
    Duration duration = const Duration(milliseconds:500),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _fadeScaleTransition(animation, child);
        },
        transitionDuration: duration,
      ),
      (route) {
        return route.isFirst;
      },
    );
  }

  static void navigatePopAllReplace(
    Widget page,
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _fadeScaleTransition(
              animation, child); // Assuming this is defined
        },
        transitionDuration: duration,
      ),
      (route) => false, 
    );
  }

  static Widget _fadeScaleTransition(
      Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
        child: child,
      ),
    );
  }
}
