import 'package:flutter/material.dart';
import 'package:yucatan/utils/string_utils.dart';

enum Flavor { DEV, QA, PROD }

class FlavorValues {
  FlavorValues({required this.baseUrl});
  final String baseUrl;
  //Add other flavor specific values, e.g database name
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  // final Color color;
  final FlavorValues values;
  static FlavorConfig? _instance;
  // = FlavorConfig(
  //   flavor: Flavor.DEV,
  //   values: FlavorValues(baseUrl: "https://appventure.dev.fast-rocket.de/api"),
  // );

  factory FlavorConfig(
      {required Flavor flavor,
      // Color color: Colors.blue,
      required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(
      flavor,
      StringUtils.enumName(flavor.toString()),
      // color,
      values,
    );
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.name,
    // this.color,
    this.values,
  );
  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.PROD;
  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;
  static bool isTest() => _instance!.flavor == Flavor.QA;
}
