import 'dart:async';

import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/screens/qr_scanner/components/booking_preview_card.dart';
import 'package:yucatan/screens/qr_scanner/components/overlay_painter.dart';
import 'package:yucatan/screens/qr_scanner/components/qr_feedback.dart';
import 'package:yucatan/screens/qr_scanner/components/qr_screen_scaffold.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/services/response/activity_single_response.dart';
import 'package:yucatan/services/response/booking_single_response_entity.dart';
import 'package:yucatan/size_config.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class QRScannerScreen extends StatefulWidget {
  static const String route = '/qr';

  @override
  _QRScannerState createState() => new _QRScannerState();
}

class _QRScannerState extends State<QRScannerScreen> {
  String qrCodeReference = '';
  Future<BookingSingleResponseEntity?>? booking;
  Future<ActivitySingleResponse>? activity;
  bool ticketRedeemed = false;
  bool _isRedeemedDialog = false;
  bool error = false;
  bool redeemedError = false;
  final QrCameraState qrCameraState = QrCameraState();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          QrCamera(
            qrCodeCallback: (code) => setState(() {
              if (qrCodeReference == "") {
                qrCodeReference = code!;
                booking = BookingService.getBookingByQrCodeReference(code);
              }
            }),
            notStartedBuilder: (_) {
              return Scaffold(
                backgroundColor: Colors.white,
              );
            },
            offscreenBuilder: (_) {
              return Scaffold(
                backgroundColor: Colors.white,
              );
            },
            onError: (_, object) {
              Timer(Duration(seconds: 2), () {
                qrCameraState.restart();
                _reset();
              });

              return Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                    height: SizeConfig.screenHeight! * 0.325,
                    width: SizeConfig.screenWidth! * 0.75,
                    margin: EdgeInsets.only(
                        top: SizeConfig.screenHeight! * 0.25,
                        left: SizeConfig.screenWidth! * 0.125),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.qrScreen_error,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: Dimensions.getScaledSize(22)),
                      ),
                    )),
              );
            },
          ),
          if (!error) _getOverlay(context),
          if (qrCodeReference == "" && !error) QrScreenScaffold(),
          if (qrCodeReference != "" && !ticketRedeemed) getPreviewBuilder(),
          if (ticketRedeemed && !redeemedError)
            QrFeedback(
              title: AppLocalizations.of(context)!.qrScreen_success,
              text: AppLocalizations.of(context)!.qrScreen_ticketUseSuccess,
              mode: "SUCCESS",
              goBack: _reset,
            ),
          if (ticketRedeemed && redeemedError)
            QrFeedback(
              title: AppLocalizations.of(context)!.qrScreen_error,
              text: AppLocalizations.of(context)!.qrScreen_ticketUseError,
              mode: "ERROR",
              goBack: _reset,
            ),
        ],
      ),
    );
  }

  _getOverlay(BuildContext context) {
    return CustomPaint(
        size: MediaQuery.of(context).size, painter: OverlayWithHolePainter());
  }

  _reset() {
    setState(() {
      qrCodeReference = "";
      ticketRedeemed = false;
      booking = null;
      activity = null;
      error = false;
      redeemedError = false;
      _isRedeemedDialog = false;
    });
  }

  redeemTicket() {
    Future<BookingSingleResponseEntity?> future =
        BookingService.setTicketToUsedForQr(qrCodeReference);
    future.then((value) {
      setState(() {
        ticketRedeemed = true;
        if (value!.error != null) redeemedError = true;
      });
    });
  }

  bool isResponseValid(var snapshot) {
    return snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data.data != null;
  }

  bool isError(var snapshot) {
    return snapshot.hasError ||
        snapshot.data != null && snapshot.data.data == null;
  }

  getPreviewBuilder() {
    return FutureBuilder<BookingSingleResponseEntity?>(
      future: booking,
      builder: (context, snapshotBooking) {
        if (isResponseValid(snapshotBooking)) {
          activity = ActivityService.getActivity(
              snapshotBooking.data!.data!.activity!);
          return FutureBuilder<ActivitySingleResponse>(
              future: activity,
              builder: (context, snapshotActivity) {
                if (isResponseValid(snapshotActivity)) {
                  BookingTicket ticket = snapshotBooking.data!.data!.tickets!
                      .firstWhere((ticket) => ticket.qr == qrCodeReference);

                  if (ticket.status == 'USED' && !_isRedeemedDialog) {
                    return QrFeedback(
                      title: AppLocalizations.of(context)!.qrScreen_error,
                      text: AppLocalizations.of(context)!
                          .qrScreen_ticketAlreadyRedeemedError,
                      mode: "REDEEMED",
                      goBack: () {
                        setState(() {
                          _isRedeemedDialog = true;
                        });
                      },
                    );
                  }

                  return BookingPreviewCard(
                    activityModel: snapshotActivity.data!.data!,
                    booking: snapshotBooking.data!.data!,
                    ticket: ticket,
                    goBack: _reset,
                    redeem: redeemTicket,
                    isAlreadyRedeemed: _isRedeemedDialog,
                  );
                } else if (isError(snapshotActivity)) {
                  return QrFeedback(
                    title: AppLocalizations.of(context)!.qrScreen_error,
                    text: AppLocalizations.of(context)!.qrScreen_ticketNotFound,
                    mode: "ERROR",
                    goBack: _reset,
                  );
                }
                return _CircularProgressDialog();
              });
        } else if (isError(snapshotBooking)) {
          return QrFeedback(
            title: AppLocalizations.of(context)!.qrScreen_error,
            text: AppLocalizations.of(context)!.qrScreen_ticketNotFound,
            mode: "ERROR",
            goBack: _reset,
          );
        }
        return _CircularProgressDialog();
      },
    );
  }
}

class _CircularProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.getScaledSize(24.0))),
        ),
        child: Container(
          height: displayHeight - (0.4 * displayHeight).round(),
          width: displayWidth - (0.1 * displayWidth.round()),
          child: Center(child: CircularProgressIndicator()),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.getScaledSize(24.0)),
            color: Colors.white,
          ),
        ));
  }
}
