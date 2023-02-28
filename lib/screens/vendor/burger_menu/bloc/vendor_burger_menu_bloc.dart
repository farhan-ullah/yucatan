import 'dart:async';

import 'package:yucatan/screens/vendor/burger_menu/vendor_burger_menu_screen.dart';
import 'package:rxdart/rxdart.dart';

class VendorBurgerMenuBloc {
  final _viewController = PublishSubject<bool>();
  final _webviewTabController = PublishSubject<WebViewValues>();

  Stream<bool> get viewStream => _viewController.stream;

  set setView(bool value) => _viewController.sink.add(value);

  Stream<WebViewValues> get webviewTabStream => _webviewTabController.stream;

  set setwebviewTab(WebViewValues value) =>
      _webviewTabController.sink.add(value);

  dispose() {
    _viewController.close();
    _webviewTabController.close();
  }
}
