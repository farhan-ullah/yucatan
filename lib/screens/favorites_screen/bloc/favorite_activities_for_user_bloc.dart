import 'dart:async';
import 'package:yucatan/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

enum FavoriteActivitiesForUserAction { FetchFavoriteActivitiesForUser }

class FavoriteActivitiesForUserBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<List<String>> _stateStreamController = new PublishSubject();
  StreamSink<List<String>> get _favoriteActivitiesForUserSink =>
      _stateStreamController.sink;
  Stream<List<String>> get favoriteActivitiesForUserStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<FavoriteActivitiesForUserAction> _eventStreamController =
      new PublishSubject();
  StreamSink<FavoriteActivitiesForUserAction> get eventSink =>
      _eventStreamController.sink;
  Stream<FavoriteActivitiesForUserAction> get _eventStream =>
      _eventStreamController.stream;

  FavoriteActivitiesForUserBloc() {
    _eventStream.listen((event) async {
      if (event ==
          FavoriteActivitiesForUserAction.FetchFavoriteActivitiesForUser) {
        List<String>? favoriteActivitiesForUserList =
            await UserService.getFavoriteActivitiesForUser(userId);
        _favoriteActivitiesForUserSink.add(favoriteActivitiesForUserList!);
      }
    });
  }
  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }

  late String userId;
  void setUserId(String userId) {
    this.userId = userId;
  }
}
