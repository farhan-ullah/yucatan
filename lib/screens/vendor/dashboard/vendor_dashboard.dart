import 'package:yucatan/components/BaseState.dart';
import 'package:yucatan/screens/favorites_screen/bloc/user_bloc.dart';
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'package:yucatan/screens/vendor/dashboard/components/date_box.dart';
import 'package:yucatan/screens/vendor/demand_screen/vendor_demand_screen.dart';
import 'package:yucatan/screens/vendor/order_overview/components/order_overview_screen_parameter.dart';
import 'package:yucatan/screens/vendor/order_overview/order_overview_screen.dart';
import 'package:yucatan/screens/vendor/statistic/vendor_statistic_screen.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/booking_overview_screen.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_categories.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_overview_screen_parameter.dart';
import 'package:yucatan/services/response/vendor_dashboard_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/service_locator.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/image_util.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';
import 'bloc/vendor_dashboard_bloc.dart';
import 'line_graph.dart';

class VendorDashboard extends StatefulWidget {
  VendorDashboard();

  @override
  _VendorDashboardState createState() {
    return _VendorDashboardState();
  }
}

class _VendorDashboardState extends BaseState<VendorDashboard> {
  String vendorName = "";
  UserLoginModel userObject;
  bool isLoading = false;

  //Future<VendorDashboardResponse> vendorDashboardResponse;

  double sidePadding = 0;
  double elementWidth = 0;
  double innerPadding = 0;

  double elementHeight = 0;
  double bigElementWidth = 0;
  double bigElementHeight = 0;

  //bloc
  final userLoginModelBloc = getIt<UserLoginModelBloc>();
  final vendorDashboardBloc = getIt<VendorDashboardBloc>();

  @override
  void initState() {
    userLoginModelBloc.eventSink.add(UserLoginAction.FetchLoggedInUser);
    sidePadding = 15;
    elementWidth = (SizeConfig.screenWidth / 3.45).round().toDouble();
    elementHeight = (SizeConfig.screenWidth / 3.2).round().toDouble();
    innerPadding =
        (SizeConfig.screenWidth - 2 * sidePadding - 3 * elementWidth) / 2;
    bigElementWidth = 2 * elementWidth + innerPadding;
    bigElementHeight = 2 * elementHeight + innerPadding;
    super.initState();
  }

