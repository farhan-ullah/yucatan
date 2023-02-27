import 'package:yucatan/utils/size_custom_config.dart';

class Dimensions {
  static const SCALE_FACTOR = 0.125;

  Dimensions._();

  static double pixels_16 = 1.7 * SizeCustomConfig.textMultiplier!;
  static double pixels_10 = 1.11 * SizeCustomConfig.textMultiplier!;
  static double pixels_18 = 2.00 * SizeCustomConfig.textMultiplier!;
  static double pixels_33 = 3.6 * SizeCustomConfig.textMultiplier!;
  static double pixels_35 = 3.90 * SizeCustomConfig.textMultiplier!;
  static double pixels_30 = 3.3 * SizeCustomConfig.textMultiplier!;
  static double pixels_23 = 2.56 * SizeCustomConfig.textMultiplier!;
  static double pixels_80 = 8.92 * SizeCustomConfig.textMultiplier!;
  static double pixels_7 = 0.78 * SizeCustomConfig.textMultiplier!;
  static double pixels_8 = 0.89 * SizeCustomConfig.textMultiplier!;
  static double pixels_11 = 1.22 * SizeCustomConfig.textMultiplier!;
  static double pixels_60 = 6.6 * SizeCustomConfig.textMultiplier!;
  static double pixels_14 = 1.5 * SizeCustomConfig.textMultiplier!;
  static double pixels_15 = 1.6 * SizeCustomConfig.textMultiplier!;
  static double pixels_4 = 0.44 * SizeCustomConfig.textMultiplier!;
  static double pixels_5 = 0.55 * SizeCustomConfig.textMultiplier!;
  static double pixels_51 = 5.6 * SizeCustomConfig.textMultiplier!;
  static double pixels_56 = 6.25 * SizeCustomConfig.textMultiplier!;
  static double pixels_40 = 4.4 * SizeCustomConfig.textMultiplier!;
  static double pixels_20 = 2.32 * SizeCustomConfig.textMultiplier!;
  static double pixels_24 = 2.67 * SizeCustomConfig.textMultiplier!;
  static double pixels_25 = 2.79 * SizeCustomConfig.textMultiplier!;
  static double pixels_67 = 7.47 * SizeCustomConfig.textMultiplier!;
  static double pixels_128 = 14.28 * SizeCustomConfig.textMultiplier!;
  static double pixels_150 = 20.74 * SizeCustomConfig.textMultiplier!;
  static double pixels_120 = 13.39 * SizeCustomConfig.textMultiplier!;
  static double pixels_12 = 1.339 * SizeCustomConfig.textMultiplier!;
  static double pixels_78 = 8.70 * SizeCustomConfig.textMultiplier!;
  static double pixels_200 = 22.33 * SizeCustomConfig.textMultiplier!;
  static double pixels_45 = 5.022 * SizeCustomConfig.textMultiplier!;
  static double pixels_160 = 17.85 * SizeCustomConfig.textMultiplier!;
  static double pixels_140 = 15.62 * SizeCustomConfig.textMultiplier!;
  static double pixels_135 = 15.066 * SizeCustomConfig.textMultiplier!;
  static double pixels_32 = 3.571 * SizeCustomConfig.textMultiplier!;
  static double pixels_54 = 6.026 * SizeCustomConfig.textMultiplier!;
  static double pixels_28 = 3.125 * SizeCustomConfig.textMultiplier!;
  static double pixels_3 = 0.334 * SizeCustomConfig.textMultiplier!;
  static double pixels_13 = 1.450 * SizeCustomConfig.textMultiplier!;
  static double pixels_17 = 1.897 * SizeCustomConfig.textMultiplier!;
  static double pixels_90 = 10.044 * SizeCustomConfig.textMultiplier!;
  static double pixels_180 = 20.089 * SizeCustomConfig.textMultiplier!;
  static double pixels_270 = 30.133 * SizeCustomConfig.textMultiplier!;
  static double pixels_21 = 2.343 * SizeCustomConfig.textMultiplier!;
  static double pixels_48 = 5.357 * SizeCustomConfig.textMultiplier!;
  static double pixels_6 = 0.669 * SizeCustomConfig.textMultiplier!;
  static double pixels_22 = 2.455 * SizeCustomConfig.textMultiplier!;
  static double pixels_50 = 5.580 * SizeCustomConfig.textMultiplier!;
  static double pixels_42 = 4.68 * SizeCustomConfig.textMultiplier!;
  static double pixels_125 = 13.95 * SizeCustomConfig.textMultiplier!;
  static double pixels_75 = 8.37 * SizeCustomConfig.textMultiplier!;
  static double pixels_58 = 6.473 * SizeCustomConfig.textMultiplier!;
  static double pixels_250 = 27.90 * SizeCustomConfig.textMultiplier!;
  static double pixels_450 = 50.22 * SizeCustomConfig.textMultiplier!;
  static double pixels_100 = 11.160 * SizeCustomConfig.textMultiplier!;
  static double pixels_2 = 0.223 * SizeCustomConfig.textMultiplier!;
  static double pixels_220 = 24.55 * SizeCustomConfig.textMultiplier!;
  static double pixels_130 = 14.50 * SizeCustomConfig.textMultiplier!;
  static double pixels_65 = 7.254 * SizeCustomConfig.textMultiplier!;
  static double pixels_144 = 16.07 * SizeCustomConfig.textMultiplier!;
  static double pixels_38 = 4.24 * SizeCustomConfig.textMultiplier!;
  static double pixels_280 = 31.25 * SizeCustomConfig.textMultiplier!;
  static double pixels_300 = 33.25 * SizeCustomConfig.textMultiplier!;
  static double pixels_36 = 4.017 * SizeCustomConfig.textMultiplier!;
  static double pixels_27 = 3.013 * SizeCustomConfig.textMultiplier!;
  static double pixels_44 = 4.910 * SizeCustomConfig.textMultiplier!;
  static double pixels_70 = 7.812 * SizeCustomConfig.textMultiplier!;
  static double pixels_72 = 8.035 * SizeCustomConfig.textMultiplier!;
  static double pixels_170 = 18.97 * SizeCustomConfig.textMultiplier!;
  static double pixels_330 = 36.83 * SizeCustomConfig.textMultiplier!;
  static double pixels_26 = 2.90 * SizeCustomConfig.textMultiplier!;
  static double pixels_34 = 3.79 * SizeCustomConfig.textMultiplier!;
  static double pixels_240 = 26.78 * SizeCustomConfig.textMultiplier!;
  static double pixels_830 = 92.63 * SizeCustomConfig.textMultiplier!;
  static double pixels_910 = 101.46 * SizeCustomConfig.textMultiplier!;

  static double getScaledSize(double sizeInPixel) =>
      sizeInPixel * SCALE_FACTOR * SizeCustomConfig.textMultiplier!;

  static double getWidth({double? percentage}) =>
      percentage! * SizeCustomConfig.widthMultiplier!;

  static double getHeight({double? percentage}) =>
      percentage! * SizeCustomConfig.heightMultiplier!;
}
