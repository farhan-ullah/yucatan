import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class DescriptionItems extends StatelessWidget {
  final List<ActivityDetailDescriptionItemModel> descriptionItems;
  final bool shortDescription;

  DescriptionItems({
    required this.descriptionItems,
    required this.shortDescription,
  });

  final Map<String, IconData> _iconMapping = {
    'accessible': Icons.accessible_outlined,
    'cancel': Icons.cancel_outlined,
    'chevron_left': Icons.chevron_left_outlined,
    'chevron_right': Icons.chevron_right_outlined,
    'comment': Icons.comment_outlined,
    'confirmation_number': Icons.confirmation_number_outlined,
    'done': Icons.done_outlined,
    'favorite_border': Icons.favorite_border_outlined,
    'favorite': Icons.favorite_outlined,
    'group': Icons.group_outlined,
    'home': Icons.home_outlined,
    'local_movies': Icons.local_movies_outlined,
    'menu': Icons.menu_outlined,
    'navigation': Icons.navigation_outlined,
    'notifications': Icons.notifications_outlined,
    'play_arrow': Icons.play_arrow_outlined,
    'query_builder': Icons.query_builder_outlined,
    'search': Icons.search_outlined,
    'share': Icons.share_outlined,
    'star_rate': Icons.star_rate_outlined,
    'pets': Icons.pets_outlined,
    'event_busy': Icons.event_busy_outlined,
    'task_alt': Icons.event_busy_outlined,
  };

  IconData _getIconByName(String name) {
    var icon = _iconMapping.entries
        .firstWhere((element) => element.key == name, orElse: () => null)
        ?.value;

    return icon ?? Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...descriptionItems.map((descriptionItem) =>
            _buildDescriptionItem(descriptionItem, context))
      ],
    );
  }

  _buildDescriptionItem(ActivityDetailDescriptionItemModel descriptionItem,
      BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.getScaledSize(5.0),
        bottom: Dimensions.getScaledSize(5.0),
      ),
      child: Row(
        crossAxisAlignment: shortDescription
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimensions.getScaledSize(22.0),
            width: Dimensions.getScaledSize(22.0),
            child: Icon(
              _getIconByName(descriptionItem.iconName),
              size: Dimensions.getScaledSize(22.0),
            ),
          ),
          SizedBox(
            width: Dimensions.getScaledSize(10.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.getScaledSize(3),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    descriptionItem.shortDescription,
                    style: TextStyle(
                      fontWeight: shortDescription
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ),
                shortDescription
                    ? Container()
                    : SizedBox(
                        height: Dimensions.getScaledSize(5),
                      ),
                shortDescription
                    ? Container()
                    : Text(
                        descriptionItem.longDescription,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
