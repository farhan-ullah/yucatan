import 'dart:ui';

import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/user_model.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_preview_button.dart';
import 'package:yucatan/services/payment_service.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'booking_categories.dart';

class BookingDetailsPreview extends StatefulWidget {
  final BookingDetailedModel booking;
  final Category category;
  final Function openTicketList;
  final Function refresh;

  BookingDetailsPreview(
      {required this.booking,
      required this.category,
      required this.openTicketList,
      required this.refresh});

  @override
  State<StatefulWidget> createState() {
    return _BookingDetailsPreviewState();
  }
}

class _BookingDetailsPreviewState extends State<BookingDetailsPreview> {
  bool _showRefundPage = false;

  @override
  void initState() {
    super.initState();
  }

  void _showRefund() {
    setState(() {
      _showRefundPage = true;
    });
  }

  void _hideRefund() {
    setState(() {
      _showRefundPage = false;
    });
  }

  bool canBeRefunded() {
    var vendorRefundBufferMinutes =
        120; //TODO: Export this to a config file or get from backend

    var latestCancellation = widget.booking.bookingDate!
        .subtract(Duration(minutes: vendorRefundBufferMinutes));

    bool isBeforeLatestCancellation =
        DateTime.now().isBefore(latestCancellation);

    return widget.booking.tickets!.any((ticket) => ticket.status == "USABLE") &&
        isBeforeLatestCancellation;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8 * MediaQuery.of(context).size.height,
      width: 0.85 * MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.getScaledSize(10.0),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.getScaledSize(24.0)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _DetailedBookingHeader(category: widget.category),
          Container(
              padding: EdgeInsets.all(Dimensions.getScaledSize(10.0)),
              child: _showRefundPage
                  ? _BookingRefundBody(
                      bookingId: widget.booking.id!,
                      hideRefund: _hideRefund,
                      refresh: widget.refresh,
                    )
                  : BookingDetailsBody(
                      booking: widget.booking,
                      canBeRefunded: canBeRefunded(),
                      showRefund: _showRefund,
                      userModel: widget.booking.user!,
                      openTicketList: widget.openTicketList,
                      category: widget.category,
                    )),
        ],
      ),
    );
  }
}

class _DetailedBookingHeader extends StatelessWidget {
  final Category? category;

  _DetailedBookingHeader({this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.getScaledSize(15.0),
      ),
      height: Dimensions.getScaledSize(50.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.getScaledSize(24.0)),
          topRight: Radius.circular(Dimensions.getScaledSize(24.0)),
        ),
        color: getCurrentColor(category!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'lib/assets/images/appventure_logo_pos.svg',
            height: Dimensions.getScaledSize(30.0),
            color: Colors.white,
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

class BookingDetailsBody extends StatelessWidget {
  final UserModel userModel;
  final BookingDetailedModel booking;
  final bool canBeRefunded;
  final Function showRefund;
  final Function? openTicketList;
  final Category category;

  final double sidePadding = Dimensions.getWidth(percentage: 2);

  final Color fieldColor = Color(0xFFECF5FE);

  BookingDetailsBody({
    required this.booking,
    required this.canBeRefunded,
    required this.showRefund,
    required this.userModel,
    this.openTicketList,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getInfoTitleText(
            AppLocalizations.of(context)!.vendor_bookingOverview_customerData),
        SizedBox(height: Dimensions.getScaledSize(10), child: Container()),
        _getUserInfoRow(
            icon: Icons.account_circle_outlined,
            textWidget: Text(booking.invoiceAddress!.name!,
                style: _getUserInfoStyle(FontWeight.bold)),
            backgroundColor: Colors.white,
            padding: Dimensions.getScaledSize(5)),
        SizedBox(height: Dimensions.getScaledSize(5)),
        _getUserInfoRow(
            icon: Icons.location_on_outlined,
            textWidget: Text(
                '${booking.invoiceAddress!.street} ${booking.invoiceAddress!.houseNumber}, ${booking.invoiceAddress!.zip.toString()} ${booking.invoiceAddress!.city}',
                style: _getUserInfoStyle(FontWeight.normal)),
            backgroundColor: Colors.white,
            padding: Dimensions.getScaledSize(5)),
        SizedBox(height: Dimensions.getScaledSize(5)),
        GestureDetector(
          onTap: () {
            launch('mailto:${booking.user!.email}');
          },
          child: _getUserInfoRow(
              icon: Icons.mail_outline_sharp,
              textWidget: Text(booking.user!.email!,
                  style: _getUserInfoStyle(FontWeight.normal)),
              backgroundColor: fieldColor,
              padding: Dimensions.getScaledSize(5)),
        ),
        SizedBox(height: Dimensions.getScaledSize(5)),
        GestureDetector(
          onTap: () {
            launch('tel:${booking.invoiceAddress!.phone}');
          },
          child: _getUserInfoRow(
              icon: Icons.phone,
              textWidget: Text(booking.invoiceAddress!.phone!,
                  style: _getUserInfoStyle(FontWeight.normal)),
              backgroundColor: fieldColor,
              padding: Dimensions.getScaledSize(5)),
        ),
        SizedBox(height: Dimensions.getScaledSize(10), child: Container()),
        _getInfoTitleText(AppLocalizations.of(context)!.commonWords_booking),
        SizedBox(height: Dimensions.getScaledSize(10), child: Container()),
        _getBookingInfo(context),
        SizedBox(height: Dimensions.getScaledSize(10)),
        GestureDetector(
            onTap: () {
              openTicketList!();
            },
            child: _getUserInfoRow(
                icon: Icons.visibility_outlined,
                textWidget: Text(
                    AppLocalizations.of(context)!
                        .vendor_bookingOverview_seeDetails,
                    style: _getUserInfoStyle(FontWeight.normal)),
                backgroundColor: fieldColor,
                padding: Dimensions.getScaledSize(10))),
        SizedBox(height: Dimensions.getScaledSize(10)),
        _getInfoTitleText(
            AppLocalizations.of(context)!.vendor_bookingOverview_articles),
        SizedBox(height: Dimensions.getScaledSize(10)),
        Container(
          height: 0.25 * MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.activity!.title!,
                  style: _getUserInfoStyle(FontWeight.bold),
                ),
                SizedBox(height: Dimensions.getScaledSize(6)),
                ..._getProductsList()
              ],
            ),
          ),
        ),
        if (canBeRefunded)
          GestureDetector(
            onTap: () => showRefund(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: Dimensions.getScaledSize(22.0),
                  color: CustomTheme.accentColor1,
                ),
                Text(
                  AppLocalizations.of(context)!.commonWords_refund,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(14),
                    color: CustomTheme.accentColor1,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  _getInfoTitleText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: Text(text, style: _getInfoTitleStyle()),
    );
  }

