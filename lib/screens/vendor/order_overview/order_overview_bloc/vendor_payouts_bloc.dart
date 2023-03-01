import 'dart:async';
import 'package:yucatan/services/response/vendor_payouts_response.dart';
import 'package:yucatan/services/vendor_payouts.dart';
import 'package:rxdart/rxdart.dart';

enum VendorPayoutAction { FetchPayoutData }

class VendorPayoutsBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<VendorPayoutsResponse> _stateStreamController =
      new PublishSubject();
  StreamSink<VendorPayoutsResponse> get _vendorPayoutSink =>
      _stateStreamController.sink;
  Stream<VendorPayoutsResponse> get vendorPayoutStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<VendorPayoutAction> _eventStreamController =
      new PublishSubject();
  StreamSink<VendorPayoutAction> get eventSink => _eventStreamController.sink;
  Stream<VendorPayoutAction> get _eventStream => _eventStreamController.stream;

  VendorPayoutsBloc() {
    _eventStream.listen((event) async {
      if (event == VendorPayoutAction.FetchPayoutData) {
        VendorPayoutsResponse? response =
            await VendorPayouts.getPayoutsForVendor();
        _vendorPayoutSink.add(response!);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