  Widget getLoadingIndicator() {
    return Container(
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget getPlaceholderVeiw() {
    return Container(
        height: double.infinity,
        color: Colors.white,
        child: ImageUtil.showPlaceholderView(onUpdateBtnClicked: () async {
          if (!this.network.offline) {
            userLoginModelBloc.eventSink.add(UserLoginAction.FetchLoggedInUser);
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserLoginModel>(
      stream: userLoginModelBloc.userModelStream,
      builder: (context, snapshotUser) {
        if (this.network.offline) {
          return getPlaceholderVeiw();
        }
        if (snapshotUser.connectionState == ConnectionState.waiting)
          return getLoadingIndicator();

        if (snapshotUser.hasError ||
            snapshotUser.hasData && snapshotUser.data == null)
          return getPlaceholderVeiw();
        if (snapshotUser.hasData && snapshotUser.data != null) {
          this.userObject = snapshotUser.data;
          vendorDashboardBloc.eventSink
              .add(VendorDashboardAction.FetchDashboardData);
          return StreamBuilder<VendorDashboardResponse>(
            stream: vendorDashboardBloc.vendorDashboardModelStream,
            builder: (context, snapshotVendorResponse) {
              if (snapshotVendorResponse.connectionState ==
                  ConnectionState.waiting) isLoading = true;
              if (snapshotVendorResponse.hasData &&
                  snapshotVendorResponse.data != null) isLoading = false;
              if (snapshotVendorResponse.hasError ||
                  snapshotVendorResponse.hasData &&
                      snapshotVendorResponse.data.data == null)
                return getLoadingIndicator();

              return Container(
                  height: double.infinity,
                  color: CustomTheme.vendorMenubackground,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: Dimensions.getScaledSize(220.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.getScaledSize(20.0)),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "lib/assets/images/vendor_bg_image.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimensions.getScaledSize(20.0),
                                Dimensions.getScaledSize(
                                  MediaQuery.of(context).padding.top,
                                ),
                                Dimensions.getScaledSize(20.0),
                                Dimensions.getScaledSize(20.0)),
                            child: Container(
                              height: AppBar().preferredSize.height,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'lib/assets/images/appventure_logo_neg.svg',
                                    color: Colors.white,
                                    height: Dimensions.getScaledSize(30.0),
                                  ),
                                  NotificationView(
                                    negativePadding: true,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimensions.getScaledSize(20.0),
                                Dimensions.getScaledSize(120.0),
                                Dimensions.getScaledSize(20.0),
                                Dimensions.getScaledSize(20.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .vendor_dashboardScreen_hello,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(20.0),
                                    color: Colors.white,
                                    fontFamily: CustomTheme.fontFamily,
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(5.0),
                                ),
                                Text(
                                  "${this.userObject.firstname == null ? "" : this.userObject.firstname}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(20.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.getScaledSize(16.0)),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .vendor_dashboardScreen_wellcomeToDashboard,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: CustomTheme.primaryColorLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //Search bar gets implemented later on
                              //
                              // Container(
                              //     height: 45,
                              //     margin: EdgeInsets.fromLTRB(15, 15, 15, 10),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       border: Border.all(
                              //         color: Colors.white,
                              //       ),
                              //       borderRadius: BorderRadius.all(Radius.circular(10)),
                              //     ),
                              //     child: TextFormField(
                              //       cursorColor: Colors.black,
                              //       decoration: new InputDecoration(
                              //           border: InputBorder.none,
                              //           focusedBorder: InputBorder.none,
                              //           enabledBorder: InputBorder.none,
                              //           errorBorder: InputBorder.none,
                              //           disabledBorder: InputBorder.none,
                              //           contentPadding:
                              //           EdgeInsets.only(left: 14, bottom: 11, top: 11, right: 15),
                              //           hintStyle: TextStyle(fontSize: 15,color: CustomTheme.hintText),
                              //           suffixIcon: IconButton(
                              //             icon: Icon(Icons.search,color: CustomTheme.primaryColorLight),
                              //             onPressed: (){

                              //             },
                              //           ),
                              //           hintText: "Auf dor Suche nod, einem Namara ein Code?"),

                              //     )
                              // ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          OrderOverviewScreen.route,
                                          arguments:
                                              OrderOverviewScreenParameter(
                                                  vendorDashboardResponse:
                                                      snapshotVendorResponse
                                                          .data),
                                        );
                                      },
                                      child: Container(
                                        height: SizeConfig.screenHeight / 7,
                                        width: double.infinity,
                                        margin: EdgeInsets.fromLTRB(
                                            sidePadding, 0, sidePadding, 0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isLoading
                                                ? Colors.grey[300]
                                                : Color(0xffFBA300),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xffFBA300),
                                              Color(0xffFBA300),
                                              Color(0xffFBBF00),
                                              Color(0xffFBBF00)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0, 0.2, 0.8, 1],
                                          ),
                                        ),
                                        child: isLoading
                                            ? ImageUtil.showShimmerPlaceholder()
                                            : Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .account_balance_wallet_outlined,
                                                          size: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .vendor_dashboardScreen_accountInfo,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: CustomTheme
                                                                  .primaryColorDark,
                                                              fontFamily:
                                                                  CustomTheme
                                                                      .fontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //Date gets implemented later on
                                                  //
                                                  // Align(
                                                  //   alignment: Alignment.centerLeft,
                                                  //   child: Container(
                                                  //     margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                                  //     child: Text(
                                                  //       "Betrag bis 31.01.21",
                                                  //       textAlign: TextAlign.start,
                                                  //       style: TextStyle(
                                                  //         fontSize: 14,
                                                  //         color: Colors.white,
                                                  //         fontFamily: CustomTheme.fontFamily,
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 10, 10),
                                                      child: Text(
                                                        isLoading
                                                            ? "€"
                                                            : "${formatPriceDoubleWithCurrency(snapshotVendorResponse.data.data.accountBalance)}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: CustomTheme
                                                                .primaryColorDark,
                                                            fontFamily:
                                                                CustomTheme
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  //Weather gets implemented later on
                                  //
                                  // Container(
                                  //   height: SizeConfig.screenHeight / 4.2,
                                  //   width: SizeConfig.screenWidth / 3.2,
                                  //   margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       border: Border.all(
                                  //         color: Colors.white,
                                  //       ),
                                  //       borderRadius:
                                  //           BorderRadius.all(Radius.circular(10))),
                                  //   child: Column(
                                  //     children: [
                                  //       Row(
                                  //         children: [
                                  //           Align(
                                  //             child: Padding(
                                  //               padding:
                                  //                   const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                  //               child: Text(
                                  //                 "5",
                                  //                 textAlign: TextAlign.start,
                                  //                 style: TextStyle(
                                  //                     fontSize: 50,
                                  //                     color: CustomTheme.primaryColorLight,
                                  //                     fontFamily: CustomTheme.fontFamily,
                                  //                     fontWeight: FontWeight.w700),
                                  //               ),
                                  //             ),
                                  //             alignment: Alignment.centerLeft,
                                  //           ),
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.fromLTRB(5, 0, 0, 15),
                                  //             child: Text(
                                  //               "\u2103",
                                  //               textAlign: TextAlign.start,
                                  //               style: TextStyle(
                                  //                   fontSize: 16,
                                  //                   color: CustomTheme.primaryColorLight,
                                  //                   fontFamily: CustomTheme.fontFamily,
                                  //                   fontWeight: FontWeight.w700),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       Align(
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  //           child: Text(
                                  //             "Bedeckt",
                                  //             textAlign: TextAlign.start,
                                  //             style: TextStyle(
                                  //                 fontSize: 15,
                                  //                 color: CustomTheme.primaryColorLight,
                                  //                 fontFamily: CustomTheme.fontFamily,
                                  //                 fontWeight: FontWeight.w700),
                                  //           ),
                                  //         ),
                                  //         alignment: Alignment.centerLeft,
                                  //       ),
                                  //       Expanded(
                                  //         child: Container(),
                                  //       ),
                                  //       Align(
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  //           child: Text(
                                  //             "06.02.2021",
                                  //             textAlign: TextAlign.start,
                                  //             style: TextStyle(
                                  //                 fontSize: 15,
                                  //                 color: CustomTheme.primaryColorLight,
                                  //                 fontFamily: CustomTheme.fontFamily,
                                  //                 fontWeight: FontWeight.w700),
                                  //           ),
                                  //         ),
                                  //         alignment: Alignment.centerLeft,
                                  //       ),
                                  //       Align(
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                                  //           child: Text(
                                  //             "Sankt Englmar",
                                  //             textAlign: TextAlign.start,
                                  //             style: TextStyle(
                                  //                 fontSize: 15,
                                  //                 color: CustomTheme.primaryColorLight,
                                  //                 fontFamily: CustomTheme.fontFamily,
                                  //                 fontWeight: FontWeight.w700),
                                  //           ),
                                  //         ),
                                  //         alignment: Alignment.centerLeft,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                              Container(
                                height: bigElementHeight,
                                margin: EdgeInsets.fromLTRB(
                                    sidePadding, sidePadding, sidePadding, 0),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          VendorDashboardDateBox(
                                            boxText:
                                                AppLocalizations.of(context)
                                                    .today,
                                            elementHeight: elementHeight,
                                            elementWidth: elementWidth,
                                            isLoading: isLoading,
                                            onClick: () {
                                              Navigator.of(context).pushNamed(
                                                VendorBookingOverviewScreen
                                                    .route,
                                                arguments:
                                                    BookingOverviewScreenParameter(
                                                        buttonIndex: 0),
                                              );
                                            },
                                            openBookingsForDay: isLoading
                                                ? ""
                                                : "${snapshotVendorResponse.data.data.openBookingsForToday}",
                                          ),
                                          SizedBox(height: innerPadding),
                                          VendorDashboardDateBox(
                                            boxText:
                                                AppLocalizations.of(context)
                                                    .tomorrow,
                                            elementHeight: elementHeight,
                                            elementWidth: elementWidth,
                                            isLoading: isLoading,
                                            openBookingsForDay: isLoading
                                                ? ""
                                                : "${snapshotVendorResponse.data.data.openBookingsForTomorrow}",
                                            onClick: () {
                                              Navigator.of(context).pushNamed(
                                                VendorBookingOverviewScreen
                                                    .route,
                                                arguments:
                                                    BookingOverviewScreenParameter(
                                                        buttonIndex: 1),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: innerPadding),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isLoading
                                              ? Colors.grey[300]
                                              : Colors.white,
                                          border: Border.all(
                                            color: isLoading
                                                ? Colors.grey[300]
                                                : Colors.white,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: isLoading
                                            ? ImageUtil.showShimmerPlaceholder(
                                                width: double.infinity,
                                                height: double.infinity)
                                            : InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          VendorStatisticScreen
                                                              .route);
                                                },
                                                child: VendorStatisticGraph(),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: innerPadding),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sidePadding),
                                child: Row(
                                  children: [
                                    VendorDashboardDateBox(
                                      boxText: AppLocalizations.of(context)
                                          .commonWords_week,
                                      elementHeight: elementHeight,
                                      elementWidth: elementWidth,
                                      isLoading: isLoading,
                                      openBookingsForDay: isLoading
                                          ? ""
                                          : "${snapshotVendorResponse.data.data.openBookingsForWeek}",
                                      onClick: () {
                                        Navigator.of(context).pushNamed(
                                          VendorBookingOverviewScreen.route,
                                          arguments:
                                              BookingOverviewScreenParameter(
                                                  buttonIndex: 2),
                                        );
                                      },
                                    ),
                                    SizedBox(width: innerPadding),
                                    VendorDashboardDateBox(
                                      boxText: AppLocalizations.of(context)
                                          .commonWords_calendar,
                                      elementHeight: elementHeight,
                                      elementWidth: elementWidth,
                                      isLoading: isLoading,
                                      openBookingsForDay: "",
                                      onClick: () {
                                        Navigator.of(context).pushNamed(
                                          VendorBookingOverviewScreen.route,
                                          arguments:
                                              BookingOverviewScreenParameter(
                                                  buttonIndex: 3),
                                        );
                                      },
                                    ),
                                    SizedBox(width: innerPadding),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            VendorDemandScreen.route);
                                      },
                                      child: Container(
                                        height: elementHeight,
                                        width: elementWidth,
                                        decoration: BoxDecoration(
                                            color: isLoading
                                                ? Colors.grey[300]
                                                : Colors.white,
                                            border: Border.all(
                                              color: isLoading
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: isLoading
                                            ? ImageUtil.showShimmerPlaceholder(
                                                width: SizeConfig.screenWidth /
                                                    3.2,
                                                height: SizeConfig.screenWidth /
                                                    3.2)
                                            : Column(
                                                children: [
                                                  Align(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 10, 0, 0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .vendor_dashboardScreen_requirement,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: CustomTheme
                                                                .primaryColorLight,
                                                            fontFamily:
                                                                CustomTheme
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                  Align(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          10, 5, 0, 0),
                                                      child: Text(
                                                        isLoading
                                                            ? AppLocalizations
                                                                    .of(context)
                                                                .vendor_dashboardScreen_element
                                                            : "${snapshotVendorResponse.data.data.demandForToday} ${AppLocalizations.of(context)!.vendor_dashboardScreen_element}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: CustomTheme
                                                              .accentColor1,
                                                          fontFamily:
                                                              CustomTheme
                                                                  .fontFamily,
                                                        ),
                                                      ),
                                                    ),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                  ),
                                                  Expanded(child: Container()),
                                                  Align(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 10, 10),
                                                        child: Icon(
                                                            Icons
                                                                .calendar_today_outlined,
                                                            color: CustomTheme
                                                                .primaryColorLight)),
                                                    alignment:
                                                        Alignment.centerRight,
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: innerPadding),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sidePadding),
                                child: Row(
                                  children: [
                                    VendorDashboardDateBox(
                                      boxText: AppLocalizations.of(context)
                                          .vendor_dashboardScreen_offer,
                                      elementHeight: elementHeight,
                                      elementWidth: elementWidth,
                                      isLoading: isLoading,
                                      openBookingsForDay: "",
                                      onClick: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          MainScreen.route,
                                          arguments: MainScreenParameter(
                                            bottomNavigationBarIndex: 3,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: innerPadding),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            VendorBookingOverviewScreen.route,
                                            arguments:
                                                BookingOverviewScreenParameter(
                                              buttonIndex: -1,
                                              category: Category.REQUESTED,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: elementHeight,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Column(
                                            children: [
                                              Align(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 0, 0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .vendor_dashboardScreen_booking_requests,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: CustomTheme
                                                            .primaryColorLight,
                                                        fontFamily: CustomTheme
                                                            .fontFamily,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Align(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 0, 0),
                                                  child: Text(
                                                    isLoading
                                                        ? ""
                                                        : AppLocalizations.of(
                                                                context)
                                                            .vendor_dashboardScreen_requests(
                                                                snapshotVendorResponse
                                                                    .data
                                                                    .data
                                                                    .numberOfBookingRequests),
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: CustomTheme
                                                          .accentColor1,
                                                      fontFamily: CustomTheme
                                                          .fontFamily,
                                                    ),
                                                  ),
                                                ),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              Expanded(child: Container()),
                                              Align(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    0,
                                                    0,
                                                    10,
                                                    10,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .notifications_none_outlined,
                                                    color: CustomTheme
                                                        .accentColor1,
                                                  ),
                                                ),
                                                alignment:
                                                    Alignment.centerRight,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: sidePadding)
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            },
          );
        }

        return getPlaceholderVeiw();
      },
    );
  }
}
