import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:yucatan/config/flavor_config.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/utils/StringUtils.dart' as StringUtils;
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';

abstract class BaseService {
  /// DEV System
  //static const defaultURL = 'https://appventure.dev.fast-rocket.de/api';

  /// TEST System
  //static const defaultURL = 'https://appventure-test.fast-rocket.de/api';

  /// PROD System
  // static const defaultURL = 'https://api.myappventure.de/api';

  // static final defaultURL = FlavorConfig.instance.values.baseUrl;
  // Changed by Farhan
  static final defaultURL = 'https://api.myappventure.de/api';

  ///Local Android Simulator
  //static const defaultURL = 'http://10.0.2.2:3000/api';

  ///Local iOS Simulator
  //static const defaultURL = 'http://127.0.0.1:3000/api';

  ///Real device (changes)
  //static const defaultURL = 'https://192.168.2.105:3000/api';

  final String baseURL;
  final Map<String, String> headers = {"Content-Type": "application/json"};
  var encoding;

  Uri? _uri(String endpoint) =>
      Uri.tryParse(baseURL + StringUtils.trimLeading('/', endpoint)!);

  @protected
  BaseService(String baseURL)
      : this.baseURL = baseURL.endsWith('/') ? baseURL : baseURL + '/';

  /// performs a HTTP GET request
  /// [endpoint] Endpoint URL on the server (trailing / should be omitted)
  Future<http.Response?> get(String endpoint) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(_uri(endpoint).toString(), HttpMethod.Get);
    metric.start();
    try {
      await _appendSpecificHeaders();
      var response = await http.get(_uri(endpoint)!, headers: headers);
      if (response.statusCode == 401) {
        await UserProvider.refreshToken();
        response = await http.get(_uri(endpoint)!, headers: headers);
      }
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = response.request!.contentLength
        ..httpResponseCode = response.statusCode;

      return response;
    } catch (e) {
      print(e);
      // return null;
    } finally {
      await metric.stop();
    }
  }

  /// performs a HTTP POST request
  /// [endpoint] Endpoint URL on the server (trailing / should be omitted)
  /// [body] is a map of all data fields submitted to the server
  @protected
  Future<http.Response?> post(String endpoint, dynamic body) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(_uri(endpoint).toString(), HttpMethod.Post);
    metric.start();
    try {
      await _appendSpecificHeaders();
      var response = await http.post(_uri(endpoint)!,
          headers: headers, body: body, encoding: encoding);
      if (response.statusCode == 401) {
        await UserProvider.refreshToken();
        response = await http.post(_uri(endpoint)!,
            headers: headers, body: body, encoding: encoding);
      }
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = response.request!.contentLength
        ..httpResponseCode = response.statusCode;
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      await metric.stop();
    }
  }

  /// preforms a HTTP PUT request
  /// [endpoint] Endpoint URL on the server (trailing / should be omitted)
  /// [body] is a map of all data fields submitted to the server
  @protected
  Future<http.Response?> put(String endpoint, dynamic body) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(_uri(endpoint).toString(), HttpMethod.Put);
    metric.start();
    try {
      await _appendSpecificHeaders();
      var response = await http.put(_uri(endpoint)!,
          headers: headers, body: body, encoding: encoding);
      if (response.statusCode == 401) {
        await UserProvider.refreshToken();
        response = await http.put(_uri(endpoint)!,
            headers: headers, body: body, encoding: encoding);
      }
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = response.request!.contentLength
        ..httpResponseCode = response.statusCode;
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      await metric.stop();
    }
  }

  /// preforms a HTTP PATCH request
  /// [endpoint] Endpoint URL on the server (trailing / should be omitted)
  /// [body] is a map of all data fields submitted to the server
  @protected
  Future<http.Response?> patch(String endpoint, dynamic body) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(_uri(endpoint).toString(), HttpMethod.Patch);
    metric.start();
    try {
      await _appendSpecificHeaders();
      var response = await http.patch(_uri(endpoint)!,
          headers: headers, body: body, encoding: encoding);
      if (response.statusCode == 401) {
        await UserProvider.refreshToken();
        response = await http.patch(_uri(endpoint)!,
            headers: headers, body: body, encoding: encoding);
      }
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = response.request!.contentLength
        ..httpResponseCode = response.statusCode;
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      await metric.stop();
    }
  }

  /// preforms a HTTP DELETE request
  /// [endpoint] Endpoint URL on the server (trailing / should be omitted)
  @protected
  Future<http.Response?> delete(String endpoint) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(_uri(endpoint).toString(), HttpMethod.Delete);
    metric.start();
    try {
      await _appendSpecificHeaders();
      var response = await http.delete(_uri(endpoint)!, headers: headers);
      if (response.statusCode == 401) {
        await UserProvider.refreshToken();
        response = await http.delete(_uri(endpoint)!, headers: headers);
      }
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = response.request!.contentLength
        ..httpResponseCode = response.statusCode;
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      await metric.stop();
    }
  }

  /// used only for refreshing the login.
  /// No additional headers will be appended here
  @protected
  Future<http.Response?> internalRefreshToken(
      String endpoint, dynamic body) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(_uri(endpoint).toString(), HttpMethod.Post);
    metric.start();
    try {
      await _appendSpecificHeaders(isRefresh: true);
      var response =
          await http.post(_uri(endpoint)!, headers: headers, body: body);
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = response.request!.contentLength
        ..httpResponseCode = response.statusCode;
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      await metric.stop();
    }
  }

  //---------------------------------------------

  /// Adds http headers that are essential for the backend to validate
  Future<void> _appendSpecificHeaders({bool isRefresh = false}) async {
    if (!headers.containsKey('User-Agent')) {
      var packageInfo = await PackageInfo.fromPlatform();
      headers.putIfAbsent(
          'User-Agent',
          () =>
              '${packageInfo.appName} (v:${packageInfo.version}; b:${packageInfo.buildNumber}; os:${Platform.operatingSystem}; osv:${Platform.operatingSystemVersion}; pv:${Platform.version})');
    }
    //debugPrint('CustomAuthorizationHeader: ' + (!isRefresh && !headers.containsKey('Authorization')).toString());
    //debugPrint('Header: ' + headers['Authorization'].toString());
    if (!isRefresh && !headers.containsKey('Authorization')) {
      var type = 'Bearer';
      var credentials = await UserProvider.getJwtToken();
      //debugPrint('$type $credentials');
      if (credentials != null) {
        headers.putIfAbsent('Authorization', () => '$type $credentials');
      }
    }
    //debugPrint('Header: ' + headers['Authorization'].toString());
  }
}
