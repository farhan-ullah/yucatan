import 'dart:async';
import 'package:yucatan/services/response/vendor_dashboard_response.dart';
import 'package:yucatan/services/vendor_dashboard_service.dart';
import 'package:rxdart/rxdart.dart';

enum VendorDashboardAction { FetchDashboardData }

class VendorDashboardBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<VendorDashboardResponse> _stateStreamController =
      new PublishSubject();
  StreamSink<VendorDashboardResponse> get _vendorDashboardModelSink =>
      _stateStreamController.sink;
  Stream<VendorDashboardResponse> get vendorDashboardModelStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<VendorDashboardAction> _eventStreamController =
      new PublishSubject();
  StreamSink<VendorDashboardAction> get eventSink =>
      _eventStreamController.sink;
  Stream<VendorDashboardAction> get _eventStream =>
      _eventStreamController.stream;

  VendorDashboardBloc() {
    _eventStream.listen((event) async {
      if (event == VendorDashboardAction.FetchDashboardData) {
        VendorDashboardResponse ? vendorDashboardResponse =
            await VendorDashboardService.getVendorDashboardStats();
        _vendorDashboardModelSink.add(vendorDashboardResponse!);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
