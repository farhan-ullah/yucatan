import 'dart:convert';

import 'package:flutter/services.dart';

class CountryUtils{

  CountryObject? countryObject;

  /// static variable CountryUtils of type Singleton
  static CountryUtils? _instance;

  CountryUtils({
    this.countryObject,
  });

  ///singleton class is a class that can have only one object (an instance of the class) at a time
  static CountryUtils getInstance({countryObjects}) {
    if(_instance == null) {
      _instance = CountryUtils(countryObject: countryObjects);
      return _instance!;
    }
    return _instance!;
  }

  ///this methods loads the country and country codes data from the assets json files.
  static Future<CountryObject> loadCountryNamesAsset() async {
    String  jsonResult = await rootBundle.loadString('assets/countries/country_names.json');
    final parsed = json.decode(jsonResult);
    Map<String, dynamic> jsonMap = parsed as Map<String, dynamic>;

    List<CountryData> countryList = jsonMap.entries.map((entry) => CountryData(entry.key, entry.value)).toList();

    List<String> countryList2 = [];
    jsonMap.forEach((k, v) => countryList2.add(jsonMap[k].toString()));

    String  jsonPhoneResult =  await rootBundle.loadString('assets/countries/country_phones.json');
    final parsedData = json.decode(jsonPhoneResult);
    Map<String, dynamic> jsonPhoneMap = parsedData as Map<String, dynamic>;

    List<String> countryPhoneList = [];
    jsonPhoneMap.forEach((k, v) => countryPhoneList.add(jsonPhoneMap[k].toString()));

    CountryObject countryObject = CountryObject(jsonMap,countryList,countryList2,jsonPhoneMap,countryPhoneList);
    return countryObject;
  }

}

class CountryData{
  final String country;
  final String countryName;
  CountryData(this.country, this.countryName);
}

class CountryObject{
  List<CountryData> countryList;
  List<String> countryList2;
  Map<String, dynamic> jsonMap;
  Map<String, dynamic> jsonPhoneMap;
  List<String> countryPhoneList;
  CountryObject(this.jsonMap,this.countryList,this.countryList2,this.jsonPhoneMap,this.countryPhoneList);
}