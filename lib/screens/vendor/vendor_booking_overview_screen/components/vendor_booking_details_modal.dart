import 'package:yucatan/models/booking_detailed_model.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_details_preview.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/booking_preview_model.dart';
import 'package:yucatan/screens/vendor/vendor_booking_overview_screen/components/vendor_booking_ticket_list_item.dart';
import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/services/response/booking_detailed_single_response_entity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'booking_categories.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VendorBookingDetailsModal extends StatefulWidget {
  final VendorBookingPreviewModel vendorBookingPreviewModel;
  final Category? category;
  final Function refresh;

  VendorBookingDetailsModal({
    required this.vendorBookingPreviewModel,
    this.category,
    required this.refresh,
  });

  @override
  _VendorBookingDetailsModalState createState() =>
      _VendorBookingDetailsModalState();
}

class _VendorBookingDetailsModalState extends State<VendorBookingDetailsModal> {
  Future<BookingDetailedSingleResponseEntity>? booking;
  CarouselController? _carouselController;
  int currentPage = 0;
  bool showTicketList = false;

  @override
  void initState() {
    super.initState();

    booking = BookingService.getBoookingDetailed(
        widget.vendorBookingPreviewModel.transactionModel.bookingId!);
  }

  void goBack() {
    setState(() {
      showTicketList = false;
      currentPage = 0;
    });
  }

  void openTicketList() {
    setState(() {
      showTicketList = true;
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
          child: FutureBuilder(
              future: booking,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData && snapshot.data != null) {
                  return !showTicketList
                      ? Center(
                          child: BookingDetailsPreview(
                            booking: snapshot.data as BookingDetailedModel,
                            category: widget.category!,
                            openTicketList: openTicketList,
                            refresh: widget.refresh,
                          ),
                        )
                      : _ticketSlider(snapshot.data as BookingDetailedModel,
                          _carouselController, currentPage);
                }

                if (snapshot.hasError) {
                  return Center(
                    child:
                        Text(AppLocalizations.of(context)!.commonWords_error),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }

  Widget _ticketSlider(
      BookingDetailedModel booking, _carouselController, currentPageValue) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            items: _buildTickets(booking),
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
          _currentTicketIndicator(currentPageValue)
        ],
      ),
    );
  }

  List<Widget> _buildTickets(BookingDetailedModel booking) {
    return widget.vendorBookingPreviewModel.ticketList.map((ticket) {
      var bookingTicket = booking.tickets!.firstWhere(
        (element) => element.id == ticket.id,
        // orElse: () => null
      );

      return GestureDetector(
        onTap: () {
          goBack();
        },
        child: VendorBookingTicketListItem(
            booking: booking.toBookingModel(),
            activity: booking.activity,
            ticket: bookingTicket,
            category: widget.category),
      );
    }).toList();
  }

  Widget _currentTicketIndicator(int currentPage) {
    List<Widget> indicators = [];

    for (int i = 0;
        i < widget.vendorBookingPreviewModel.ticketList.length;
        i++) {
      Widget element = Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentPage == i
              ? getCurrentColor(widget.category!)
              : Colors.white,
        ),
      );
      indicators.add(element);
    }

    return Container(
      width: 0.4 * MediaQuery.of(context).size.width,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: indicators),
    );
  }
}
