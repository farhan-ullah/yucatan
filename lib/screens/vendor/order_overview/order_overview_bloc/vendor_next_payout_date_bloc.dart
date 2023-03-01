import 'dart:async';
import 'package:yucatan/services/response/vendor_next_payout_response.dart';
import 'package:yucatan/services/vendor_payouts.dart';
import 'package:rxdart/rxdart.dart';

enum VendorNextPayoutAction { FetchVendorNextPayout }

class VendorNextPayoutBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<VendorNextPayoutResponse> _stateStreamController =
      new PublishSubject();
  StreamSink<VendorNextPayoutResponse> get _vendorNextPayoutSink =>
      _stateStreamController.sink;
  Stream<VendorNextPayoutResponse> get vendorNextPayoutStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<VendorNextPayoutAction> _eventStreamController =
      new PublishSubject();
  StreamSink<VendorNextPayoutAction> get eventSink =>
      _eventStreamController.sink;
  Stream<VendorNextPayoutAction> get _eventStream =>
      _eventStreamController.stream;

  VendorNextPayoutBloc() {
    _eventStream.listen((event) async {
      if (event == VendorNextPayoutAction.FetchVendorNextPayout) {
        VendorNextPayoutResponse? response =
            await VendorPayouts.getNextPayoutForVendor();
        _vendorNextPayoutSink.add(response!);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
