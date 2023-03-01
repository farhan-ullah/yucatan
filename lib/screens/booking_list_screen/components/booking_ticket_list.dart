import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/booking_model.dart' as BookingModel;
import 'package:yucatan/screens/booking_list_screen/components/booking_ticket_list_item.dart';
import 'package:yucatan/screens/booking_list_screen/components/round_indicator_list.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BookingTicketList extends StatefulWidget {
  final BookingModel.BookingModel booking;
  final ActivityModel activity;
  final bool offline;
  final double initialBrightness;

  BookingTicketList({
    required this.initialBrightness,
    required this.booking,
    required this.activity,
    required this.offline,
  });

  @override
  _BookingTicketListState createState() => _BookingTicketListState();
}

class _BookingTicketListState extends State<BookingTicketList> {
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    totalPages = widget.booking.tickets!.length;
    widget.booking.tickets!.sort((a, b) {
      if (a.status == "USABLE" && b.status == "USABLE") {
        return 0;
      } else if (a.status == "USABLE" && b.status != "USABLE") {
        return -1;
      } else if (a.status != "USABLE" && b.status == "USABLE") {
        return 1;
      } else if (a.status != "USABLE" && b.status != "USABLE") {
        return 0;
      }

      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider(
                  items: _buildTickets(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.6,
                    viewportFraction: 0.90,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: totalPages > 1,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: Dimensions.getScaledSize(20.0)),
                    child: RoundIndicatorList(
                      currentPage: currentPage,
                      numberOfPages: totalPages,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTickets() {
    return widget.booking.tickets!
        .map(
          (ticket) => BookingTicketListItem(
            initialBrightness: widget.initialBrightness,
            offline: widget.offline,
            activity: widget.activity,
            booking: widget.booking,
            ticket: ticket,
          ),
        )
        .toList();
  }
}
