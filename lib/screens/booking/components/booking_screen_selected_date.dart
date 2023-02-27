import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class BookingScreenSelectedDate extends StatefulWidget {
  final DateTime date;

  const BookingScreenSelectedDate({
    this.date,
  });

  @override
  State<StatefulWidget> createState() => _BookingScreenSelectedDateState();
}

class _BookingScreenSelectedDateState extends State<BookingScreenSelectedDate> {
  @override
  void initState() {
    initializeDateFormatting('de', null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.getScaledSize(48),
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.getScaledSize(24),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.getScaledSize(10),
        vertical: Dimensions.getScaledSize(10),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomTheme.mediumGrey,
        ),
        borderRadius: BorderRadius.circular(
          Dimensions.getScaledSize(8),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.access_time_outlined,
            size: Dimensions.getScaledSize(18),
            color: CustomTheme.primaryColorDark,
          ),
          SizedBox(
            width: Dimensions.getScaledSize(5.0),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.getScaledSize(2.0),
            ),
            child: Text(
              "${DateFormat("EEEE, dd. LLL yyyy", "de-DE").format(widget.date)}",
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(15),
                color: CustomTheme.primaryColorDark,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            width: Dimensions.getScaledSize(5.0),
          ),
          Icon(
            Icons.check,
            size: Dimensions.getScaledSize(20.0),
            color: CustomTheme.accentColor2,
          ),
        ],
      ),
    );
  }
}
