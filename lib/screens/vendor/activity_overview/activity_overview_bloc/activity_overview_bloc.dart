import 'dart:async';
import 'package:yucatan/services/response/vendor_activty_overview_response.dart';
import 'package:yucatan/services/vendor_activity_overview.dart';

enum ActivityOverviewAction { Fetch, UpdateActivityList }

class ActivityOverviewBloc {
  //This StreamController is used to update the state of widgets
  final _stateStreamController =
      StreamController<VendorActivtyOverviewResponse>();
  StreamSink<VendorActivtyOverviewResponse> get _activtyOverviewSink =>
      _stateStreamController.sink;
  Stream<VendorActivtyOverviewResponse> get activtyOverviewStream =>
      _stateStreamController.stream;

  //user input event StreamController
  final _eventStreamController = StreamController<ActivityOverviewAction>();
  StreamSink<ActivityOverviewAction> get eventSink =>
      _eventStreamController.sink;
  Stream<ActivityOverviewAction> get _eventStream =>
      _eventStreamController.stream;

  ActivityOverviewBloc() {
    _eventStream.listen((event) async {
      if (event == ActivityOverviewAction.Fetch) {
        VendorActivtyOverviewResponse? activtyOverviewResponse =
            await VendorActivityOverviewService.getVendorActivityOverview();
        if (activtyOverviewResponse != null) {
          _activtyOverviewSink.add(activtyOverviewResponse);
        } else {
          _activtyOverviewSink.addError("Something went wrong");
        }
      }
      if (event == ActivityOverviewAction.UpdateActivityList) {
        _activtyOverviewSink.add(this.vendorActivityOverviewResponse!);
      }
    });
  }

  VendorActivtyOverviewResponse? vendorActivityOverviewResponse;
  getUpdatedActivityOverviewList(
      VendorActivtyOverviewResponse vendorActivityOverviewResponse) {
    this.vendorActivityOverviewResponse = vendorActivityOverviewResponse;
    return vendorActivityOverviewResponse;
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
