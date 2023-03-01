import 'dart:ui';

import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'customCalendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarPopupView extends StatefulWidget {
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final bool? barrierDismissible;
  final DateTime? initialDate;
  final Function(DateTime)? onApplyClick;
  final Function? onCancelClick;
  final List<DateTime>? closedDates;
  final bool? usedForVendor;

  const CalendarPopupView({
    Key? key,
    this.initialDate,
    this.onApplyClick,
    this.onCancelClick,
    this.barrierDismissible = true,
    this.minimumDate,
    this.maximumDate,
    this.closedDates = const [],
    this.usedForVendor,
  }) : super(key: key);

  @override
  _CalendarPopupViewState createState() => _CalendarPopupViewState();
}

class _CalendarPopupViewState extends State<CalendarPopupView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  DateTime? date;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    if (widget.initialDate != null) {
      date = widget.initialDate;
    }
    animationController!.forward();
    super.initState();
    initializeDateFormatting('de', null);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext, Widget) {
            return AnimatedOpacity(
              duration: Duration(milliseconds: 100),
              opacity: animationController!.value,
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  if (widget.barrierDismissible!) Navigator.pop(context);
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.getScaledSize(24.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(CustomTheme.borderRadius)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: CustomTheme.grey,
                              offset: Offset(4, 4),
                              blurRadius: Dimensions.getScaledSize(8.0)),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimensions.getScaledSize(24.0))),
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: Dimensions.getScaledSize(10.0),
                                bottom: Dimensions.getScaledSize(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  date != null
                                      ? DateFormat("EEE, dd MMM", "de-DE")
                                          .format(date!)
                                      : "--/-- ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.getScaledSize(16.0),
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              height: Dimensions.getScaledSize(1.0),
                            ),
                            CustomCalendarView(
                              minimumDate: widget.minimumDate!,
                              maximumDate: widget.maximumDate!,
                              initialDate: widget.initialDate!,
                              startEndDateChange: (DateTime dateData) {
                                setState(() {
                                  date = dateData;
                                });
                              },
                              closedDates: widget.closedDates!,
                              usedForVendor: widget.usedForVendor!,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(16.0),
                                  right: Dimensions.getScaledSize(16.0),
                                  bottom: Dimensions.getScaledSize(16.0),
                                  top: Dimensions.getScaledSize(8.0)),
                              child: Container(
                                height: Dimensions.getScaledSize(48.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          CustomTheme.borderRadius)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: CustomTheme.grey,
                                      blurRadius: Dimensions.getScaledSize(8.0),
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            CustomTheme.borderRadius)),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      try {
                                        // animationController.reverse().then((f) {

                                        // });
                                        widget.onApplyClick!(date!);
                                        Navigator.pop(context);
                                      } catch (e) {}
                                    },
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .actions_confirm,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Dimensions.getScaledSize(18.0),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
