import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'connection.dart';

class NetworkObserver extends ChangeNotifier {
  late StreamSubscription<ConnectivityResult> subscription;

  Connection connection = Connection.Disconnected;
  bool offline = true;

  NetworkObserver() {
    this.subscription =
        Connectivity().onConnectivityChanged.listen(this.connectivityChanged);
    this.checkConnectivity();
  }

  void connectivityChanged(ConnectivityResult result) {
    print('connectivityChanged to ' + result.toString());

    var value = Connection.Disconnected;

    if (result == ConnectivityResult.wifi) {
      value = Connection.Wifi;
    } else if (result == ConnectivityResult.mobile) {
      value = Connection.MobileData;
    }

    this.setConnection(value);
  }

  void setConnection(Connection value) {
    if (value != this.connection) {
      this.offline = value != Connection.MobileData && value != Connection.Wifi;
      this.connection = value;
      this.notifyListeners();
    }
  }

  Future<void> checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    this.connectivityChanged(result);
  }

  @override
  dispose() {
    this.subscription.cancel();
    super.dispose();
  }
}
