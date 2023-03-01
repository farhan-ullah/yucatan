import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/components/custom_app_bar.dart';
import 'package:yucatan/services/response/vendor_activty_overview_response.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/common_widgets.dart';
import 'package:yucatan/utils/image_util.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/network_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'activity_overview_bloc/activity_overview_bloc.dart';
import 'activity_overview_bloc/activity_status_update_bloc.dart';
import 'components/vendor_activity_overview_shimmer.dart';
import 'dart:math' as math;
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VendorActivityOverview extends StatefulWidget {
  VendorActivityOverview();

  @override
  _VendorActivityOverviewState createState() {
    return _VendorActivityOverviewState();
  }
}

class _VendorActivityOverviewState extends State<VendorActivityOverview> {
  bool isLoading = false;
  bool isNetworkAvailable = true;
  VendorActivtyOverviewResponse? vendorActivityOverviewResponse;
  bool showOfferDeactivated = false;
  final activityOverviewBloc = ActivityOverviewBloc();
  final activityStatusUpdateBloc = ActivityStatusUpdateBloc();
  int? index;
  Future<bool>? future;

  @override
  void initState() {
    super.initState();
    future = checkInternetConnection();
    showOfferDeactivated = false;
    activityOverviewBloc.eventSink.add(ActivityOverviewAction.Fetch);
    activityStatusUpdateBloc.activtyStatusUpdateStream
        .listen((vendorActivityObject) {
      Navigator.pop(context); //hide loader
      if (vendorActivityObject.errorResponse != null) {
        CommonWidget.showToast(
            vendorActivityObject.errorResponse!.errors!.message!);
      } else {
        vendorActivityOverviewResponse!.data![index!] =
            vendorActivityObject.data!;
        activityOverviewBloc
            .getUpdatedActivityOverviewList(vendorActivityOverviewResponse!);
        activityOverviewBloc.eventSink
            .add(ActivityOverviewAction.UpdateActivityList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(
            elevation: 0,
          ),
          title: AppLocalizations.of(context)!.activity_overview_appbar_title,
          centerTitle: true,
          backgroundColor: CustomTheme.primaryColorLight,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: Dimensions.getScaledSize(20.0)),
              child: NotificationView(
                negativePadding: false,
              ),
            )
          ],
        ),
        body: StreamBuilder<bool>(
          stream: future!.asStream(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CommonWidget.showSpinner();
              default:
                if (snapshot.hasError) {
                  return CommonWidget.showSpinner();
                } else {
                  this.isNetworkAvailable = snapshot.data!;
                  return this.isNetworkAvailable
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: isNetworkAvailable
                              ? CustomTheme.vendorMenubackground
                              : Colors.white,
                          child: StreamBuilder<VendorActivtyOverviewResponse>(
                            stream: activityOverviewBloc.activtyOverviewStream,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return showShimmerView();
                                default:
                                  if (snapshot.hasError) {
                                    return Center(child: Text(''));
                                  } else {
                                    this.vendorActivityOverviewResponse =
                                        snapshot.data;
                                    return Stack(
                                      children: [
                                        showActivityOverviewList(),
                                        Visibility(
                                          visible: showOfferDeactivated,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: double.infinity,
                                              height: Dimensions.getHeight(
                                                  percentage: 30),
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  ColoredDivider(
                                                    height: Dimensions
                                                        .getScaledSize(3.0),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: IconButton(
                                                          icon: Icon(
                                                            Icons.clear,
                                                            color: CustomTheme
                                                                .primaryColorDark,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              showOfferDeactivated =
                                                                  showOfferDeactivated
                                                                      ? false
                                                                      : true;
                                                            });
                                                          })),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Transform.rotate(
                                                        angle:
                                                            180 * math.pi / 180,
                                                        child: Icon(
                                                          Icons.info_outline,
                                                          color: CustomTheme
                                                              .accentColor1,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions
                                                            .getScaledSize(
                                                                10.0),
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .activity_overview_offer_deactivated_text,
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .getScaledSize(
                                                                  20.0),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: CustomTheme
                                                              .accentColor1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: Dimensions.getWidth(
                                                          percentage: 22),
                                                      top: Dimensions
                                                          .getScaledSize(20.0),
                                                      bottom: Dimensions
                                                          .getScaledSize(0.0),
                                                      right:
                                                          Dimensions.getWidth(
                                                              percentage: 22),
                                                    ),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .activity_overview_offer_deactivated_message,
                                                      style: TextStyle(
                                                        fontSize: Dimensions
                                                            .getScaledSize(
                                                                16.0),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: CustomTheme
                                                            .primaryColorDark,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              }
                            },
                          ),
                        )
                      : showPlaceholderWidget();
                }
            }
          },
        ));
  }

  Widget showActivityOverviewList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: vendorActivityOverviewResponse!.data!.length,
        itemBuilder: (context, index) {
          VendorActivityOverviewData vendorActivityOverviewData =
              vendorActivityOverviewResponse!.data![index];
          //print("publishingStatus=${vendorActivityOverviewData.publishingStatus}");
          return Container(
            margin: EdgeInsets.only(
                left: Dimensions.getScaledSize(12.0),
                top: Dimensions.getScaledSize(15.0),
                bottom: Dimensions.getScaledSize(5.0),
                right: Dimensions.getScaledSize(12.0)),
            width: MediaQuery.of(context).size.width,
            height: Dimensions.getHeight(percentage: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.getScaledSize(16.0))),
              color: CustomTheme.primaryColorLight,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: Dimensions.getScaledSize(6.0),
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Dimensions.getHeight(percentage: 16),
                  width: Dimensions.getWidth(percentage: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: vendorActivityOverviewData.thumbnail == null
                        ? Container()
                        : loadCachedNetworkImage(
                            vendorActivityOverviewData.thumbnail!.publicUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.getScaledSize(15.0),
                        top: Dimensions.getScaledSize(15.0),
                        bottom: Dimensions.getScaledSize(10.0),
                        right: Dimensions.getScaledSize(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${vendorActivityOverviewData.title}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(15.0),
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Switch(
                  onChanged: (value) async {
                    bool isNetworkAvailable =
                        await NetworkUtils.isNetworkAvailable();
                    if (isNetworkAvailable) {
                      showLoader(context); //show loader
                      this.index = index;
                      activityStatusUpdateBloc.eventSink
                          .add(vendorActivityOverviewData);
                    }
                  },
                  value: vendorActivityOverviewData.publishingStatus == "Active"
                      ? true
                      : false,
                  activeColor: Colors.white,
                  activeTrackColor: CustomTheme.accentColor2,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: CustomTheme.accentColor1,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget showPlaceholderWidget() {
    return ImageUtil.showPlaceholderView(onUpdateBtnClicked: () async {
      bool isNetworkAvailable = await NetworkUtils.isNetworkAvailable();
      if (isNetworkAvailable) {
        setState(() {
          future = checkInternetConnection();
          future!.whenComplete(() {
            activityOverviewBloc.eventSink.add(ActivityOverviewAction.Fetch);
          });
        });
      }
    });
  }

  void showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(
                    CustomTheme.theme.primaryColorDark)),
          );
        });
  }

  Widget showShimmerView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return VendorActivityOverviewListViewShimmer(
            width: MediaQuery.of(context).size.width,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    activityOverviewBloc.dispose();
    activityStatusUpdateBloc.dispose();
    super.dispose();
  }

  Future<bool> checkInternetConnection() {
    return NetworkUtils.isNetworkAvailable();
  }
}
