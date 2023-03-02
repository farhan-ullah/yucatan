import 'package:yucatan/models/activity_category_data_model.dart';
import 'package:yucatan/screens/activity_list_screen/components/activily_list_item_shimmer.dart';
import 'package:yucatan/services/activity_service.dart';
import 'package:yucatan/services/response/activity_by_category_response.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'activity_list_item_view.dart';

class ActivityListCategoryView extends StatefulWidget {
  final String? category;
  final String? categoryId;
  final List<String>? favoriteIds;

  ActivityListCategoryView({
    this.category,
    this.categoryId,
    this.favoriteIds,
  });

  @override
  _ActivityListCategoryViewState createState() =>
      _ActivityListCategoryViewState();
}

class _ActivityListCategoryViewState extends State<ActivityListCategoryView>
    with AutomaticKeepAliveClientMixin {
  Future<ActivityByCategoryResponse?>? activities;
  //List<ActivityModel> activityList = [];

  @override
  void initState() {
    super.initState();
    activities =
        ActivityService.getAllForCategory(widget.categoryId!, widget.category!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getScaledSize(24.0),
          ),
          child: Text(
            widget.category!,
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(18.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(10.0),
        ),
        FutureBuilder<ActivityByCategoryResponse?>(
          future: activities,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.data == null) {
                return Container();
              }
              return Container(
                height: snapshot.data!.data!.length > 0
                    ? Dimensions.getHeight(percentage: 29.0)
                    : 0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ActivityListViewItem(
                      activityCategoryModel: snapshot.data!.data![index],
                      isFavorite: widget.favoriteIds == null
                          ? false
                          : widget.favoriteIds!
                              .contains(snapshot.data!.data![index].id),
                      width: Dimensions.getScaledSize(280),
                    );
                  },
                  itemCount: snapshot.data!.data!.length,
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.only(left: Dimensions.getScaledSize(12.0)),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return Padding(
              padding: EdgeInsets.only(left: Dimensions.getScaledSize(12.0)),
              child: ActivityListViewShimmer(
                width: MediaQuery.of(context).size.width * 0.60,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RandomActivityData {
  List<ActivityCategoryDataModel>? activityModelList;
  List<int>? randomNumbers;
}
