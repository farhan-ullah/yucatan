import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/activity_list_screen/components/activity_list_item_view.dart';
import 'package:yucatan/screens/hotelDetailes/hotelDetailes.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class RecommendedActivitiesItem extends StatefulWidget {
  final ActivityModel? activity;

  const RecommendedActivitiesItem({
    this.activity,
  });

  @override
  _RecommendedActivitiesItemState createState() =>
      _RecommendedActivitiesItemState();
}

class _RecommendedActivitiesItemState extends State<RecommendedActivitiesItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HotelDetailes(
              //TODO check if it is favorite
              isFavorite: false,
              //hotelData: widget.activity,
              activityId: widget.activity!.sId,
            ),
          ),
        );
      },
      child: ActivityListViewItem(
        activityModel: widget.activity,
        isFavorite: false,
        width: Dimensions.getWidth(percentage: 80.0),
      ),
    );
  }
}
