import 'dart:async';
import 'package:yucatan/services/vendor_accountbalance_response.dart';
import 'package:yucatan/services/vendor_payouts.dart';
import 'package:rxdart/rxdart.dart';

enum VendorAccountBalanceAction { FetchVendorAccountBalance }

class VendorAccountBalanceBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<VendorAccountBalanceResponse> _stateStreamController =
      new PublishSubject();
  StreamSink<VendorAccountBalanceResponse> get _vendorAccountBalanceSink =>
      _stateStreamController.sink;
  Stream<VendorAccountBalanceResponse> get vendorAccountBalanceStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<VendorAccountBalanceAction> _eventStreamController =
      new PublishSubject();
  StreamSink<VendorAccountBalanceAction> get eventSink =>
      _eventStreamController.sink;
  Stream<VendorAccountBalanceAction> get _eventStream =>
      _eventStreamController.stream;

  VendorAccountBalanceBloc() {
    _eventStream.listen((event) async {
      if (event == VendorAccountBalanceAction.FetchVendorAccountBalance) {
        VendorAccountBalanceResponse? response =
            await VendorPayouts.getAccountBalanceForVendor();
        _vendorAccountBalanceSink.add(response!);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
