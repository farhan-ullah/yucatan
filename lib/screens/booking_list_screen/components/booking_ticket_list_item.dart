import 'package:yucatan/components/qr_code.dart';
import 'package:yucatan/components/ticket_preview_header.dart';
import 'package:yucatan/components/ticket_preview_info.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart' as BookingModel;
import 'package:yucatan/screens/main_screen/components/main_screen_parameter.dart';
import 'package:yucatan/screens/main_screen/main_screen.dart';
import 'package:yucatan/services/database/database_service.dart';
import 'package:yucatan/services/notification_service/notification_service.dart';
import 'package:yucatan/services/payment_service.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:screen/screen.dart';

class BookingTicketListItem extends StatefulWidget {
  final ActivityModel activity;
  final BookingModel.BookingModel booking;
  final BookingModel.BookingTicket ticket;
  final bool offline;
  final double initialBrightness;

  const BookingTicketListItem(
      {required this.initialBrightness,
      required this.activity,
      required this.booking,
      required this.ticket,
      required this.offline});

  @override
  _BookingTicketListItemState createState() => _BookingTicketListItemState();
}

class _BookingTicketListItemState extends State<BookingTicketListItem> {
  bool _showCancellation = false;
  bool _showCancellationConfirmation = false;
  bool _cancelEntireBooking = false;
  bool checkIfTicketStatusIsRefunded = false;
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.getScaledSize(10.0),
        right: Dimensions.getScaledSize(10.0),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.getScaledSize(24.0)),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TicketPreviewHeader(
            ticketNumber: widget.ticket.ticket!,
            headerColor: _showCancellationConfirmation ||
                    _isRefundedTicket(widget.ticket)
                ? CustomTheme.darkGrey.withOpacity(0.5)
                : CustomTheme.primaryColorDark,
          ),
          _showCancellation
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.43 -
                          Dimensions.getScaledSize(70.0) -
                          Dimensions.getScaledSize(4.0),
                      color: Colors.white,
                      padding: EdgeInsets.only(
                        top: Dimensions.getScaledSize(20.0),
                        bottom: Dimensions.getScaledSize(20.0),
                        left: Dimensions.getScaledSize(56.0),
                        right: Dimensions.getScaledSize(56.0),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                _canBeCancelled()
                                    ? _showCancellationConfirmation
                                        ? 'lib/assets/images/warning.svg'
                                        : 'lib/assets/images/warning.svg'
                                    : 'lib/assets/images/sentiment.svg',
                                width: Dimensions.getScaledSize(30.0),
                                color: CustomTheme.accentColor1,
                              ),
                              SizedBox(
                                width: Dimensions.getScaledSize(5),
                              ),
                              Text(
                                _canBeCancelled()
                                    ? _showCancellationConfirmation
                                        ? AppLocalizations.of(context)!
                                            .commonWords_areYouSure
                                        : AppLocalizations.of(context)!
                                            .commonWords_warning_warnung
                                    : AppLocalizations.of(context)!
                                        .commonWords_mistake,
                                style: TextStyle(
                                  fontSize: Dimensions.getScaledSize(17.0),
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.accentColor1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(15.0),
                          ),
                          Text(
                            _canBeCancelled()
                                ? _showCancellationConfirmation
                                    ? _cancelEntireBooking
                                        ? AppLocalizations.of(context)!
                                            .bookingListScreen_refundBooking
                                        : AppLocalizations.of(context)!
                                            .bookingListScreen_refundTicket
                                    : AppLocalizations.of(context)!
                                        .bookingListScreen_refundBookingOrTicket
                                : AppLocalizations.of(context)!
                                    .bookingListScreen_refundPeriodExpired,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(15.0),
                              color: CustomTheme.primaryColorDark,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(10.0),
                          ),
                          _canBeCancelled()
                              ? Container()
                              : Text(
                                  AppLocalizations.of(context)!
                                      .bookingListScreen_refundPeriodDuration(
                                          widget.activity.activityDetails!
                                              .cancellation!),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(10.0),
                                    color: CustomTheme.darkGrey,
                                  ),
                                ),
                          Expanded(
                            child: Container(),
                          ),
                          _canBeCancelled() &&
                                  _showCancellationConfirmation == false
                              ? _getOpenTicketsForBooking(widget.booking) == 1
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        _showCancellationConfirmationUi(false);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: CustomTheme.accentColor1,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.getScaledSize(5.0)),
                                        ),
                                        padding: EdgeInsets.all(
                                          Dimensions.getScaledSize(5.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .bookingListScreen_singleTicket,
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.getScaledSize(
                                                      16.0),
                                              fontWeight: FontWeight.bold,
                                              color: CustomTheme.accentColor1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                              : Container(),
                          _canBeCancelled() &&
                                  _getOpenTicketsForBooking(widget.booking) == 1
                              ? Container()
                              : SizedBox(
                                  height: Dimensions.getScaledSize(10.0),
                                ),
                          _canBeCancelled() &&
                                  _showCancellationConfirmation == false
                              ? _getOpenTicketsForBooking(widget.booking) == 1
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        for (int i = 0;
                                            i < widget.booking.tickets!.length;
                                            i++) {
                                          if (widget
                                                  .booking.tickets![i].status ==
                                              "REFUNDED") {
                                            checkIfTicketStatusIsRefunded =
                                                true;
                                          }
                                        }
                                        _showCancellationConfirmationUi(true);
                                      },
                                      child: Visibility(
                                        visible: checkIfTicketStatusIsRefunded
                                            ? false
                                            : true,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: CustomTheme.accentColor1,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.all(
                                              Dimensions.getScaledSize(5.0)),
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .bookingListScreen_entireBooking,
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.getScaledSize(
                                                        16.0),
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.accentColor1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                              : Container(),
                          _canBeCancelled()
                              ? _showCancellationConfirmation ||
                                      _getOpenTicketsForBooking(
                                              widget.booking) ==
                                          1
                                  ? _showProgress
                                      ? CircularProgressIndicator()
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showProgress = true;
                                            });
                                            if (_cancelEntireBooking)
                                              _refundEntireBooking();
                                            else
                                              _refundSingleTicket(
                                                  widget.ticket);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: CustomTheme.accentColor1,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.getScaledSize(
                                                          5.0)),
                                            ),
                                            padding: EdgeInsets.all(
                                                Dimensions.getScaledSize(5.0)),
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .commonWords_refund,
                                                style: TextStyle(
                                                  fontSize:
                                                      Dimensions.getScaledSize(
                                                          16.0),
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      CustomTheme.accentColor1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                  : Container()
                              : Container(),
                          SizedBox(
                            height: Dimensions.getScaledSize(10.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_showCancellationConfirmation) if (_getOpenTicketsForBooking(
                                      widget.booking) ==
                                  1) {
                                _hideCancellationUi();
                                _hideCancellationConfirmationUi();
                              } else {
                                _hideCancellationConfirmationUi();
                              }
                              else
                                _hideCancellationUi();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: CustomTheme.accentColor2,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.getScaledSize(5.0)),
                              ),
                              padding: EdgeInsets.all(
                                Dimensions.getScaledSize(5.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_outlined,
                                    size: Dimensions.getScaledSize(18.0),
                                    color: CustomTheme.accentColor2,
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.actions_back,
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(16.0),
                                      fontWeight: FontWeight.bold,
                                      color: CustomTheme.accentColor2,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.getScaledSize(22.0),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.43 -
                      Dimensions.getScaledSize(70.0) -
                      Dimensions.getScaledSize(4.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.43 -
                            Dimensions.getScaledSize(140.0) -
                            Dimensions.getScaledSize(4.0),
                        padding: EdgeInsets.only(
                          top: Dimensions.getScaledSize(10.0),
                          left: Dimensions.getScaledSize(10.0),
                          right: Dimensions.getScaledSize(10.0),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        color: Colors.white,
                                        height: Dimensions.getScaledSize(120.0),
                                        child: Stack(
                                          children: [
                                            widget.offline
                                                ? Container(
                                                    // decoration: BoxDecoration(
                                                    //   image: DecorationImage(
                                                    //     image: AssetImage(
                                                    //         'lib/assets/images/bookings-placeholder.jpg'),
                                                    //     fit: BoxFit.cover,
                                                    //     alignment:
                                                    //         Alignment.center,
                                                    //   ),
                                                    // ),
                                                    )
                                                : Positioned.fill(
                                                    child:
                                                        loadCachedNetworkImage(
                                                      widget.activity.thumbnail !=
                                                                  null &&
                                                              isNotNullOrEmpty(
                                                                  widget
                                                                      .activity
                                                                      .thumbnail!
                                                                      .publicUrl!)
                                                          ? widget
                                                              .activity
                                                              .thumbnail!
                                                              .publicUrl!
                                                          : "",
                                                      height: Dimensions
                                                          .getScaledSize(120.0),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                            _isRefundedTicket(widget.ticket)
                                                ? Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: _isRefundedTicket(
                                                                widget.ticket)
                                                            ? CustomTheme
                                                                .lightGrey
                                                                .withOpacity(
                                                                    0.8)
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimensions.getScaledSize(10.0),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        color: Colors.white,
                                        height: Dimensions.getScaledSize(120.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.activity.title!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: Dimensions
                                                    .getScaledSize(Dimensions
                                                        .getScaledSize(14.0)),
                                                fontWeight: FontWeight.bold,
                                                color: _isRefundedTicket(
                                                        widget.ticket)
                                                    ? CustomTheme.darkGrey
                                                        .withOpacity(0.5)
                                                    : CustomTheme
                                                        .primaryColorDark,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.getScaledSize(5.0),
                                            ),
                                            // Location Icon and Address Row

                                            TicketPreviewAddress(
                                              housenumber: widget.activity
                                                  .location!.housenumber!,
                                              street: widget
                                                  .activity.location!.street!,
                                              ticketRefunded: _isRefundedTicket(
                                                  widget.ticket),
                                            ),

                                            SizedBox(
                                              height:
                                                  Dimensions.getScaledSize(2.0),
                                            ),
                                            // ZipCode and City Information

                                            TicketPreviewCityInfo(
                                              city: widget
                                                  .activity.location!.city!,
                                              zipcode: widget
                                                  .activity.location!.zipcode
                                                  .toString(),
                                              ticketRefunded: _isRefundedTicket(
                                                  widget.ticket),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.getScaledSize(5.0),
                                            ),
                                            // Calendar and Date Information
                                            TicketPreviewDateInfo(
                                                dateTime:
                                                    widget.booking.bookingDate!,
                                                ticketRefunded:
                                                    _isRefundedTicket(
                                                        widget.ticket)),
                                            TicketPreviewBookingTime(
                                              ticketRefunded: _isRefundedTicket(
                                                  widget.ticket),
                                              bookingTimeString: widget
                                                  .ticket.bookingTimeString,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimensions.getScaledSize(10.0)),
                              Text(
                                '${_getProductById(widget.ticket.productId!).categoryTitle}, ${_getProductById(widget.ticket.productId!).subCategoryTitle}',
                                style: TextStyle(
                                  fontSize: Dimensions.getScaledSize(12.0),
                                  fontWeight: FontWeight.bold,
                                  color: _isRefundedTicket(widget.ticket)
                                      ? CustomTheme.darkGrey.withOpacity(0.5)
                                      : CustomTheme.primaryColorDark,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.getScaledSize(5.0),
                              ),
                              _getProductTextForTicket(widget.ticket),
                              ..._getProductPropertiesForTicket(widget.ticket),
                              ..._getAdditionalServicesForTicket(widget.ticket),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(Dimensions.getScaledSize(10.0)),
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    for (int i = 0;
                                        i < widget.booking.tickets!.length;
                                        i++) {
                                      if (widget.booking.tickets![i].status ==
                                          "REFUNDED") {
                                        checkIfTicketStatusIsRefunded = true;
                                      }
                                    }
                                    if (widget.ticket.status == 'USABLE' &&
                                        !widget.offline) _showCancellationUi();
                                    if (_getOpenTicketsForBooking(
                                            widget.booking) ==
                                        1) {
                                      _showCancellationConfirmationUi(false);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: Dimensions.getScaledSize(5.0),
                                      right: Dimensions.getScaledSize(10.0),
                                    ),
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            size:
                                                Dimensions.getScaledSize(22.0),
                                            color: _canBeCancelled() &&
                                                    _isRefundedTicket(
                                                            widget.ticket) ==
                                                        false &&
                                                    widget.ticket.status !=
                                                        'USED'
                                                ? CustomTheme.accentColor1
                                                : _isRefundedTicket(
                                                        widget.ticket)
                                                    ? CustomTheme.darkGrey
                                                        .withOpacity(0.5)
                                                    : CustomTheme.darkGrey,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .commonWords_refund,
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.getScaledSize(14),
                                              color: _canBeCancelled() &&
                                                      _isRefundedTicket(
                                                              widget.ticket) ==
                                                          false &&
                                                      widget.ticket.status !=
                                                          'USED'
                                                  ? CustomTheme.accentColor1
                                                  : _isRefundedTicket(
                                                          widget.ticket)
                                                      ? CustomTheme.darkGrey
                                                          .withOpacity(0.5)
                                                      : CustomTheme.darkGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(3.0),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .bookingListScreen_inValueOf,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(11.0),
                                    color: _isRefundedTicket(widget.ticket)
                                        ? CustomTheme.darkGrey.withOpacity(0.5)
                                        : CustomTheme.primaryColorDark,
                                  ),
                                ),
                                Row(
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Text(
                                      '${formatPriceDouble(widget.ticket.price!)}',
                                      style: TextStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(20.0),
                                        fontWeight: FontWeight.bold,
                                        color: _isRefundedTicket(widget.ticket)
                                            ? CustomTheme.darkGrey
                                                .withOpacity(0.5)
                                            : CustomTheme.primaryColorDark,
                                      ),
                                    ),
                                    Text(
                                      '€',
                                      style: TextStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(18.0),
                                        fontWeight: FontWeight.bold,
                                        color: _isRefundedTicket(widget.ticket)
                                            ? CustomTheme.darkGrey
                                                .withOpacity(0.5)
                                            : CustomTheme.primaryColorDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: Dimensions.getScaledSize(4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [
                      ...(List.generate(
                        37,
                        (index) => index % 2 == 0
                            ? Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              )
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          widget.ticket.status == 'USABLE'
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(Dimensions.getScaledSize(24.0)),
                      bottomRight:
                          Radius.circular(Dimensions.getScaledSize(24.0)),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.getScaledSize(10.0),
                      ),
                      Center(
                        child: QrCodeViewer(
                          size: MediaQuery.of(context).size.height * 0.17,
                          content: widget.ticket.qr,
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(10.0),
                      ),
                    ],
                  ),
                )
              : Container(),
          /*widget.ticket.status == 'REFUNDED'
              ? Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(Dimensions.getScaledSize(24.0)),
                        bottomRight:
                            Radius.circular(Dimensions.getScaledSize(24.0)),
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: Dimensions.getScaledSize(10.0),
                          left: Dimensions.getScaledSize(24.0),
                          right: Dimensions.getScaledSize(24.0),
                          bottom: Dimensions.getScaledSize(10.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context)
                              .bookingListScreen_refundTicket,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(14.0),
                            color: CustomTheme.accentColor1,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),*/
        ],
      ),
    );
  }

  BookingModel.BookingProduct _getProductById(String productId) {
    return widget.booking.products!.firstWhere(
      (element) => element.id == productId,
      // orElse: () => null,
    );
  }

  BookingModel.ProductAdditionalService _getAdditionalServiceByTicketAndId(
      BookingModel.BookingTicket ticket, String additionalServiceId) {
    var bookingProduct = _getProductById(ticket.productId!);

    return bookingProduct.additionalServices!.firstWhere(
      (element) => element.id == additionalServiceId,
      // orElse: () => null,
    );
  }

  Widget _getProductTextForTicket(BookingModel.BookingTicket ticket) {
    var bookingProduct = _getProductById(ticket.productId!);

    return Text(
      '1x ${bookingProduct.title}',
      style: TextStyle(
        fontSize: Dimensions.getScaledSize(12.0),
        color: _isRefundedTicket(ticket)
            ? CustomTheme.darkGrey.withOpacity(0.5)
            : CustomTheme.primaryColorDark,
      ),
    );
  }

  List<Widget> _getProductPropertiesForTicket(
      BookingModel.BookingTicket ticket) {
    List<Widget> widgets = [];

    var bookingProduct = _getProductById(ticket.productId!);

    if (bookingProduct.quantity! > 1) return [];

    bookingProduct.properties!.forEach((productPropertyElemenet) {
      widgets.add(
        Text(
          '${productPropertyElemenet.title}: ${productPropertyElemenet.value}',
          style: TextStyle(
              fontSize: Dimensions.getScaledSize(12.0),
              color: _isRefundedTicket(ticket)
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColorDark),
        ),
      );
    });

    return widgets;
  }

  int _getOpenTicketsForBooking(BookingModel.BookingModel booking) {
    int openTickets = 0;

    booking.tickets!.forEach((element) {
      if (element.status == "USABLE") {
        openTickets += 1;
      }
    });

    return openTickets;
  }

  List<Widget> _getAdditionalServicesForTicket(
      BookingModel.BookingTicket ticket) {
    List<Widget> widgets = [];

    ticket.additionalServiceInfo!.forEach((additionalServiceInfoElement) {
      widgets.add(
        SizedBox(
          height: Dimensions.getScaledSize(10.0),
        ),
      );

      var additionalService = _getAdditionalServiceByTicketAndId(
        ticket,
        additionalServiceInfoElement.additionalServiceId!,
      );

      widgets.add(
        Text(
          '${additionalServiceInfoElement.quantity}x ${additionalService.title}',
          style: TextStyle(
              fontSize: Dimensions.getScaledSize(12.0),
              color: _isRefundedTicket(ticket)
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColorDark),
        ),
      );

      widgets.addAll(
        _getAdditionalServicePropertiesForAdditionalService(
            ticket, additionalService),
      );
    });

    return widgets;
  }

  List<Widget> _getAdditionalServicePropertiesForAdditionalService(
      BookingModel.BookingTicket ticket,
      BookingModel.ProductAdditionalService additionalService) {
    List<Widget> widgets = [];

    if (additionalService.quantity! > 1) return [];

    additionalService.properties!.forEach((additionalServicePropertyElemenet) {
      widgets.add(
        Text(
          '${additionalServicePropertyElemenet.title}: ${additionalServicePropertyElemenet.value}',
          style: TextStyle(
              fontSize: Dimensions.getScaledSize(12.0),
              color: _isRefundedTicket(ticket)
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColorDark),
        ),
      );
    });

    return widgets;
  }

  bool _canBeCancelled() {
    DateTime canBeCancelledUntil = DateTime(
      widget.booking.bookingDate!.year,
      widget.booking.bookingDate!.month,
      widget.booking.bookingDate!.day,
      widget.booking.bookingDate!.hour,
      widget.booking.bookingDate!.minute,
      widget.booking.bookingDate!.second,
    ).subtract(
      Duration(
        hours: widget.activity.activityDetails!.cancellation!,
      ),
    );

    return DateTime.now().isBefore(canBeCancelledUntil);
  }

  bool _isRefundedTicket(BookingModel.BookingTicket ticket) {
    return ticket.status == 'REFUNDED';
  }

  void _showCancellationUi() {
    setState(() {
      _showCancellation = true;
    });
  }

  void _hideCancellationUi() {
    setState(() {
      _showCancellation = false;
    });
  }

  void _showCancellationConfirmationUi(bool cancelEntireBooking) {
    setState(() {
      _showCancellationConfirmation = true;
      _cancelEntireBooking = cancelEntireBooking;
    });
  }

  void _hideCancellationConfirmationUi() {
    setState(() {
      _showCancellationConfirmation = false;
      _cancelEntireBooking = false;
    });
  }

  void _refundSingleTicket(BookingModel.BookingTicket ticket) async {
    var result =
        await PaymentService.refundSingleTicket(widget.booking.id!, ticket.id!);
    setState(() {
      _showProgress = false;
    });

    if (result!.error != null) {
      Fluttertoast.showToast(
          msg: result.error!.message!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xff656565).withOpacity(0.9),
          textColor: Colors.white,
          fontSize: Dimensions.getScaledSize(16.0));
      return;
    }

    if (result.status == 200) {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.bookingListScreen_refundSuccess,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xff656565).withOpacity(0.9),
          textColor: Colors.white,
          fontSize: Dimensions.getScaledSize(16.0));

      _hideCancellationConfirmationUi();
      _hideCancellationUi();

      setState(() {
        ticket.status = 'REFUNDED';
      });
      HiveService.updateDatabase();
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.bookingListScreen_refundError,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xff656565).withOpacity(0.9),
          textColor: Colors.white,
          fontSize: Dimensions.getScaledSize(16.0));
    }
  }

  void _refundEntireBooking() async {
    var result = await PaymentService.refundBooking(widget.booking.id!);
    setState(() {
      _showProgress = false;
    });

    if (result!.status == 200) {
      // Screen.setBrightness(widget.initialBrightness);
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.bookingListScreen_refundSuccess,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xff656565).withOpacity(0.9),
          textColor: Colors.white,
          fontSize: Dimensions.getScaledSize(16.0));

      Navigator.of(context).popUntil(ModalRoute.withName(MainScreen.route));
      Navigator.of(context).pushReplacementNamed(
        MainScreen.route,
        arguments: MainScreenParameter(
          bottomNavigationBarIndex: 1,
        ),
      );
      print('Notification:: Cancelled Scheduled Notification');
      HiveService.getScheduledNotification(widget.booking.id!).then((value) {
        if (value == null) {
          return;
        }

        // NotificationService.initialize(null).then((service) {
        //   service.cancelScheduleNotification(value.notificationId);
        // });
      });
      HiveService.deleteScheduledNotification(widget.booking.id!);
      HiveService.updateDatabase();
    } else {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.bookingListScreen_refundError,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xff656565).withOpacity(0.9),
          textColor: Colors.white,
          fontSize: Dimensions.getScaledSize(16.0));
    }
  }
}
