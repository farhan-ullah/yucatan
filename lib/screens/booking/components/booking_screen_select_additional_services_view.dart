import 'package:appventure/components/colored_divider.dart';
import 'package:appventure/models/activity_model.dart';
import 'package:appventure/models/order_model.dart';
import 'package:appventure/screens/booking/components/booking_bar.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/StringUtils.dart';
import 'package:appventure/utils/networkImage/network_image_loader.dart';
import 'package:appventure/utils/price_format_utils.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'discard_dialog.dart';

class BookingScreenSelectAdditionalServicesView extends StatefulWidget {
  final ProductAdditionalService additionalService;
  final Function onAddAdditionalService;
  final ActivityBookingDetails bookingDetails;
  final OrderProduct orderProduct;

  BookingScreenSelectAdditionalServicesView({
    @required this.additionalService,
    @required this.onAddAdditionalService,
    @required this.bookingDetails,
    @required this.orderProduct,
  });

  @override
  _BookingScreenSelectAdditionalServicesViewState createState() =>
      _BookingScreenSelectAdditionalServicesViewState();
}

class _BookingScreenSelectAdditionalServicesViewState
    extends State<BookingScreenSelectAdditionalServicesView> {
  OrderProductAdditionalService orderProductAdditionalService;
  Map<String, TextEditingController> _propertyTextEditingControllers = Map();
  bool _showDiscardContainer = false;

  @override
  void initState() {
    widget.additionalService.properties.forEach((element) {
      if (element.type == ProductPropertyType.NUMBER ||
          element.type == ProductPropertyType.TEXT) {
        _propertyTextEditingControllers.putIfAbsent(
            element.id, () => TextEditingController());
      }
    });

    if (widget.orderProduct.additionalServices.any(
      (element) => element.id == widget.additionalService.id,
    )) {
      orderProductAdditionalService =
          widget.orderProduct.additionalServices.firstWhere(
        (element) => element.id == widget.additionalService.id,
      );

      orderProductAdditionalService.properties.forEach((element) {
        if (_propertyTextEditingControllers.containsKey(element.id)) {
          _propertyTextEditingControllers[element.id].text = element.value;
        }
      });
    } else {
      orderProductAdditionalService = OrderProductAdditionalService(
        id: widget.additionalService.id,
        amount: 1,
        properties: [],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _propertyTextEditingControllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: CustomTheme.primaryColorDark,
        body: SafeArea(
          bottom: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: Dimensions.getHeight(percentage: 30.0),
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            loadCachedNetworkImage(
                              isNotNullOrEmpty(
                                      widget.additionalService.image?.publicUrl)
                                  ? widget.additionalService.image?.publicUrl
                                  : "",
                              fit: BoxFit.cover,
                              height: Dimensions.getHeight(percentage: 30.0),
                              width: MediaQuery.of(context).size.width,
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: Dimensions.getHeight(percentage: 10.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      CustomTheme.primaryColor.withOpacity(0.8),
                                      Colors.transparent
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(30.0),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: Dimensions.getScaledSize(24.0),
                          right: Dimensions.getScaledSize(24.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.additionalService.title,
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(20.0),
                                      fontWeight: FontWeight.bold,
                                      color: CustomTheme.primaryColorDark,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${formatPriceDouble(widget.additionalService.price)} €',
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(20.0),
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(30.0),
                            ),
                            Text(
                              widget.additionalService.description,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(14.0),
                                color: CustomTheme.disabledColor,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(30.0),
                            ),
                            ..._getProductProperties(),
                            widget.additionalService.properties == null ||
                                    widget.additionalService.properties
                                            .length ==
                                        0
                                ? Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .bookingScreen_count,
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(16.0),
                                          fontWeight: FontWeight.bold,
                                          color: CustomTheme.primaryColorDark,
                                        ),
                                      ),
                                      Container(
                                        height: Dimensions.getScaledSize(30.0),
                                        width: Dimensions.getScaledSize(120.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: Dimensions.getScaledSize(
                                                  20.0),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (orderProductAdditionalService
                                                            .amount >
                                                        1) {
                                                      orderProductAdditionalService
                                                          .amount -= 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          Dimensions
                                                              .getScaledSize(
                                                                  5.0)),
                                                      bottomLeft: Radius
                                                          .circular(Dimensions
                                                              .getScaledSize(
                                                                  5.0)),
                                                    ),
                                                    border: Border.all(
                                                      color: CustomTheme
                                                          .mediumGrey,
                                                    ),
                                                    color:
                                                        CustomTheme.lightGrey,
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: widget
                                                                  .additionalService
                                                                  .properties
                                                                  .length ==
                                                              0
                                                          ? orderProductAdditionalService
                                                                      .amount >
                                                                  1
                                                              ? CustomTheme
                                                                  .darkGrey
                                                              : CustomTheme
                                                                  .mediumGrey
                                                          : CustomTheme
                                                              .mediumGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        CustomTheme.mediumGrey,
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    orderProductAdditionalService
                                                        .amount
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: Dimensions
                                                          .getScaledSize(18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: CustomTheme
                                                          .primaryColorDark,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    orderProductAdditionalService
                                                        .amount += 1;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight: Radius.circular(
                                                          Dimensions
                                                              .getScaledSize(
                                                                  5.0)),
                                                      bottomRight: Radius
                                                          .circular(Dimensions
                                                              .getScaledSize(
                                                                  5.0)),
                                                    ),
                                                    border: Border.all(
                                                      color: CustomTheme
                                                          .mediumGrey,
                                                    ),
                                                    color:
                                                        CustomTheme.lightGrey,
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: widget
                                                                  .additionalService
                                                                  .properties
                                                                  .length ==
                                                              0
                                                          ? Colors.black
                                                          : CustomTheme
                                                              .darkGrey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: Dimensions.getScaledSize(60.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: ColoredDivider(
                    height: Dimensions.getScaledSize(5.0),
                  ),
                ),
                Positioned(
                  top: Dimensions.getScaledSize(5.0),
                  left: 0,
                  child: Container(
                    height: AppBar().preferredSize.height,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: AppBar().preferredSize.height,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Dimensions.getScaledSize(8.0),
                                left: Dimensions.getScaledSize(8.0)),
                            child: Container(
                              width: AppBar().preferredSize.height -
                                  Dimensions.getScaledSize(8.0),
                              height: AppBar().preferredSize.height -
                                  Dimensions.getScaledSize(8.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.4),
                                  shape: BoxShape.circle),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(CustomTheme.iconRadius),
                                  ),
                                  onTap: () {
                                    bool isFieldsEmpty = true;
                                    if (widget.additionalService != null) {
                                      if (widget.additionalService.properties !=
                                          null) {
                                        for (int i = 0;
                                            i <
                                                widget.additionalService
                                                    .properties.length;
                                            i++) {
                                          ProductProperty productProperty =
                                              widget.additionalService
                                                  .properties[i];
                                          if (productProperty.type !=
                                              ProductPropertyType.DROPDOWN) {
                                            TextEditingController
                                                textEditingController =
                                                _propertyTextEditingControllers[
                                                    productProperty.id];
                                            if (textEditingController.text
                                                .trim()
                                                .isNotEmpty) {
                                              isFieldsEmpty = false;
                                            }
                                          }
                                        }
                                      }
                                    }
                                    if (isFieldsEmpty) {
                                      Navigator.of(context).pop();
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DiscardDialog(() {
                                                Navigator.of(context).pop();
                                              }, () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                new TextEditingController()
                                                    .clear();
                                              }, false));
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.getScaledSize(8.0)),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0 - MediaQuery.of(context).viewInsets.bottom,
                  child: BookingBar(
                    bookingDetails: widget.bookingDetails,
                    orderProducts: [widget.orderProduct],
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onAddAdditionalService(
                          orderProductAdditionalService);
                    },
                    buttonText:
                        AppLocalizations.of(context).bookingScreen_finish,
                  ),
                ),
                Positioned(
                  top: 0,
                  child: AnimatedContainer(
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: _showDiscardContainer
                        ? MediaQuery.of(context).size.height -
                            Dimensions.getScaledSize(60.0) -
                            MediaQuery.of(context).padding.bottom -
                            MediaQuery.of(context).padding.top
                        : 0,
                    width: MediaQuery.of(context).size.width,
                    color: CustomTheme.primaryColorDark.withOpacity(0.3),
                    child: Stack(
                      children: [
                        IntrinsicHeight(
                          // color: Colors.white,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'lib/assets/images/warning.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fitHeight,
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(5.0),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .bookingScreen_warning,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(20.0),
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.darkGrey,
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(5.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: Dimensions.getScaledSize(24.0),
                                    right: Dimensions.getScaledSize(24.0),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .bookingScreen_closeWindowWarning,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(18.0),
                                      color: CustomTheme.darkGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(15.0),
                                ),
                                Container(
                                  width: Dimensions.getScaledSize(200.0),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showDiscardContainer = false;
                                      });
                                    },
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        overlayColor: MaterialStateProperty.all(
                                            CustomTheme.primaryColorDark),
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                          width: 1,
                                          color: CustomTheme.darkGrey,
                                        ))),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .bookingScreen_next,
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(16.0),
                                          fontWeight: FontWeight.bold,
                                          color: CustomTheme.primaryColorDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(5.0),
                                ),
                                Container(
                                  width: Dimensions.getScaledSize(200.0),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        overlayColor: MaterialStateProperty.all(
                                            CustomTheme.primaryColorDark),
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                          width: 1,
                                          color: CustomTheme.darkGrey,
                                        ))),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .bookingScreen_clear,
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(16.0),
                                          fontWeight: FontWeight.bold,
                                          color: CustomTheme.primaryColorDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(30.0),
                                ),
                                ColoredDivider(
                                  height: Dimensions.getScaledSize(5.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: Dimensions.getScaledSize(18.0),
                          left: Dimensions.getScaledSize(18.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showDiscardContainer = false;
                              });
                            },
                            child: Container(
                              height: Dimensions.getScaledSize(32.0),
                              width: Dimensions.getScaledSize(32.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.getScaledSize(48.0)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: Dimensions.getScaledSize(24.0),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () {
        return Future.sync(() {
          bool isFieldsEmpty = true;
          if (widget.additionalService != null) {
            if (widget.additionalService.properties != null) {
              for (int i = 0;
                  i < widget.additionalService.properties.length;
                  i++) {
                ProductProperty productProperty =
                    widget.additionalService.properties[i];
                if (productProperty.type != ProductPropertyType.DROPDOWN) {
                  TextEditingController textEditingController =
                      _propertyTextEditingControllers[productProperty.id];
                  if (textEditingController.text.trim().isNotEmpty) {
                    isFieldsEmpty = false;
                  }
                }
              }
            }
          }
          if (isFieldsEmpty) {
            Navigator.of(context).pop();
          } else {
            showDialog(
                context: context,
                builder: (context) => DiscardDialog(() {
                      Navigator.of(context).pop();
                    }, () {
                      FocusScope.of(context).unfocus();
                      new TextEditingController().clear();
                    }, true));
          }
          /*setState(() {
            _showDiscardContainer = true;
          });*/
          return false;
        });
      },
    );
  }

  List<Widget> _getProductProperties() {
    List<Widget> widgets = [];

    widget.additionalService.properties.forEach((productProperty) {
      if (productProperty.type == ProductPropertyType.DROPDOWN)
        widgets.add(
          _getDropDownPropertyWidget(productProperty),
        );
      else if (productProperty.type == ProductPropertyType.NUMBER)
        widgets.add(
          _getNumberPropertyWidget(productProperty),
        );
      else if (productProperty.type == ProductPropertyType.TEXT)
        widgets.add(
          _getTextPropertyWidget(productProperty),
        );

      widgets.add(
        SizedBox(
          height: Dimensions.getScaledSize(30.0),
        ),
      );
    });

    return widgets;
  }

  Widget _getDropDownPropertyWidget(ProductProperty productProperty) {
    return Row(
      children: [
        Flexible(
          child: Text(
            productProperty.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(16.0),
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColorDark,
            ),
          ),
        ),
        SizedBox(
          width: Dimensions.getScaledSize(20),
        ),
        Container(
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(24.0),
            right: Dimensions.getScaledSize(24.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.getScaledSize(12.0)),
            color: CustomTheme.mediumGrey,
          ),
          child: DropdownButton(
            underline: Container(),
            hint: Text(
              AppLocalizations.of(context).bookingScreen_choose,
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(20.0),
                fontWeight: FontWeight.bold,
                color: CustomTheme.primaryColorDark,
              ),
            ),
            items: productProperty.dropdownValues
                .map(
                  (dropdownValue) => DropdownMenuItem(
                    child: Text(dropdownValue.text),
                    value: dropdownValue.value,
                  ),
                )
                .toList(),
            value: _getCurrentValueForProductProperty(productProperty.id),
            onChanged: (value) {
              setState(() {
                _updateProductProperty(productProperty.id, value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _getNumberPropertyWidget(ProductProperty additionalServiceProperty) {
    return Column(
      children: [
        Text(
          additionalServiceProperty.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(16.0),
            fontWeight: FontWeight.bold,
            color: CustomTheme.primaryColorDark,
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(15.0),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: Dimensions.getScaledSize(48.0),
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(24.0),
            right: Dimensions.getScaledSize(24.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.getScaledSize(12.0)),
            color: CustomTheme.mediumGrey,
          ),
          child: TextField(
            maxLines: 1,
            controller:
                _propertyTextEditingControllers[additionalServiceProperty.id],
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(16.0),
            ),
            cursorColor: Theme.of(context).primaryColor,
            decoration: new InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                _updateProductProperty(additionalServiceProperty.id, value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _getTextPropertyWidget(ProductProperty additionalServiceProperty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          additionalServiceProperty.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(16.0),
            fontWeight: FontWeight.bold,
            color: CustomTheme.primaryColorDark,
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(15.0),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: Dimensions.getScaledSize(48.0),
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(24.0),
            right: Dimensions.getScaledSize(24.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.getScaledSize(12.0)),
            color: CustomTheme.mediumGrey,
          ),
          child: TextField(
            maxLines: 1,
            controller:
                _propertyTextEditingControllers[additionalServiceProperty.id],
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(16.0),
            ),
            cursorColor: Theme.of(context).primaryColor,
            decoration: new InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                _updateProductProperty(additionalServiceProperty.id, value);
              });
            },
          ),
        ),
      ],
    );
  }

  String _getCurrentValueForProductProperty(String id) {
    final productProperty = orderProductAdditionalService.properties.firstWhere(
      (element) => element.id == id,
      orElse: () => null,
    );

    if (productProperty == null) return null;

    return productProperty.value;
  }

  void _updateProductProperty(String id, String value) {
    final productProperty = orderProductAdditionalService.properties.firstWhere(
      (element) => element.id == id,
      orElse: () => null,
    );

    if (productProperty == null) {
      orderProductAdditionalService.properties.add(
        OrderProductProperty(
          id: id,
          value: value,
        ),
      );
      return;
    }

    productProperty.value = value;
  }
}
