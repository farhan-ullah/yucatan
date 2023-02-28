import 'package:yucatan/utils/datefulWidget/DateStatefulWidget.dart';
import 'package:flutter/material.dart';

class _DatefulExampleWidget extends DateStatefulWidget {
  // ignore: slash_for_doc_comments
  /**
   * By default the createState() returns a DateState and not a regular State object.
   *
   * The DateState is a regular WidgetState with the addition of a built-in
   * callback function if the GlobalDate changes.
   *
   * Any Widget that should support the GlobalDate in this way is required
   * to implement this createState() function instead of the default one.
   */
  @override
  DateState<DateStatefulWidget> createState() => _DatefulExampleState();
}

class _DatefulExampleState extends DateState<_DatefulExampleWidget> {
  // ignore: slash_for_doc_comments
  /**
   * This function below acts as a callback if the global date gets changed.
   *
   * It is designed in a way that the callback is only registered if the Widget is mounted.
   * This means the callback gets registered once initWidget() is called
   * and unregistered if dispose() is called.
   *
   * Therefore it's important that if needed, initWidget() and dispose()
   * ALWAYS call super.initWidgets() / super.dispose()
   *
   * If super.initWidget() is NOT called, the callback onDateChanged does not work.
   * If super.dispose() is NOT called, the callback and this the widget will stay in memory -> mem-leak
   */
  @override
  onDateChanged(DateTime dateTime) {
    // TODO: implement onDateChanged
    throw UnimplementedError();
  }

  // ignore: slash_for_doc_comments
  /**
   * Like everywhere else, this is the default functionto build the widget, no change here.
   */
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
