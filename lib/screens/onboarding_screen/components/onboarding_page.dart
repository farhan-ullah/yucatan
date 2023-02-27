import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'indicator_list.dart';
import 'onboarding_page_model.dart';

/*

padding(listview)+ padding(column) = 0.085*displayWidth


image height = 0.4
image width = 0.833.

logo height = 0.05
logo width = 0.5

paddings from top to bottom
1. padding/margin 0.05
2. padding/margin 0.05
3. padding/margin 0.015
4. padding/margin 0.05
5. padding/margin 0.04
6. padding/margin 0.09
7. padding/margin 0.025
8. padding/margin 0.025

indicator heignt 
indicator width 0.3


text heiht 0.06
text width 0.833333333

button height 0.06
button width 0.49

*/

class OnboardingPage extends StatelessWidget {
  final Function toNextPage;
  final Function finish;
  final OnboardingPageModel model;
  final int currentPage;
  final int numberOfPages;
  final double imageWidth;
  final double horizontalColumnPadding;
  final Function toNextPageScroll;
  final Function toPreviousPageScroll;

  OnboardingPage({
    @required this.model,
    @required this.toNextPage,
    @required this.finish,
    @required this.currentPage,
    @required this.numberOfPages,
    @required this.imageWidth,
    @required this.horizontalColumnPadding,
    @required this.toNextPageScroll,
    @required this.toPreviousPageScroll,
  });

  @override
  Widget build(BuildContext context) {
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;
    double imageHeight = displayHeight * 0.4;
    double textWidth = displayWidth * 0.75;
    double widthOfSingleItem = 2 * horizontalColumnPadding + imageWidth;
    double buttonWidth = displayWidth * 0.45;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dx > sensitivity) {
          toPreviousPageScroll(currentPage, widthOfSingleItem);
        } else if (details.delta.dx < -sensitivity) {
          toNextPageScroll(currentPage, widthOfSingleItem);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalColumnPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              child: SvgPicture.asset(
                "lib/assets/images/Appventure-Logotype_pos.svg",
                fit: BoxFit.fill,
                width: displayWidth * 0.5,
                height: displayHeight * 0.05,
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: displayHeight * 0.03),
            ),
            SizedBox(height: displayHeight * 0.03),
            ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.getScaledSize(10.0))),
              child: Image.asset(
                model.imagePath,
                fit: BoxFit.cover,
                width: imageWidth,
                height: imageHeight,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: displayHeight * 0.015),
              child: IndicatorList(
                currentPage: currentPage,
                numberOfPages: numberOfPages,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: displayHeight * 0.03),
              child: _OnboardingTitle(model.title),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              width: textWidth,
              child: _OnboardingText(model.text),
            ),
            Expanded(
              child: Container(),
            ),
            SizedBox(
              height: displayHeight * 0.01,
            ),
            Container(
              width: buttonWidth,
              height: displayHeight * 0.06,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  currentPage < numberOfPages - 1
                      ? toNextPage(currentPage, widthOfSingleItem)
                      : finish(context);
                },
                child: Text(
                  model.buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height > 600
                        ? Dimensions.getScaledSize(20.0)
                        : Dimensions.getScaledSize(15.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: displayHeight * 0.025),
              child: GestureDetector(
                onTap: () => finish(context),
                child: Text(
                  AppLocalizations.of(context).onboardingScreen_skip,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height > 600
                        ? Dimensions.getScaledSize(15.0)
                        : Dimensions.getScaledSize(12.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  final String _titleText;
  _OnboardingTitle(this._titleText);
  @override
  Widget build(BuildContext context) {
    return Text(
      _titleText,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height > 600
            ? Dimensions.getScaledSize(30.0)
            : Dimensions.getScaledSize(25.0),
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _OnboardingText extends StatelessWidget {
  final String _text;

  _OnboardingText(this._text);
  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.height > 600
              ? Dimensions.getScaledSize(15.0)
              : Dimensions.getScaledSize(12.0),
          color: Colors.white),
    );
  }
}
