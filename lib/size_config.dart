import 'package:flutter/material.dart';
import 'package:yucatan/utils/widget_dimensions.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

// Get the proportionate height as per screen size
/// Use [Dimensions.getHeight]
@Deprecated('Use above method to get proportionate height')
double getProportionateScreenHeight(double inputHeight) {
  //double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  //return (inputHeight / 812.0) * screenHeight;
  return Dimensions.getHeight(percentage: inputHeight);
}

// Get the proportionate height as per screen size
/// Use [Dimensions.getWidth]
@Deprecated('Use above method to get proportionate width')
double getProportionateScreenWidth(double inputWidth) {
  //double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  //return (inputWidth / 375.0) * screenWidth;
  return Dimensions.getWidth(percentage: inputWidth);
}

/// Use [Dimensions.getScaledSize]
@Deprecated(
    'Use above method to get scaled size according to different screens')
EdgeInsets getProportionatePadding(
    {double top: 0, double left: 0, double bottom: 0, double right: 0}) {
  return EdgeInsets.only(
    top: getProportionateScreenHeight(top),
    left: getProportionateScreenWidth(left),
    bottom: getProportionateScreenHeight(bottom),
    right: getProportionateScreenWidth(right),
  );
}

/// Use [Dimensions.getScaledSize]
@Deprecated(
    'Use above method to get scaled size according to different screens')
EdgeInsets getProportionatePaddingAll({double padding: 0}) {
  return EdgeInsets.only(
    top: getProportionateScreenHeight(padding),
    left: getProportionateScreenWidth(padding),
    bottom: getProportionateScreenHeight(padding),
    right: getProportionateScreenWidth(padding),
  );
}
