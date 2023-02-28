import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'widget_dimensions.dart';

class CommonWidget {
  static Widget showSpinner() {
    return Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              CustomTheme.theme.primaryColor)),
    );
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: CustomTheme.theme.primaryColorDark,
        textColor: Colors.white);
  }

  static Widget videoErrorView(
      bool isValidPreviewVideo, ActivityModel activityModel) {
    if (isValidPreviewVideo) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child:
            activityModel.activityDetails.media.previewVideoThumbnail != null ||
                    activityModel.activityDetails.media.previewVideoThumbnail
                            ?.publicUrl !=
                        null
                ? loadCachedNetworkImage(
                    activityModel
                        .activityDetails.media.previewVideoThumbnail?.publicUrl,
                    fit: BoxFit.cover,
                  )
                : Container(
                    child: Center(
                      child: Text("Video konnte nicht geladen werden"),
                    ),
                  ),
      );
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text(
              'Video konnte nicht geladen werden',
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(14.0),
                color: CustomTheme.primaryColorDark,
              ),
            )
          ],
        ),
      );
    }
  }
}
