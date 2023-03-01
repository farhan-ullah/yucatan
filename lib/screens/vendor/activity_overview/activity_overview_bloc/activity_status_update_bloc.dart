import 'dart:async';
import 'package:yucatan/services/response/vendor_activty_object.dart';
import 'package:yucatan/services/response/vendor_activty_overview_response.dart';
import 'package:yucatan/services/vendor_activity_overview.dart';

class ActivityStatusUpdateBloc {
  final _stateStreamController = StreamController<VendorActivtyObject>();
  StreamSink<VendorActivtyObject> get _activtyStatusUpdateSink =>
      _stateStreamController.sink;
  Stream<VendorActivtyObject> get activtyStatusUpdateStream =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<VendorActivityOverviewData>();
  StreamSink<VendorActivityOverviewData> get eventSink =>
      _eventStreamController.sink;
  Stream<VendorActivityOverviewData> get _eventStream =>
      _eventStreamController.stream;

  ActivityStatusUpdateBloc() {
    _eventStream.listen((vendorActivityOverviewData) async {
      VendorActivtyObject? vendorActivtyObject =
          await VendorActivityOverviewService.updateActivityStatus(
              vendorActivityOverviewData);
      if (vendorActivtyObject != null) {
        _activtyStatusUpdateSink.add(vendorActivtyObject);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
