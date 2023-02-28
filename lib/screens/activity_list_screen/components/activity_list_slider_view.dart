import 'dart:async';

import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityListSliderView extends StatefulWidget {
  final double opValue;
  final VoidCallback onSearchTap;
  final AnimationController animationController;

  const ActivityListSliderView({
    Key? key,
    this.opValue = 0.0,
    this.onSearchTap,
    this.animationController,
  }) : super(key: key);
  @override
  _ActivityListSliderViewState createState() => _ActivityListSliderViewState();
}

class _ActivityListSliderViewState extends State<ActivityListSliderView> {
  var pageController = InfinityPageController(initialPage: 0);
  var indicatorPageController = PageController();
  var pageViewModelData = <PageViewData>[];

  Timer sliderTimer;
  var currentShowIndex = 0;

  @override
  void initState() {
    pageViewModelData.add(PageViewData(
      titleText: '',
      subText: '',
      assetsImage: 'lib/assets/images/homescreen1.jpg',
    ));
    pageViewModelData.add(PageViewData(
      titleText: '',
      subText: '',
      assetsImage: 'lib/assets/images/homescreen2.jpg',
    ));
    pageViewModelData.add(PageViewData(
      titleText: '',
      subText: '',
      assetsImage: 'lib/assets/images/homescreen3.jpg',
    ));

    try {
      sliderTimer = Timer.periodic(Duration(seconds: 4), (timer) {
        if (widget.animationController.value <= 0) {
          pageController.pageController.nextPage(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    } catch (e) {
      //print(e);
    }
    super.initState();
  }

  @override
  void dispose() {
    sliderTimer?.cancel();
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InfinityPageView(
          itemBuilder: (BuildContext context, int index) {
            switch (index) {
              case 0:
                return PagePopup(
                  imageData: pageViewModelData[0],
                  opValue: widget.opValue,
                );
              case 1:
                return PagePopup(
                  imageData: pageViewModelData[1],
                  opValue: widget.opValue,
                );
              case 2:
                return PagePopup(
                  imageData: pageViewModelData[2],
                  opValue: widget.opValue,
                );
              default:
                return Container();
            }
          },
          itemCount: 3,
          onPageChanged: (index) {
            setState(() {
              currentShowIndex = index;
            });
          },
          controller: pageController,
        ),
        widget.animationController.value <= 0.54
            ? Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity:
                      _getOpacityForSearchUi(widget.animationController.value),
                  child: searchUi(),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget searchUi() {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimensions.getScaledSize(24),
          right: Dimensions.getScaledSize(24),
          top: Dimensions.getScaledSize(16)),
      child: Container(
        decoration: BoxDecoration(
          color: CustomTheme.backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              Dimensions.getScaledSize(10.0),
            ),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: CustomTheme.grey,
              blurRadius: Dimensions.getScaledSize(8.0),
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.getScaledSize(16.0),
          ),
          height: Dimensions.getScaledSize(48.0),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Dimensions.getScaledSize(10.0),
                ),
              ),
              onTap: () {
                widget.onSearchTap();
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.activityScreen_search,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(15),
                        color: CustomTheme.hintText,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    size: Dimensions.getScaledSize(32.0),
                    color: CustomTheme.primaryColorDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getOpacityForSearchUi(double animationControllerValue) {
    var opacity = (0.54 - animationControllerValue) * 8.0;

    if (opacity > 1.0)
      return 1.0;
    else if (opacity < 0.0)
      return 0.0;
    else
      return opacity;
  }
}

class PagePopup extends StatelessWidget {
  final PageViewData imageData;
  final double opValue;

  const PagePopup({Key? key, this.imageData, this.opValue: 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.39,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            imageData.assetsImage,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.195,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  CustomTheme.primaryColor.withOpacity(0.5),
                  Colors.transparent
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PageViewData {
  final String titleText;
  final String subText;
  final String assetsImage;

  PageViewData({this.titleText, this.subText, this.assetsImage});
}
