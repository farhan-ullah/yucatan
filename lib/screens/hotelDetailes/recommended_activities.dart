import 'package:appventure/models/activity_model.dart';
import 'package:appventure/screens/activity_list_screen/components/activily_list_item_shimmer.dart';
import 'package:appventure/screens/hotelDetailes/recommended_activities_item.dart';
import 'package:appventure/services/activity_service.dart';
import 'package:appventure/services/response/activity_multi_response.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class RecommendedActivities extends StatefulWidget {
  final String activityId;
  final Future<ActivityMultiResponse> activities;

  RecommendedActivities({@required this.activityId})
      : activities = ActivityService.getAll();

  @override
  _RecommendedActivitiesState createState() => _RecommendedActivitiesState();
}

class _RecommendedActivitiesState extends State<RecommendedActivities> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ActivityMultiResponse>(
      future: widget.activities,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              items: _buildRecommendedActivities(snapshot.data.data),
              options: CarouselOptions(
                height: Dimensions.getHeight(percentage: 29.0),
                viewportFraction: 0.85,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return ActivityListViewShimmer(
            width: Dimensions.getWidth(percentage: 80.0)
        );
      },
    );
  }

  List<Widget> _buildRecommendedActivities(List<ActivityModel> activities) {
    List<Widget> widgets = [];

    activities.forEach(
      (element) {
        if (element.sId == widget.activityId) {
          return;
        }
        widgets.add(
          RecommendedActivitiesItem(
            activity: element,
          ),
        );
      },
    );

    if(widgets.isEmpty) {
      widgets.add(
        ActivityListViewShimmer(
          width: Dimensions.getWidth(percentage: 80.0)
        )
      );
    }

    return widgets;
  }
}