  _getUserInfoRow({icon, textWidget, backgroundColor, padding}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sidePadding,
        vertical: padding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(children: [
        Icon(icon,
            size: Dimensions.getScaledSize(18.0),
            color: CustomTheme.primaryColorLight),
        _getTextRowPadding(),
        textWidget,
      ]),
    );
  }

  _getCategoryForTicket(status) {
    switch (status) {
      case "REFUNDED":
        return Category.REFUNDED;
      case "USED":
        return Category.USED;
      case "USABLE":
        return Category.USABLE;
      default:
        return Category.REQUESTED;
    }
  }

  _getProductsList() {
    List<Widget> products = [];
    booking.tickets!.forEach((ticket) {
      if (_getCategoryForTicket(ticket.status) == category) {
        BookingProduct product = booking.products!.firstWhere(
            (product) => product.id == ticket.productId,
            // orElse: () => null
        );
        if (product != null) {
          products.add(Text("1x ${product.title}",
              style: _getUserInfoStyle(
                FontWeight.normal,
              )));
          products.add(SizedBox(
            height: Dimensions.getScaledSize(6),
          ));
        }
      }
    });
    return products;
  }

  _getBookingInfo(context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sidePadding,
        vertical: Dimensions.getScaledSize(12),
      ),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          //Date and Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: Dimensions.getScaledSize(18.0),
                    width: Dimensions.getScaledSize(18.0),
                    child: SvgPicture.asset(
                      'lib/assets/images/calendar.svg',
                      color: CustomTheme.primaryColor,
                    ),
                  ),
                  _getTextRowPadding(),
                  Text(
                      '${DateFormat('EE dd.MM.yyyy', 'de-DE').format(booking.bookingDate!).replaceFirst('.', ',')}',
                      style: _getUserInfoStyle(FontWeight.normal)),
                ],
              ),
              SizedBox(height: Dimensions.getScaledSize(5)),
              Row(
                children: [
                  Icon(Icons.euro_outlined,
                      size: Dimensions.getScaledSize(18.0),
                      color: CustomTheme.primaryColorLight),
                  _getTextRowPadding(),
                  Text('${formatPriceDouble(booking.totalPrice!)}',
                      style: _getUserInfoStyle(FontWeight.bold)),
                ],
              )
            ],
          ),
          SizedBox(
            width: Dimensions.getScaledSize(30),
          ),
          //Time and payment
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Icon(
              //       Icons.access_time_outlined,
              //       size: Dimensions.getScaledSize(18.0),
              //       color: CustomTheme.primaryColorLight,
              //     ),
              //     _getTextRowPadding(),
              //     Text(
              //         '${booking.bookingDate.hour}:${booking.bookingDate.minute} ' +
              //             AppLocalizations.of(context)
              //                 .vendor_bookingOverview_hour,
              //         style: _getUserInfoStyle(FontWeight.normal)),
              //   ],
              // ),
              SizedBox(height: Dimensions.getScaledSize(23.0)),
              Row(
                children: [
                  Icon(Icons.payment,
                      size: Dimensions.getScaledSize(18.0),
                      color: CustomTheme.primaryColorLight),
                  _getTextRowPadding(),
                  Text(
                      isPaymentProviderStripe(booking)
                          ? AppLocalizations.of(context)!
                              .vendor_bookingOverview_creditCard
                          : isPaymentProviderPayPal(booking)
                              ? "PayPal"
                              : "none",
                      style: _getUserInfoStyle(FontWeight.bold)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  bool isPaymentProviderStripe(BookingDetailedModel booking) {
    return booking.paymentProvider != null &&
        booking.paymentProvider == "STRIPE";
  }

  bool isPaymentProviderPayPal(BookingDetailedModel booking) {
    return booking.paymentProvider != null &&
        booking.paymentProvider == "PayPal";
  }

  _getTextRowPadding() {
    return SizedBox(
        width: Dimensions.getWidth(percentage: 3), child: Container());
  }

  _getUserInfoStyle(fontWeight) {
    return TextStyle(
        color: CustomTheme.primaryColorLight,
        fontSize: Dimensions.getScaledSize(12.0),
        fontFamily: CustomTheme.fontFamily,
        fontWeight: fontWeight);
  }

  _getInfoTitleStyle() {
    return TextStyle(
        color: CustomTheme.primaryColorLight,
        fontSize: Dimensions.getScaledSize(12.0),
        fontFamily: CustomTheme.fontFamily,
        fontWeight: FontWeight.normal);
  }
}

class _BookingRefundBody extends StatefulWidget {
  final Function hideRefund;
  final String bookingId;
  final Function? refresh;

  _BookingRefundBody({
    required this.bookingId,
    this.refresh,
    required this.hideRefund,
  });

  @override
  State<StatefulWidget> createState() {
    return _BookingRefundBodyState();
  }
}

class _BookingRefundBodyState extends State<_BookingRefundBody> {
  bool refundProcessing = false;

  void _handleError() {
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.commonWords_error,
      backgroundColor: CustomTheme.accentColor1,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
    );
    setState(() {
      refundProcessing = false;
    });
    widget.hideRefund();
  }

  void refundBooking() {
    setState(() {
      refundProcessing = true;
    });
    PaymentService.refundBookingAsVendor(widget.bookingId).then((value) {
      if (value != null && value.status == 200) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!
              .vendor_bookingOverview_bookingRefunded,
          backgroundColor: CustomTheme.accentColor2,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
        );
        print(value.data);
        widget.refresh!();
        Navigator.of(context).pop();
      } else
        _handleError();
    }, onError: (error) {
      print(error);
      _handleError();
    }).catchError((error) {
      print(error);
      _handleError();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: !refundProcessing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Text(
                  AppLocalizations.of(context)!.commonWords_warning_warnung,
                  style: TextStyle(
                    color: CustomTheme.accentColor1,
                    fontWeight: FontWeight.w900,
                    fontFamily: CustomTheme.fontFamily,
                    fontSize: Dimensions.getScaledSize(18),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.getScaledSize(15)),
                Image.asset(
                  'lib/assets/images/warning.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.55,
                ),
                SizedBox(height: Dimensions.getScaledSize(15)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Text(
                    AppLocalizations.of(context)!
                        .vendor_bookingOverview_refundBooking,
                    style: TextStyle(
                      color: CustomTheme.primaryColorLight,
                      fontFamily: CustomTheme.fontFamily,
                      fontWeight: FontWeight.normal,
                      fontSize: Dimensions.getScaledSize(15),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: Container()),
                VendorBookingPreviewButton(
                    color: CustomTheme.accentColor1,
                    buttonText:
                        AppLocalizations.of(context)!.commonWords_refund,
                    onPressed: refundBooking,
                    fontSize: Dimensions.getScaledSize(15),
                    width: MediaQuery.of(context).size.width * 0.55,
                    fontWeight: FontWeight.w900),
                VendorBookingPreviewButton(
                  color: CustomTheme.accentColor2,
                  buttonText: AppLocalizations.of(context)!.actions_back,
                  onPressed: widget.hideRefund,
                  fontSize: Dimensions.getScaledSize(15),
                  width: MediaQuery.of(context).size.width * 0.55,
                  fontWeight: FontWeight.w900,
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
