import 'package:yucatan/screens/booking/components/booking_screen_time_slot_item_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class BookingScreenTimeSlotItem extends StatefulWidget {
  final BookingScreenTimeSlotItemModel timeSlotItemModel;
  final bool hasTime;
  final Function(BookingScreenTimeSlotItemModel) onSelected;

  BookingScreenTimeSlotItem({
    required this.timeSlotItemModel,
    required this.hasTime,
    required this.onSelected,
  });

  @override
  _BookingScreenTimeSlotItemState createState() =>
      _BookingScreenTimeSlotItemState();
}

class _BookingScreenTimeSlotItemState extends State<BookingScreenTimeSlotItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(widget.timeSlotItemModel);
      },
      child: Container(
        height: Dimensions.getScaledSize(35),
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.getScaledSize(4),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.getScaledSize(3),
          horizontal: Dimensions.getScaledSize(8),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Dimensions.getScaledSize(6),
          ),
          color: _getBackgroundColor(),
        ),
        child: widget.hasTime
            ? Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: Dimensions.getScaledSize(15),
                    color: _getTextColor(),
                  ),
                  SizedBox(
                    width: Dimensions.getScaledSize(5),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Dimensions.getScaledSize(3),
                      ),
                      child: Text(
                        "${widget.timeSlotItemModel.timeString} Uhr",
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(13),
                          color: _getTextColor(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.getScaledSize(5),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: _getContent(),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _getContent(),
              ),
      ),
    );
  }

  List<Widget> _getContent() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: Dimensions.getScaledSize(3),
        ),
        child: Text(
          _getFirstQuotaText(),
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(13),
            color: _getTextColor(),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: Dimensions.getScaledSize(3),
        ),
        child: Text(
          widget.timeSlotItemModel.remainingQuota > 10
              ? 10.toString()
              : widget.timeSlotItemModel.remainingQuota > 0
                  ? widget.timeSlotItemModel.remainingQuota.toString()
                  : "",
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(13),
            fontWeight: FontWeight.bold,
            color: _getTextColor(),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: Dimensions.getScaledSize(3),
        ),
        child: Text(
          _getSecondQuotaText(),
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(13),
            color: _getTextColor(),
          ),
        ),
      ),
    ];
  }

  ///Return text color based on remaining quota
  Color _getTextColor() {
    if (widget.timeSlotItemModel.remainingQuota == 0)
      return CustomTheme.accentColor1;

    return CustomTheme.primaryColorDark;
  }

  ///Return background color based on remaining quota
  Color _getBackgroundColor() {
    if (widget.timeSlotItemModel.remainingQuota == 0)
      return CustomTheme.accentColor1.withOpacity(0.1);

    return CustomTheme.mediumGrey.withOpacity(0.8);
  }

  ///Return text first based on remaining quota
  String _getFirstQuotaText() {
    if (widget.timeSlotItemModel.remainingQuota > 10) return "Mehr als ";
    if (widget.timeSlotItemModel.remainingQuota == 0) return "Ausverkauft";
    return "Noch ";
  }

  ///Return second text based on remaining quota
  String _getSecondQuotaText() {
    if (widget.timeSlotItemModel.remainingQuota > 10) return " verfügbar";
    if (widget.timeSlotItemModel.remainingQuota == 1)
      return " Ticket verfügbar";
    if (widget.timeSlotItemModel.remainingQuota == 0) return "";
    return " Tickets verfügbar";
  }
}
