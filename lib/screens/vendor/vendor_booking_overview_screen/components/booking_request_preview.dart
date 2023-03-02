import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/transaction_model.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_loading_indicator.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_preview_button.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_preview_feedback.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_request_preview_body.dart';
import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/services/response/booking_single_response_entity.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

class VendorBookingRequestPreview extends StatefulWidget {
  final TransactionModel transactionModel;
  final Function requestAccepted;
  final Function requestDenied;
  final Function requestFailed;

  VendorBookingRequestPreview(
      {required this.transactionModel,
      required this.requestAccepted,
      required this.requestDenied,
      required this.requestFailed});
  createState() => _VendorBookingRequestPreviewState();
}

class _VendorBookingRequestPreviewState
    extends State<VendorBookingRequestPreview> {
  bool valid = true;
  Future<BookingSingleResponseEntity>? bookingModel;
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookingModel = BookingService.getBooking(widget.transactionModel.bookingId!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayHeight = MediaQuery.of(context).size.height;
    final displayWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: bookingModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return VendorBookingLoadingIndicator();
          }
          if (snapshot.hasData && !snapshot.hasError) {
            return _getBookingPreviev(
                displayWidth, displayHeight, snapshot.data as BookingModel);
          }
          if (snapshot.hasError) {
            return Container(
              child: VendorBookingPreviewFeedback(
                text: AppLocalizations.of(context)!.commonWords_error,
                textColor: CustomTheme.accentColor1,
              ),
            );
          }
          return VendorBookingLoadingIndicator();
        });
  }

  _getBookingPreviev(
      double displayWidth, double displayHeight, BookingModel bookingModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getScaledSize(20.0),
            vertical: Dimensions.getScaledSize(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VendorBookingPreviewBody(
              transactionModel: widget.transactionModel,
            ),
            ..._getBookingInfoProducts(
                displayWidth, displayHeight, bookingModel),
            SizedBox(height: 0.07 * displayHeight),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Text(
                        AppLocalizations.of(context)!
                            .bookingListScreen_inValueOf,
                        style: _getTextStyle(displayHeight * 0.015)),
                    Text(formatPriceDouble(widget.transactionModel.totalPrice!),
                        style: _getTextStyleBold(0.04 * displayHeight))
                  ],
                )
              ],
            ),
            SizedBox(
              height: displayHeight * 0.02,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: valid ? Colors.white : Colors.red[200],
                  border: _getBorderStyle(Colors.grey),
                  focusedBorder: _getBorderStyle(CustomTheme.primaryColor),
                  errorBorder: _getBorderStyle(Colors.red),
                  labelStyle:
                      TextStyle(color: valid ? Colors.grey : Colors.red),
                  labelText: AppLocalizations.of(context)!
                      .vendor_bookingOverview_reasonForDecline,
                ),
                minLines: 5,
                maxLines: 5,
                maxLength: 300,
                validator: (value) {
                  if (value == "") {
                    setValid(false);
                    return AppLocalizations.of(context)!
                        .vendor_bookingOverview_reasonForDeclineInvalid;
                  }
                  setValid(true);
                  return null;
                },
              ),
            ),
            SizedBox(
              height: displayHeight * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                VendorBookingPreviewButton(
                  color: CustomTheme.accentColor1,
                  buttonText: AppLocalizations.of(context)!
                      .vendor_bookingOverview_decline,
                  onPressed: denyRequest,
                  width: displayWidth * 0.3,
                  fontSize: displayHeight * 0.015,
                ),
                VendorBookingPreviewButton(
                  color: CustomTheme.accentColor2,
                  buttonText: AppLocalizations.of(context)!.actions_confirm,
                  onPressed: acceptRequest,
                  width: displayWidth * 0.3,
                  fontSize: displayHeight * 0.015,
                )
              ],
            ),
            SizedBox(
              height: 0.025 * displayHeight,
            )
          ],
        ),
      ),
    );
  }

  _getBorderStyle(Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(8)));
  }

