import 'package:yucatan/components/payment_processing_screen.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/screens/payment_credit_card_screen/bloc/payment_3d_secure_bloc.dart';
import 'package:yucatan/screens/payment_credit_card_screen/components/payment_success_screen.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/response/payment_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentCreditCardScreenThreeDSecureView extends StatefulWidget {
  final Future<PaymentResponse> future;
  final ActivityModel activity;
  final List<OrderProduct> order;

  PaymentCreditCardScreenThreeDSecureView({
    required this.future,
    required this.activity,
    required this.order,
  });

  @override
  _PaymentCreditCardScreenThreeDSecureViewState createState() =>
      _PaymentCreditCardScreenThreeDSecureViewState();
}

class _PaymentCreditCardScreenThreeDSecureViewState
    extends State<PaymentCreditCardScreenThreeDSecureView> {
  InAppWebViewController? webView;
  Payment3DSecureBloc bloc = Payment3DSecureBloc();
  bool showWebView = true;

  @override
  void initState() {
    _get3dSecureResponse();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void _get3dSecureResponse() {
    bloc.getPaymentResponse.listen((event) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            future: event,
            activity: widget.activity,
            order: widget.order,
            isPaypal: false,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: FutureBuilder<PaymentResponse>(
          future: widget.future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.booking != null ||
                  snapshot.data!.threeDSecurePayment == null) {
                _proceedToSuccessScreen();
                return Container();
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<bool>(
                      stream: bloc.webviewStream,
                      builder: (context, snapshotWebview) {
                        showWebView = snapshotWebview.data ?? true;

                        if (!showWebView) {
                          return Container();
                        }

                        return InAppWebView(
                          initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  snapshot.data!.threeDSecurePayment!.url!)),
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                              useShouldOverrideUrlLoading: true,
                              mediaPlaybackRequiresUserGesture: false,
                            ),
                            android: AndroidInAppWebViewOptions(
                              useHybridComposition: true,
                            ),
                            ios: IOSInAppWebViewOptions(
                              allowsInlineMediaPlayback: true,
                            ),
                          ),
                          onWebViewCreated:
                              (InAppWebViewController controller) {
                            webView = controller;
                          },
                          onLoadStart:
                              (InAppWebViewController? controller, Uri? uri) {},
                          onLoadStop: (InAppWebViewController? controller,
                              Uri? url) async {
                            if (url.toString().contains(
                                'api/payments/confirm-creditcard-payment')) {
                              bloc.setWebview = false;
                              bloc.proceedPaymentResponse(await controller!
                                  .evaluateJavascript(
                                      source: 'document.body.innerHTML'));
                            }
                          },
                        );
                      }),
                );
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return PaymentProcessingScreen();
          },
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  bool _checkPaymentResponseBooking(BookingModel bookingModel) {
    return bookingModel != null && bookingModel.status != "ERROR";
  }

  _proceedToSuccessScreen() async {
    PaymentResponse paymentResponse = await widget.future;
    if (_checkPaymentResponseBooking(paymentResponse.booking!)) {
      HiveService.updateDatabase();
    }
    Future.delayed(Duration(milliseconds: 50), () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            future: widget.future,
            activity: widget.activity,
            isPaypal: false,
            order: widget.order,
          ),
        ),
      );
    });
  }
}
