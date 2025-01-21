/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Dana-Black.ttf
  String get danaBlack => 'assets/fonts/Dana-Black.ttf';

  /// File path: assets/fonts/Dana-ExtraBold.ttf
  String get danaExtraBold => 'assets/fonts/Dana-ExtraBold.ttf';

  /// File path: assets/fonts/Dana-Light.ttf
  String get danaLight => 'assets/fonts/Dana-Light.ttf';

  /// File path: assets/fonts/Dana-Regular.ttf
  String get danaRegular => 'assets/fonts/Dana-Regular.ttf';

  /// File path: assets/fonts/Dana-UltraLight.ttf
  String get danaUltraLight => 'assets/fonts/Dana-UltraLight.ttf';

  /// File path: assets/fonts/DanaFaNum-Black.ttf
  String get danaFaNumBlack => 'assets/fonts/DanaFaNum-Black.ttf';

  /// File path: assets/fonts/DanaFaNum-ExtraBold.ttf
  String get danaFaNumExtraBold => 'assets/fonts/DanaFaNum-ExtraBold.ttf';

  /// File path: assets/fonts/DanaFaNum-Light.ttf
  String get danaFaNumLight => 'assets/fonts/DanaFaNum-Light.ttf';

  /// File path: assets/fonts/DanaFaNum-Regular.ttf
  String get danaFaNumRegular => 'assets/fonts/DanaFaNum-Regular.ttf';

  /// List of all assets
  List<String> get values => [
        danaBlack,
        danaExtraBold,
        danaLight,
        danaRegular,
        danaUltraLight,
        danaFaNumBlack,
        danaFaNumExtraBold,
        danaFaNumLight,
        danaFaNumRegular
      ];
}

class $AssetsIconGen {
  const $AssetsIconGen();

  /// File path: assets/icon/HomeIcon.svg
  String get homeIcon => 'assets/icon/HomeIcon.svg';

  /// File path: assets/icon/MapPinIcon.svg
  String get mapPinIcon => 'assets/icon/MapPinIcon.svg';

  /// File path: assets/icon/ProfileIcon.svg
  String get profileIcon => 'assets/icon/ProfileIcon.svg';

  /// File path: assets/icon/ShoppingCartIcon.svg
  String get shoppingCartIcon => 'assets/icon/ShoppingCartIcon.svg';

  /// File path: assets/icon/defaultProfile.svg
  String get defaultProfile => 'assets/icon/defaultProfile.svg';

  /// List of all assets
  List<String> get values =>
      [homeIcon, mapPinIcon, profileIcon, shoppingCartIcon, defaultProfile];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/LoginPageTop.png
  AssetGenImage get loginPageTop =>
      const AssetGenImage('assets/images/LoginPageTop.png');

  /// File path: assets/images/ManagerHistory.png
  AssetGenImage get managerHistory =>
      const AssetGenImage('assets/images/ManagerHistory.png');

  /// File path: assets/images/ManagerMenu.png
  AssetGenImage get managerMenu =>
      const AssetGenImage('assets/images/ManagerMenu.png');

  /// File path: assets/images/ManagerOrders.png
  AssetGenImage get managerOrders =>
      const AssetGenImage('assets/images/ManagerOrders.png');

  /// File path: assets/images/ManagerRestaurant.png
  AssetGenImage get managerRestaurant =>
      const AssetGenImage('assets/images/ManagerRestaurant.png');

  /// File path: assets/images/SignUpImage.png
  AssetGenImage get signUpImage =>
      const AssetGenImage('assets/images/SignUpImage.png');

  /// File path: assets/images/SignUpPageTop.png
  AssetGenImage get signUpPageTop =>
      const AssetGenImage('assets/images/SignUpPageTop.png');

  /// File path: assets/images/abort.png
  AssetGenImage get abort => const AssetGenImage('assets/images/abort.png');

  /// File path: assets/images/defaultProfile.png
  AssetGenImage get defaultProfile =>
      const AssetGenImage('assets/images/defaultProfile.png');

  /// File path: assets/images/delete.png
  AssetGenImage get delete => const AssetGenImage('assets/images/delete.png');

  /// File path: assets/images/edit.png
  AssetGenImage get edit => const AssetGenImage('assets/images/edit.png');

  /// File path: assets/images/submit.png
  AssetGenImage get submit => const AssetGenImage('assets/images/submit.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        loginPageTop,
        managerHistory,
        managerMenu,
        managerOrders,
        managerRestaurant,
        signUpImage,
        signUpPageTop,
        abort,
        defaultProfile,
        delete,
        edit,
        submit
      ];
}

class $AssetsQueriesGen {
  const $AssetsQueriesGen();

  /// File path: assets/queries/addToCustomer.sql
  String get addToCustomer => 'assets/queries/addToCustomer.sql';

  /// File path: assets/queries/testQuery.sql
  String get testQuery => 'assets/queries/testQuery.sql';

  /// List of all assets
  List<String> get values => [addToCustomer, testQuery];
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconGen icon = $AssetsIconGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsQueriesGen queries = $AssetsQueriesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