/*  _getBookingInfo(
      double displayWidth, double displayHeight, BookingModel bookingModel) {
    List<Widget> widgets = [];
    bookingModel.tickets.forEach((ticket) {
      //get product
      BookingProduct product = bookingModel.products
          .firstWhere((element) => element.id == ticket.productId);
      //display category title
      widgets.add(Text(
        product.categoryTitle,
        style: _getTextStyleBold(displayHeight * 0.015),
      ));
      //display product title
      widgets.add(Text('1x ${product.title}',
          style: _getTextStyle(displayHeight * 0.015)));
      //display product property
      if (product.quantity <= 1)
        product.properties.forEach((productPropertyElemenet) {
          widgets.add(
            Text(
              '${productPropertyElemenet.value}',
              style: _getTextStyle(displayHeight * 0.015),
            ),
          );
        });
      //display adidional service
      ticket.additionalServiceInfo.forEach((additionalServiceInfoElement) {
        widgets.add(SizedBox(height: displayHeight * 0.005));

        var additionalService = product.additionalServices.firstWhere(
          (element) =>
              element.id == additionalServiceInfoElement.additionalServiceId,
          orElse: () => null,
        );

        widgets.add(
          Text(
            '${additionalServiceInfoElement.quantity}x ${additionalService.title}',
            style: _getTextStyle(displayHeight * 0.015),
          ),
        );
        if (additionalService.quantity <= 1)
          additionalService.properties
              .forEach((additionalServicePropertyElemenet) {
            widgets.add(
              Text(
                '${additionalServicePropertyElemenet.value}',
                style: _getTextStyle(displayHeight * 0.015),
              ),
            );
          });
      });
    });

    return widgets;
  }*/

  _getToastError() {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!
            .vendor_bookingOverview_requestProcessingError,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _getToastSuccess() {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!
            .vendor_bookingOverview_requestConfirmSuccess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _getToastDeny() {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!
            .vendor_bookingOverview_requestDeclineSuccess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _getTextStyle(fontSize) {
    return TextStyle(
      color: CustomTheme.primaryColor,
      fontFamily: CustomTheme.fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.w200,
    );
  }

  _getTextStyleBold(fontSize) {
    return TextStyle(
      color: CustomTheme.primaryColor,
      fontFamily: CustomTheme.fontFamily,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  void setValid(bool isValid) {
    setState(() {
      valid = isValid;
    });
  }

  void handleError(error) {
    _getToastError();
    widget.requestFailed();
  }

  void acceptRequest() {
    BookingService.acceptRequest(
            widget.transactionModel.bookingId!, _controller.value.text)!
        .then((value) {
      if (value != null && value.data != null) {
        _getToastSuccess();
        widget.requestAccepted();
      } else {
        _getToastError();
        widget.requestFailed();
      }
    }, onError: handleError);
  }

  void denyRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    BookingService.denyRequest(
            widget.transactionModel.bookingId!, _controller.value.text)
        .then((value) {
      if (value != null && value.data != null) {
        _getToastDeny();
        widget.requestDenied();
      } else {
        _getToastError();
        widget.requestFailed();
      }
    }, onError: handleError);
  }

  _getBookingInfoProducts(
      double displayWidth, double displayHeight, BookingModel bookingModel) {
    List<Widget> widgets = [];
    widget.transactionModel.products!.forEach((transactionProduct) {
      String productId = transactionProduct.id!;
      BookingProduct product = bookingModel.products!
          .firstWhere((element) => element.id == productId);
      widgets.add(Text(
        product.categoryTitle!,
        style: _getTextStyleBold(displayHeight * 0.015),
      ));
      widgets.add(SizedBox(height: Dimensions.getScaledSize(5)));

      // var transactionProduct = widget.transactionModel.products.firstWhere(
      //   (transactionProductElement) =>
      //       transactionProductElement.id == productId,
      //   orElse: () => null,
      // );
      // if (transactionProduct == null) return;

      widgets.add(Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "${transactionProduct.quantity}x ",
              style: _getTextStyle(displayHeight * 0.015),
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(
                transactionProduct.bookingTimeString != null
                    ? "${_getFormattedBookingTimeString(transactionProduct.bookingTimeString!)} ${AppLocalizations.of(context)!.commonWords_clock}"
                    : AppLocalizations.of(context)!.bookingListScreen_wholeDay,
                style: _getTextStyle(displayHeight * 0.015),
              )),
          Expanded(
            flex: 5,
            child: Text(
              transactionProduct.title!,
              style: _getTextStyle(displayHeight * 0.015),
            ),
          ),
        ],
      ));
      product.properties!.forEach((productPropertyElemenet) {
        widgets.add(
          Row(
            children: [
              Expanded(flex: 3, child: Container()),
              Expanded(
                flex: 5,
                child: Text(
                  '${productPropertyElemenet.title} : ${productPropertyElemenet.value}',
                  style: _getTextStyle(displayHeight * 0.015),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        );
      });
      widgets.add(SizedBox(height: Dimensions.getScaledSize(5)));
      product.additionalServices!.forEach((additionalService) {
        widgets.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "${additionalService.quantity}x ",
                style: _getTextStyle(displayHeight * 0.015),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                additionalService.title!,
                style: _getTextStyle(displayHeight * 0.015),
              ),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: additionalService.properties!
                      .map((property) => Text(
                            "${property.title} : ${property.value}",
                            style: _getTextStyle(displayHeight * 0.015),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ))
                      .toList(),
                ))
          ],
        ));
        widgets.add(SizedBox(height: Dimensions.getScaledSize(5)));
      });
      widgets.add(SizedBox(height: Dimensions.getScaledSize(5)));
    });

    return widgets;
  }

  String _getFormattedBookingTimeString(String bookingTimeString) {
    var splittedValues = bookingTimeString.split(':');

    try {
      return DateFormat('HH:mm', 'de-DE').format(
        DateTime(
          2021,
          1,
          1,
          int.tryParse(splittedValues[0])!,
          int.tryParse(
            splittedValues[1],
          )!,
        ),
      );
    } catch (e) {
      return '';
    }
  }
}
