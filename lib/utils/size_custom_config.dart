import 'package:flutter/widgets.dart';

class SizeCustomConfig {
  static double? _screenWidth;
  static double? _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static double? heightMultiplier;
  static double? widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(double height, double width, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = width;
      _screenHeight = height;
      isPortrait = true;
      if (_screenWidth! < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = height;
      _screenHeight = width;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth! / 100;
    _blockHeight = _screenHeight! / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print(_blockWidth);
    print(_blockHeight);
  }
}
