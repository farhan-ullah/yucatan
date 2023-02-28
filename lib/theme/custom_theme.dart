import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData theme = ThemeData(
    fontFamily: "AcuminProWide",
    primaryColor: primaryColor,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColorLight,
    ),
    scaffoldBackgroundColor: backgroundColor,
  );

  static const String fontFamily = "AcuminProWide";

  //Corporate design colors
  static const Color primaryColor = Color(0xff004D88);
  static const Color primaryColorLight = Color(0xff0071B8);
  static const Color primaryColorDark = Color(0xff052145);
  static const Color accentColor1 = Color(0xffE6186C); //red
  static const Color accentColor2 = Color(0xff5BB562); //green
  static const Color accentColor3 = Color(0xffFBBF00); //orange

  //Other colors
  static Color hintText = Color(0xffC5C5C5);
  static Color darkGrey = Color(0xff707070);
  static Color mediumGrey = Color(0xffebebeb);
  static Color lightGrey = Color(0xfff8f8f8);
  static Color backgroundColor = Colors.white;
  static Color backgroundColorVendor = Color(0xffbdd3df); //Babyblue
  static Color dividerColor = darkGrey;
  static Color disabledColor = darkGrey;
  static Color grey = Colors.black.withOpacity(0.03);
  static Color magenta = Color(0xffFF00FF);
  static Color shadowBlack = Colors.black.withOpacity(0.16);

  //Sizes
  static double borderRadius = Dimensions.getScaledSize(5.0);
  static const double letterSpacing = 0.7;
  static double iconRadius = Dimensions.getScaledSize(32.0);

  //Widget colors
  static const Color linkColor = primaryColorLight;
  static const Color titleColor = primaryColorDark;
  static const Color confirmationColor = accentColor2;
  static const Color vendorMenubackground = Color(0xffbfd8ef);
  static const Color loginBackground = Color(0xffE5F0F7);

  //Decoration
  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(
      color: CustomTheme.shadowBlack,
      blurRadius: Dimensions.getScaledSize(6.0),
      offset: Offset(0, 3),
    ),
  ];
}
