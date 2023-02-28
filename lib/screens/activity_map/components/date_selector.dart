import 'package:yucatan/screens/booking/components/calendarPopupView.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/datefulWidget/GlobalDate.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;

  const DateSelector({this.onDateSelected});

  @override
  State<StatefulWidget> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime selectedDate = GlobalDate.current();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "date_selector_1",
      backgroundColor: Colors.white,
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDemoDialog(context: context);
      },
      child: Icon(
        Icons.date_range_rounded,
        color: CustomTheme.primaryColorDark,
        size: Dimensions.getScaledSize(30.0),
      ),
    );
  }

  void showDemoDialog({BuildContext? context}) {
    showDialog(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialDate: selectedDate,
        onApplyClick: (DateTime date) {
          setState(() {
            if (date != null) {
              selectedDate = date;
              widget.onDateSelected!.call(selectedDate);
            }
          });
        },
        onCancelClick: () {},
        usedForVendor: false,
      ),
    );
  }
}
