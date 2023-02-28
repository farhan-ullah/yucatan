import 'package:yucatan/components/ticket_preview_header.dart';
import 'package:yucatan/components/ticket_preview_info.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/models/booking_model.dart' as BookingModel;
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'booking_categories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VendorBookingTicketListItem extends StatelessWidget {
  final BookingTicket ticket;
  final ActivityModel activity;
  final BookingModel.BookingModel booking;
  final Category category;
  VendorBookingTicketListItem(
      {this.activity, this.booking, this.ticket, this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.6 * MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.getScaledSize(10.0),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.getScaledSize(24.0)),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TicketPreviewHeader(
          ticketNumber: ticket.ticket,
          headerColor: getCurrentColor(category),
        ),
        Container(
          padding: EdgeInsets.all(Dimensions.getScaledSize(10.0)),
          height: 0.3 * MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TicketPreviewInfo(
                  activity: activity,
                  ticketRefunded: _isRefundedTicket(),
                  booking: booking,
                  imageAvailable: activity?.thumbnail?.publicUrl != null,
                  ticket: ticket,
                ),
                SizedBox(height: Dimensions.getScaledSize(10.0)),
                _getCategoryAndSubcategory(),
                SizedBox(height: Dimensions.getScaledSize(5.0)),
                _getProductTextForTicket(ticket),
                ..._getProductPropertiesForTicket(ticket),
                ..._getAdditionalServicesForTicket(ticket),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Dimensions.getScaledSize(10.0)),
          child: _getPrice(context),
        ),
        SizedBox(child: Container(), height: Dimensions.getScaledSize(20.0))
      ]),
    );
  }

  _isRefundedTicket() {
    return category == Category.REFUNDED;
  }

  _getPrice(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)!.bookingListScreen_inValueOf,
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(11.0),
                color: _isRefundedTicket()
                    ? CustomTheme.darkGrey.withOpacity(0.5)
                    : CustomTheme.primaryColorDark,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  '${formatPriceDouble(ticket.price)}',
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(20.0),
                    fontWeight: FontWeight.bold,
                    color: _isRefundedTicket()
                        ? CustomTheme.darkGrey.withOpacity(0.5)
                        : CustomTheme.primaryColorDark,
                  ),
                ),
                Text(
                  '€',
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(18.0),
                    fontWeight: FontWeight.bold,
                    color: _isRefundedTicket()
                        ? CustomTheme.darkGrey.withOpacity(0.5)
                        : CustomTheme.primaryColorDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _getCategoryAndSubcategory() {
    BookingModel.BookingProduct product = _getProductById(ticket.productId);
    return Text(
      '${product.categoryTitle}, ${product.subCategoryTitle}',
      style: TextStyle(
        fontSize: Dimensions.getScaledSize(12.0),
        fontWeight: FontWeight.bold,
        color: _isRefundedTicket()
            ? CustomTheme.darkGrey.withOpacity(0.5)
            : CustomTheme.primaryColorDark,
      ),
    );
  }

  BookingModel.BookingProduct _getProductById(String productId) {
    return booking.products.firstWhere(
      (element) => element.id == productId,
      orElse: () => null,
    );
  }

  BookingModel.ProductAdditionalService _getAdditionalServiceByTicketAndId(
      BookingModel.BookingTicket ticket, String additionalServiceId) {
    var bookingProduct = _getProductById(ticket.productId);

    return bookingProduct.additionalServices.firstWhere(
      (element) => element.id == additionalServiceId,
      orElse: () => null,
    );
  }

  Widget _getProductTextForTicket(BookingModel.BookingTicket ticket) {
    var bookingProduct = _getProductById(ticket.productId);

    return Text(
      '1x ${bookingProduct.title}',
      style: TextStyle(
        fontSize: Dimensions.getScaledSize(12.0),
        color: _isRefundedTicket()
            ? CustomTheme.darkGrey.withOpacity(0.5)
            : CustomTheme.primaryColorDark,
      ),
    );
  }

  List<Widget> _getProductPropertiesForTicket(
      BookingModel.BookingTicket ticket) {
    List<Widget> widgets = [];

    var bookingProduct = _getProductById(ticket.productId);

    if (bookingProduct.quantity > 1) return [];

    bookingProduct.properties.forEach((productPropertyElemenet) {
      widgets.add(
        Text(
          '${productPropertyElemenet.value}',
          style: TextStyle(
              fontSize: Dimensions.getScaledSize(12.0),
              color: _isRefundedTicket()
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColorDark),
        ),
      );
    });

    return widgets;
  }

  List<Widget> _getAdditionalServicesForTicket(
      BookingModel.BookingTicket ticket) {
    List<Widget> widgets = [];

    ticket.additionalServiceInfo.forEach((additionalServiceInfoElement) {
      widgets.add(
        SizedBox(
          height: Dimensions.getScaledSize(10.0),
        ),
      );

      var additionalService = _getAdditionalServiceByTicketAndId(
        ticket,
        additionalServiceInfoElement.additionalServiceId,
      );

      widgets.add(
        Text(
          '${additionalServiceInfoElement.quantity}x ${additionalService.title}',
          style: TextStyle(
              fontSize: Dimensions.getScaledSize(12.0),
              color: _isRefundedTicket()
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

    if (additionalService.quantity > 1) return [];

    additionalService.properties.forEach((additionalServicePropertyElemenet) {
      widgets.add(
        Text(
          '${additionalServicePropertyElemenet.value}',
          style: TextStyle(
              fontSize: Dimensions.getScaledSize(12.0),
              color: _isRefundedTicket()
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColorDark),
        ),
      );
    });

    return widgets;
  }
}
