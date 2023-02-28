import 'dart:ui';

import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CustomErrorEmptyScreen extends StatefulWidget {
  final String? title;
  final String? description;
  final String? customText;
  final VoidCallback? callback;
  final String? customButtonText;
  final bool showButton;
  final Widget? customWidget;
  final RiveAnimation? rive;
  final String? image;
  final double topPadding;
  final Color? titleColor;

  CustomErrorEmptyScreen(
      {this.callback,
      required this.title,
      required this.description,
      this.customText,
      this.customButtonText,
      this.showButton = true,
      this.customWidget,
      this.topPadding = 0,
      this.rive,
      this.image,
      this.titleColor})
      : assert(!showButton || customButtonText != null, 'add button text'),
        assert(!showButton || callback != null, 'add button callback');

  @override
  _CustomErrorEmptyScreenState createState() {
    return _CustomErrorEmptyScreenState();
  }
}

class _CustomErrorEmptyScreenState extends State<CustomErrorEmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.getScaledSize(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: Dimensions.getScaledSize(widget.topPadding),
          ),
          Expanded(flex: 3, child: Container()),
          Text(
            widget.title!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.titleColor ?? CustomTheme.primaryColorDark,
              fontSize: Dimensions.getScaledSize(20.0),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Dimensions.getScaledSize(20.0)),
          Text(
            widget.description!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Dimensions.getScaledSize(16.0),
                letterSpacing: CustomTheme.letterSpacing,
                color: CustomTheme.primaryColorDark),
          ),
          SizedBox(height: Dimensions.getScaledSize(30.0)),
          SizedBox(
            height: Dimensions.getHeight(percentage: 35.0),
            child: widget.image != null
                ? Image.asset(
                    widget.image!,
                    fit: BoxFit.cover,
                  )
                : widget.rive != null
                    ? widget.rive
                    : widget.customWidget ?? Container(),
          ),
          Expanded(flex: 2, child: Container()),
          widget.customText != null
              ? Text(
                  widget.customText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Dimensions.getScaledSize(16.0),
                      letterSpacing: CustomTheme.letterSpacing,
                      color: CustomTheme.primaryColorDark),
                )
              : Container(),
          widget.showButton && widget.customText != null
              ? Expanded(flex: 2, child: Container())
              : Container(),
          widget.showButton
              ? Container(
                  width: Dimensions.getWidth(percentage: 55),
                  height: Dimensions.getScaledSize(45.0),
                  child: OutlinedButton(
                    onPressed: widget.callback,
                    child: Text(
                      widget.customButtonText!,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(18.0),
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                    style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          color: CustomTheme.primaryColorDark,
                        )),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(
                            CustomTheme.primaryColorDark),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              Dimensions.getScaledSize(7.0)),
                        ))),
                  ),
                )
              : Container(),
          Expanded(flex: 5, child: Container()),
        ],
      ),
    );
  }
}
