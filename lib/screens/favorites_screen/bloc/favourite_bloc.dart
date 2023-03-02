import 'dart:async';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:rxdart/rxdart.dart';

enum GetActivityAction { FetchActivity }

class GetActivityBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<List<ActivitySingleResponse>> _stateStreamController =
      new PublishSubject();
  StreamSink<List<ActivitySingleResponse>> get _getActivitySink =>
      _stateStreamController.sink;
  Stream<List<ActivitySingleResponse>> get getActivtyStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<GetActivityAction> _eventStreamController =
      new PublishSubject();
  StreamSink<GetActivityAction> get eventSink => _eventStreamController.sink;
  Stream<GetActivityAction> get _eventStream => _eventStreamController.stream;

  GetActivityBloc() {
    _eventStream.listen((event) async {
      if (event == GetActivityAction.FetchActivity) {
        for (var activity in this.favoriteActivityList) {
          ActivitySingleResponse? activitySingleResponse =
              await ActivityService.getActivity(activity);
          activityList.add(activitySingleResponse!);
        }
        _getActivitySink.add(activityList);
      }
    });
  }
  List<ActivitySingleResponse> activityList = [];
  List<String> favoriteActivityList = [];
  void sendFavoriteActivities(List<String> favoriteActivityList) {
    if (activityList.isNotEmpty) {
      activityList.clear();
    }
    this.favoriteActivityList = favoriteActivityList;
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
