import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

class OnAppLinkClick {
  String link;
  OnAppLinkClick(this.link);
}

class OnMapClickCallback {
  bool showAppBar;
  OnMapClickCallback(this.showAppBar);
}

class OnOpenSearch{
  OnOpenSearch();
}

class OnSearchPopUpOpen{
  bool isSearchPopWidgetVisible;
  OnSearchPopUpOpen(this.isSearchPopWidgetVisible);
}

class OnDeepLinkClick{
  String activityID;
  OnDeepLinkClick(this.activityID);
}

// ignore: camel_case_types
class onFavDeleted{
  bool onFavItemDeleted;
  onFavDeleted(this.onFavItemDeleted);
}
