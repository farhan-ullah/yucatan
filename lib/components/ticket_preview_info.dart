import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TicketPreviewImage extends StatelessWidget {
  final String imageUrl;
  final bool ticketRefunded;
  final bool imageAvailable;

  TicketPreviewImage({
    required this.imageUrl,
    required this.ticketRefunded,
    required this.imageAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !imageAvailable
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'lib/assets/images/bookings-placeholder.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              )
            : loadCachedNetworkImage(
                imageUrl,
                height: Dimensions.getScaledSize(120.0),
                fit: BoxFit.cover,
              ),
        ticketRefunded
            ? Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: ticketRefunded
                        ? CustomTheme.lightGrey.withOpacity(0.8)
                        : Colors.transparent,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class TicketPreviewAddress extends StatelessWidget {
  final bool ticketRefunded;
  final String street;
  final String housenumber;

  TicketPreviewAddress(
      {required this.ticketRefunded,
      required this.street,
      required this.housenumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: Dimensions.getScaledSize(18.0),
          color: ticketRefunded
              ? CustomTheme.darkGrey.withOpacity(0.5)
              : CustomTheme.primaryColorDark,
        ),
        SizedBox(
          width: Dimensions.getScaledSize(5.0),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: Dimensions.getScaledSize(3.0),
          ),
          child: Text(
            '$street $housenumber',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(11.0),
              color: ticketRefunded
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class TicketPreviewCityInfo extends StatelessWidget {
  final bool ticketRefunded;
  final String zipcode;
  final String city;

  TicketPreviewCityInfo({
    required this.ticketRefunded,
    required this.zipcode,
    required this.city,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: Dimensions.getScaledSize(23.0)),
        Expanded(
          child: Text(
            '$zipcode $city',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize:
                  Dimensions.getScaledSize(Dimensions.getScaledSize(11.0)),
              color: ticketRefunded
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class TicketPreviewDateInfo extends StatelessWidget {
  final bool ticketRefunded;
  final DateTime dateTime;

  TicketPreviewDateInfo({required this.ticketRefunded, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: Dimensions.getScaledSize(18.0),
          width: Dimensions.getScaledSize(18.0),
          child: SvgPicture.asset(
            'lib/assets/images/calendar.svg',
            color: ticketRefunded
                ? CustomTheme.darkGrey.withOpacity(0.5)
                : CustomTheme.primaryColor,
          ),
        ),
        SizedBox(width: Dimensions.getScaledSize(5.0)),
        Padding(
          padding: EdgeInsets.only(top: Dimensions.getScaledSize(5.0)),
          child: Text(
            '${DateFormat('EE dd.MM.yyyy', 'de-DE').format(dateTime).replaceFirst('.', ',')}',
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(11.0),
              color: ticketRefunded
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColor,
            ),
          ),
        ),
        SizedBox(width: Dimensions.getScaledSize(5.0)),
      ],
    );
  }
}

class TicketPreviewBookingTime extends StatelessWidget {
  final String? bookingTimeString;
  final bool ticketRefunded;

  TicketPreviewBookingTime(
      {this.bookingTimeString, required this.ticketRefunded});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: Dimensions.getScaledSize(18.0),
          width: Dimensions.getScaledSize(18.0),
        ),
        SizedBox(
          width: Dimensions.getScaledSize(5.0),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: Dimensions.getScaledSize(5.0),
          ),
          child: Text(
            bookingTimeString != null
                ? "${_getFormattedBookingTimeString(bookingTimeString!)} ${AppLocalizations.of(context)!.commonWords_clock}"
                : AppLocalizations.of(context)!.bookingListScreen_wholeDay,
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(11.0),
              color: ticketRefunded
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : CustomTheme.primaryColor,
            ),
          ),
        ),
        SizedBox(
          width: Dimensions.getScaledSize(5.0),
        ),
      ],
    );
  }
}

class TicketPreviewInfo extends StatelessWidget {
  final bool ticketRefunded;
  final ActivityModel activity;
  final BookingModel booking;
  final bool imageAvailable;
  final BookingTicket ticket;

  TicketPreviewInfo({
    required this.ticket,
    required this.activity,
    required this.ticketRefunded,
    required this.booking,
    required this.imageAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: Dimensions.getScaledSize(120.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: TicketPreviewImage(
                ticketRefunded: ticketRefunded,
                imageUrl: activity.thumbnail!.publicUrl,
                imageAvailable: imageAvailable),
          ),
          SizedBox(
            width: Dimensions.getScaledSize(10.0),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(
                        Dimensions.getScaledSize(14.0)),
                    fontWeight: FontWeight.bold,
                    color: ticketRefunded
                        ? CustomTheme.darkGrey.withOpacity(0.5)
                        : CustomTheme.primaryColorDark,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  height: Dimensions.getScaledSize(4.0),
                ),
                // Location Icon and Address Row
                TicketPreviewAddress(
                    ticketRefunded: ticketRefunded,
                    street: activity.location!.street!,
                    housenumber: activity.location!.housenumber!),
                SizedBox(
                  height: Dimensions.getScaledSize(2.0),
                ),
                // ZipCode and City Information
                TicketPreviewCityInfo(
                    ticketRefunded: ticketRefunded,
                    zipcode: activity.location!.zipcode.toString(),
                    city: activity.location!.city!),
                SizedBox(
                  height: Dimensions.getScaledSize(5.0),
                ),
                // Calendar and Date Information
                TicketPreviewDateInfo(
                    ticketRefunded: ticketRefunded,
                    dateTime: booking.bookingDate),
                TicketPreviewBookingTime(
                  bookingTimeString: ticket.bookingTimeString,
                  ticketRefunded: ticketRefunded,
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
