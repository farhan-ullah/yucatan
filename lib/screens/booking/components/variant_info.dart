import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class VariantInfo extends StatelessWidget {
  // final ActivityBookingTicket variant;

  // VariantInfo({required this.variant});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.getScaledSize(24.0)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CustomTheme.borderRadius),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(CustomTheme.borderRadius),
                                topRight: Radius.circular(
                                  CustomTheme.borderRadius,
                                ),
                              ),
                              child:
                                  // loadCachedNetworkImage(
                                  //     variant.imageUrl,
                                  //     fit: BoxFit.cover
                                  // ),
                                  Container(),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    Dimensions.getScaledSize(20.0)),
                                child: //Text(variant.customText),
                                    Text('Platzhalter'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: Dimensions.getScaledSize(4.0),
                          right: Dimensions.getScaledSize(4.0),
                        ),
                        width: Dimensions.getScaledSize(36.0),
                        height: Dimensions.getScaledSize(36.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.6),
                            shape: BoxShape.circle),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(CustomTheme.iconRadius),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: Dimensions.getScaledSize(24.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
