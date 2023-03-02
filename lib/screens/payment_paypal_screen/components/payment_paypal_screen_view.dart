import 'package:yucatan/components/payment_processing_screen.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/screens/payment_credit_card_screen/components/payment_success_screen.dart';
import 'package:yucatan/screens/payment_paypal_screen/bloc/payment_paypal_bloc.dart';
import 'package:yucatan/services/response/paypal_payment_purchase_response.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentPaypalScreenView extends StatefulWidget {
  final OrderModel order;
  final ActivityModel activity;

  PaymentPaypalScreenView({
    required this.order,
    required this.activity,
  });

  @override
  _PaymentPaypalScreenViewState createState() =>
      _PaymentPaypalScreenViewState();
}

class _PaymentPaypalScreenViewState extends State<PaymentPaypalScreenView> {
  InAppWebViewController? webView;
  Future<PaypalPaymentPurchaseResponse>? paypalPaymentFuture;
  PaymentPaypalBloc bloc = PaymentPaypalBloc();

  @override
  void initState() {
    bloc.requestPayment(widget.order);
    _proceedResponse();
    super.initState();
  }

  void _proceedResponse() {
    bloc.getPaymentResponse.listen((event) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            future: event,
            activity: widget.activity,
            order: widget.order.products!,
            isPaypal: true,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<PaypalPaymentPurchaseResponse>(
        stream: bloc.paypalResponseStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!isNotNullOrEmpty(snapshot.data!.url!)) {
              return Center(
                  child: Text(AppLocalizations.of(context)!.commonWords_error));
            }
            return InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse(snapshot.data!.url!)),
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
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController? controller, Uri? url) {},
              onLoadStop: (InAppWebViewController? controller, Uri? url) async {
                if (url
                    .toString()
                    .contains('api/payments/execute-paypal-payment')) {
                  bloc.proceedPaymentResponse((await controller!.getHtml())!)!;
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return PaymentProcessingScreenBody();
        },
      ),
    );
  }
}
