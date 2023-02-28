import 'package:yucatan/components/black_divider.dart';
import 'package:yucatan/components/custom_app_bar.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/hotelDetailes/description_items.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailedDescriptionScreenView extends StatefulWidget {
  final ActivityModel activity;

  DetailedDescriptionScreenView({required this.activity});

  @override
  _DetailedDescriptionScreenViewState createState() =>
      _DetailedDescriptionScreenViewState();
}

class _DetailedDescriptionScreenViewState
    extends State<DetailedDescriptionScreenView> {
  @override
  Widget build(BuildContext context) {
    _sortOpeningHours();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.getScaledSize(20.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: Dimensions.getScaledSize(5.0),
                  bottom: Dimensions.getScaledSize(5.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: Dimensions.getScaledSize(22.0),
                      width: Dimensions.getScaledSize(22.0),
                      child: Icon(
                        Icons.coronavirus_outlined,
                        size: Dimensions.getScaledSize(22.0),
                        color: CustomTheme.accentColor1,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.getScaledSize(10.0),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Covid-19: Schutzmaßnahmen",
                          style: TextStyle(
                            color: CustomTheme.accentColor1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(10.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              child: Text(
                'Es gelten die regional bestimmten Sicherheits- und Hygienemaßnahmen',
              ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(20.0),
            ),
            BlackDivider(),
            SizedBox(
              height: Dimensions.getScaledSize(20.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Dimensions.getScaledSize(5.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: Dimensions.getScaledSize(22.0),
                      width: Dimensions.getScaledSize(22.0),
                      child: Icon(
                        Icons.info_outline,
                        size: Dimensions.getScaledSize(22.0),
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.getScaledSize(10.0),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Vollständige Beschreibung",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(10.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              child: Text(
                widget.activity.activityDetails.longDescription,
              ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(20.0),
            ),
            BlackDivider(
              height: Dimensions.getScaledSize(1.0),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(15.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              child: DescriptionItems(
                descriptionItems:
                    widget.activity.activityDetails.descriptionItems,
                shortDescription: false,
              ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(15.0),
            ),
            BlackDivider(
              height: Dimensions.getScaledSize(1.0),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(20.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Dimensions.getScaledSize(5.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: Dimensions.getScaledSize(22.0),
                      width: Dimensions.getScaledSize(22.0),
                      child: Icon(
                        Icons.access_time_outlined,
                        size: Dimensions.getScaledSize(22.0),
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.getScaledSize(10.0),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Öffnungszeiten",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(10.0),
            ),
            Container(
              margin: EdgeInsets.only(
                left: Dimensions.getScaledSize(24.0),
                right: Dimensions.getScaledSize(24.0),
              ),
              child: _shouldDisplayOpeningHours()
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget
                            .activity.openingHours.regularOpeningHours.length,
                        itemBuilder: (BuildContext context, int index) {
                          RegularOpeningHours regularOpeningHours = widget
                              .activity.openingHours.regularOpeningHours[index];
                          DateTime date = DateTime.now();
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        Icons.list,
                                        color: Colors.white,
                                        size: Dimensions.getScaledSize(22.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.getScaledSize(10.0),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: Dimensions.getScaledSize(3),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              "${_getDayFromDayOfWeek(regularOpeningHours.dayOfWeek)}",
                                              style: TextStyle(
                                                fontWeight: date.weekday ==
                                                        regularOpeningHours
                                                            .dayOfWeek
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            width:
                                                Dimensions.getScaledSize(120.0),
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width:
                                                Dimensions.getScaledSize(30.0),
                                          ),
                                          regularOpeningHours.open
                                              ? Expanded(
                                                  child: ListView.builder(
                                                      itemCount:
                                                          regularOpeningHours
                                                              .openingHours
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        OpeningHoursItem
                                                            openingHoursItem =
                                                            regularOpeningHours
                                                                    .openingHours[
                                                                index];
                                                        return Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  Dimensions
                                                                      .getScaledSize(
                                                                          5.0)),
                                                          child: Text(
                                                            "${openingHoursItem.start == null ? '' : openingHoursItem.start} - ${openingHoursItem.end == null ? '' : openingHoursItem.end}",
                                                            style: TextStyle(
                                                              fontWeight: date
                                                                          .weekday ==
                                                                      regularOpeningHours
                                                                          .dayOfWeek
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimensions.getScaledSize(10.0),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)
                          .detailedDescriptionScreen_noOpeningHours,
                    ),
            ),
            SizedBox(
              height: Dimensions.getScaledSize(20.0) +
                  MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.detailedDescriptionScreen_title,
        centerTitle: true,
        appBar: AppBar(),
      ),
    );
  }

  bool _shouldDisplayOpeningHours() {
    return widget.activity.openingHours.regularOpeningHours != null &&
        widget.activity.openingHours.regularOpeningHours.length > 0 &&
        widget.activity.openingHours.regularOpeningHours.any((element) =>
            element.openingHours != null &&
            element.openingHours.length > 0 &&
            element.openingHours.any((openingHoursElement) {
              return isNotNullOrEmpty(openingHoursElement.end) ||
                  isNotNullOrEmpty(openingHoursElement.start);
            }));
  }

  _getDayFromDayOfWeek(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return AppLocalizations.of(context)!.days_sunday;
      case 1:
        return AppLocalizations.of(context)!.days_monday;
      case 2:
        return AppLocalizations.of(context)!.days_tuesday;
      case 3:
        return AppLocalizations.of(context)!.days_wednesday;
      case 4:
        return AppLocalizations.of(context)!.days_thursday;
      case 5:
        return AppLocalizations.of(context)!.days_friday;
      case 6:
        return AppLocalizations.of(context)!.days_saturday;
    }
  }

  void _sortOpeningHours() {
    widget.activity.openingHours.regularOpeningHours.sort((a, b) {
      if (a.dayOfWeek == 0 && b.dayOfWeek == 0) {
        return 0;
      } else if (a.dayOfWeek == 0 && b.dayOfWeek != 0) {
        return 1;
      } else if (a.dayOfWeek != 0 && b.dayOfWeek == 0) {
        return -1;
      } else if (a.dayOfWeek == b.dayOfWeek) {
        return 0;
      } else if (a.dayOfWeek > b.dayOfWeek) {
        return 1;
      } else if (a.dayOfWeek < b.dayOfWeek) {
        return -1;
      }

      return 0;
    });
  }
}
