import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/networkImage/network_image_loader.dart';
import 'package:appventure/utils/rive_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../size_config.dart';
import 'StringUtils.dart';

class ImageUtil {
  static Widget getImageFrom(
      {Icon icon, String networkImageURL, String assetPath}) {
    return (isNotNullOrEmpty(assetPath)
        ? (assetPath.endsWith(".svg")
            ? SvgPicture.asset(assetPath, height: 15)
            : Image.asset(assetPath, height: 15))
        : (isNotNullOrEmpty(networkImageURL)
            ? (networkImageURL.endsWith(".svg")
                ? SvgPicture.network(networkImageURL, height: 15)
                : loadCachedNetworkImage(networkImageURL, height: 15))
            : (icon != null ? icon : SizedBox.shrink())));
  }

  static Widget showPlaceholderView(
      {@required VoidCallback onUpdateBtnClicked}) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Keine Internetverbindung",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CustomTheme.primaryColorLight,
                fontFamily: CustomTheme.fontFamily,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Dein Gerät scheint gerade nicht mit dem Internet verbunden zu sein. Urn des komplette Appventure Angebot sehen zu konnen uberprufe bitte Deine Einstellungen",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: CustomTheme.primaryColorDark,
                  fontFamily: CustomTheme.fontFamily,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                onUpdateBtnClicked();
              },
              child: Container(
                  width: 180,
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: CustomTheme.darkGrey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Aktualisieren",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomTheme.primaryColorDark,
                          fontFamily: CustomTheme.fontFamily,
                        ),
                      ),
                      IconButton(
                          icon: new Icon(Icons.wifi_protected_setup),
                          onPressed: null)
                    ],
                  )),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.3,
              /*child: Image.asset(
                "lib/assets/images/bookings-placeholder.jpg",
                fit: BoxFit.cover,
              ),*/
              child: RiveAnimation(
                riveFileName: 'internet_connection_animiert_loop.riv',
                riveAnimationName: 'Animation 1',
                placeholderImage: 'lib/assets/images/bookings-placeholder.jpg',
                startAnimationAfterMilliseconds: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget showShimmerPlaceholder({double width, double height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey[200],
        enabled: true,
        child: Container(
          width: width,
          height: height,
          //color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
