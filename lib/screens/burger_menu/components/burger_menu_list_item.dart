import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BurgerMenuListItem extends StatelessWidget {
  final String text;
  final String subtitle;
  final String tapRoute;
  final Function tapActionPre;
  final Function tapActionPost;
  final Icon icon;
  final bool showSvg;
  final String svgPath;

  BurgerMenuListItem(
      {Key? key,
      this.text,
      this.subtitle,
      this.tapRoute,
      this.tapActionPre,
      this.tapActionPost,
      this.showSvg = false,
      this.svgPath,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget subtitleWidget = subtitle == null
        ? SizedBox.shrink()
        : Text(subtitle,
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(14.0),
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.3)));

    return Container(
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Colors.black.withOpacity(0.3))),
      ),
      child: Material(
        color: Colors.white.withOpacity(0.0),
        child: InkWell(
          splashColor: CustomTheme.primaryColorDark,
          onTap: () async {
            await tapActionPre?.call();
            if (isNotNullOrEmpty(tapRoute)) {
              if (tapActionPost != null)
                await Navigator.of(context).pushNamed(tapRoute);
              else
                Navigator.of(context).pushReplacementNamed(tapRoute);
            }
            tapActionPost?.call();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.getScaledSize(10.0),
              vertical: Dimensions.getScaledSize(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$text',
                      style: TextStyle(
                          fontSize: Dimensions.getScaledSize(16.0),
                          fontWeight: FontWeight.w500,
                          color: subtitle != null
                              ? CustomTheme.primaryColorDark
                              : CustomTheme.primaryColorDark),
                    ),
                    showSvg
                        ? SvgPicture.asset(svgPath,
                            color: CustomTheme.primaryColorDark,
                            height: Dimensions.pixels_30,
                            width: Dimensions.pixels_30)
                        : icon ?? SizedBox.shrink(),
                  ],
                ),
                subtitleWidget
              ],
            ),
          ),
        ),
      ),
    );
  }
}
