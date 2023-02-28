import 'package:yucatan/utils/datefulWidget/GlobalDateEvent.dart';
import 'package:flutter/material.dart';

abstract class DateStatefulWidget extends StatefulWidget {
  const DateStatefulWidget({Key? key}) : super(key: key);

  @override
  DateState<DateStatefulWidget> createState();
}

abstract class DateState<T extends DateStatefulWidget> extends State<T> {
  /// Abstract Function to handle events emitted from the GlobalDateEvent
  onDateChanged(DateTime dateTime);

  @override
  void initState() {
    // registering the event
    GlobalDateEvent.registerListener(onDateChanged);
    super.initState();
  }

  @override
  void dispose() {
    // unregistering the event
    // If not, the Widget instance would not fully dispose and remain in memory! -> mem-leak
    GlobalDateEvent.unregisterListener(onDateChanged);
    super.dispose();
  }
}
