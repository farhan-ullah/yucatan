import 'package:yucatan/screens/booking/components/booking_screen_time_slot_item_model.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/screens/booking/components/booking_bar.dart';
import 'package:yucatan/screens/booking/components/booking_screen_select_additional_services_view.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BookingScreenSelectPropertiesView extends StatefulWidget {
  final Product? product;
  final BookingScreenTimeSlotItemModel? bookingScreenTimeSlotItemModel;
  final Function? onAddOrderProduct;
  final Function? onPreviousBookingStep;
  final ActivityBookingDetails? bookingDetails;
  final OrderProduct? existingOrderProduct;
  final int? index;

  BookingScreenSelectPropertiesView({
    required this.product,
    required this.bookingScreenTimeSlotItemModel,
    required this.onAddOrderProduct,
    required this.onPreviousBookingStep,
    required this.bookingDetails,
    this.existingOrderProduct,
    this.index,
  });

  @override
  _BookingScreenSelectPropertiesViewState createState() =>
      _BookingScreenSelectPropertiesViewState();
}

class _BookingScreenSelectPropertiesViewState
    extends State<BookingScreenSelectPropertiesView> {
  OrderProduct? orderProduct;
  Map<String, TextEditingController> _propertyTextEditingControllers = Map();

  @override
  void initState() {
    widget.product!.properties!.forEach((element) {
      if (element.type == ProductPropertyType.NUMBER ||
          element.type == ProductPropertyType.TEXT) {
        _propertyTextEditingControllers.putIfAbsent(
            element.id!, () => TextEditingController());
      }
    });

    if (widget.existingOrderProduct != null) {
      orderProduct = widget.existingOrderProduct;

      orderProduct!.properties!.forEach((element) {
        if (_propertyTextEditingControllers.containsKey(element.id)) {
          _propertyTextEditingControllers[element.id]!.text = element.value!;
        }
      });
    } else {
      int? hour = 0;
      int? minute = 0;

      if (widget.bookingScreenTimeSlotItemModel!.timeString != null) {
        var splittedTime =
            widget.bookingScreenTimeSlotItemModel!.timeString.split(":");

        hour = int.tryParse(splittedTime[0]);
        hour = hour != null ? hour : 0;

        minute = int.tryParse(splittedTime[1]);
        minute = minute != null ? minute : 0;
      }

      orderProduct = OrderProduct(
        id: widget.product!.id,
        amount: 1,
        properties: [],
        additionalServices: [],
        bookingScreenTimeSlotItemModel: widget.bookingScreenTimeSlotItemModel,
        bookingTimeString:
            widget.bookingScreenTimeSlotItemModel!.timeString != null
                ? "${hour.toString()}:${minute.toString()}"
                : null,
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

  bool _checkproperties() {
    bool propertiesValid = true;
    widget.product!.properties!.forEach((property) {
      if (property.isRequired!) {
        final orderdProperty = orderProduct!.properties!.firstWhere(
          (element) => element.id == property.id,
          // orElse: () => null
        );
        if (orderdProperty == null || orderdProperty.value == null) {
          propertiesValid = false;
        }
      }
    });
    return propertiesValid;
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
                                      widget.product!.image!.publicUrl!)
                                  ? widget.product!.image!.publicUrl!
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
                        height: Dimensions.getScaledSize(20.0),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.getScaledSize(24.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product!.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(18.0),
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.primaryColorDark,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(20.0),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${formatPriceDouble(widget.product!.price!)}',
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(18.0),
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.primaryColor,
                                  ),
                                ),
                                Text(
                                  '€',
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(16.0),
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.primaryColor,
                                  ),
                                ),
                                Text(
                                  '  ${AppLocalizations.of(context)!.bookingScreen_perTicket}',
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(12.0),
                                    color: CustomTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(20.0),
                            ),
                            Text(
                              widget.product!.description!,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(12.0),
                                color: CustomTheme.darkGrey,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(30.0),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time_outlined,
                                  size: Dimensions.getScaledSize(18),
                                  color: CustomTheme.primaryColorDark,
                                ),
                                SizedBox(
                                  width: Dimensions.getScaledSize(8.0),
                                ),
                                widget.bookingScreenTimeSlotItemModel!
                                            .timeString !=
                                        null
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: Dimensions.getScaledSize(2.0),
                                          right: Dimensions.getScaledSize(8.0),
                                        ),
                                        child: Text(
                                          "${widget.bookingScreenTimeSlotItemModel!.timeString} ${AppLocalizations.of(context)!.commonWords_clock}",
                                          style: TextStyle(
                                            fontSize:
                                                Dimensions.getScaledSize(13),
                                            color: CustomTheme.primaryColorDark,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Dimensions.getScaledSize(2.0),
                                  ),
                                  child: Text(
                                    "${DateFormat("EEEE, dd. LLL yyyy", "de-DE").format(widget.bookingScreenTimeSlotItemModel!.dateTime)}",
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(13),
                                      color: CustomTheme.primaryColorDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.getScaledSize(15.0),
                            ),
                            ..._getProductProperties(),
                            widget.product!.properties == null ||
                                    widget.product!.properties!.length == 0
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline_outlined,
                                        size: Dimensions.getScaledSize(18),
                                        color: CustomTheme.primaryColorDark,
                                      ),
                                      SizedBox(
                                        width: Dimensions.getScaledSize(8),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: Dimensions.getScaledSize(3),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .bookingScreen_count,
                                          style: TextStyle(
                                            fontSize:
                                                Dimensions.getScaledSize(13.0),
                                            color: CustomTheme.primaryColorDark,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: Dimensions.getScaledSize(30.0),
                                        width: Dimensions.getScaledSize(103.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: Dimensions.getScaledSize(
                                                13.0,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (orderProduct!.amount! >
                                                        1) {
                                                      orderProduct!.amount! - 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        Dimensions
                                                            .getScaledSize(5.0),
                                                      ),
                                                      bottomLeft:
                                                          Radius.circular(
                                                        Dimensions
                                                            .getScaledSize(5.0),
                                                      ),
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
                                                      color: orderProduct!
                                                                  .amount! >
                                                              1
                                                          ? CustomTheme.darkGrey
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
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: Dimensions
                                                          .getScaledSize(2),
                                                    ),
                                                    child: Text(
                                                      orderProduct!.amount!
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: Dimensions
                                                            .getScaledSize(
                                                                16.0),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: CustomTheme
                                                            .primaryColorDark,
                                                      ),
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
                                                    if (widget.bookingScreenTimeSlotItemModel!
                                                                .remainingQuota -
                                                            orderProduct!
                                                                .amount! >
                                                        0) {
                                                      orderProduct!.amount! + 1;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight: Radius.circular(
                                                        Dimensions
                                                            .getScaledSize(5.0),
                                                      ),
                                                      bottomRight:
                                                          Radius.circular(
                                                        Dimensions
                                                            .getScaledSize(5.0),
                                                      ),
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
                                                      color: widget.bookingScreenTimeSlotItemModel!
                                                                      .remainingQuota -
                                                                  orderProduct!
                                                                      .amount! >
                                                              0
                                                          ? CustomTheme.darkGrey
                                                          : CustomTheme
                                                              .mediumGrey,
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
                            widget.product!.properties == null ||
                                    widget.product!.properties!.length == 0
                                ? SizedBox(
                                    height: Dimensions.getScaledSize(20),
                                  )
                                : Container(),
                            widget.product!.properties == null ||
                                    widget.product!.properties!.length == 0
                                ? Row(
                                    children: [
                                      Text(
                                        _getFirstQuotaText(),
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(13),
                                          color: CustomTheme.darkGrey,
                                        ),
                                      ),
                                      Text(
                                        widget.bookingScreenTimeSlotItemModel!
                                                        .remainingQuota -
                                                    orderProduct!.amount! >
                                                10
                                            ? 10.toString()
                                            : widget.bookingScreenTimeSlotItemModel!
                                                            .remainingQuota -
                                                        orderProduct!.amount! >=
                                                    0
                                                ? (widget.bookingScreenTimeSlotItemModel!
                                                            .remainingQuota -
                                                        orderProduct!.amount!)
                                                    .toString()
                                                : 0.toString(),
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(13),
                                          fontWeight: FontWeight.bold,
                                          color: CustomTheme.darkGrey,
                                        ),
                                      ),
                                      Text(
                                        _getSecondQuotaText(),
                                        style: TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(13),
                                          color: CustomTheme.darkGrey,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            widget.product!.properties == null ||
                                    widget.product!.properties!.length == 0
                                ? SizedBox(
                                    height: Dimensions.getScaledSize(30.0),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      _getAdditionalServicesWidget(),
                      SizedBox(
                        height: Dimensions.getScaledSize(50.0),
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
                                    Navigator.of(context).pop();
                                    widget.onPreviousBookingStep!();
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
                    bookingDetails: widget.bookingDetails!,
                    orderProducts: [orderProduct!],
                    onTap: () {
                      if (!_checkproperties()) {
                        Fluttertoast.showToast(
                          msg: AppLocalizations.of(context)
                              .bookingScreen_formInvalid,
                          backgroundColor: CustomTheme.primaryColorDark,
                          gravity: ToastGravity.CENTER,
                        );
                        return;
                      }
                      Navigator.of(context).pop();
                      widget.onAddOrderProduct!(orderProduct, widget.index);
                    },
                    buttonText:
                        AppLocalizations.of(context)!.bookingScreen_finish,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () {
        return Future.sync(
          () {
            Navigator.of(context).pop();
            widget.onPreviousBookingStep!();
            return true;
          },
        );
      },
    );
  }

  List<Widget> _getProductProperties() {
    List<Widget> widgets = [];

    widgets.add(
      SizedBox(
        height: Dimensions.getScaledSize(10.0),
      ),
    );

    widget.product!.properties!.forEach((productProperty) {
      if (productProperty.type == ProductPropertyType.DROPDOWN) {
        widgets.add(
          _getDropDownPropertyWidget(productProperty),
        );
      } else if (productProperty.type == ProductPropertyType.NUMBER) {
        widgets.add(
          _getNumberPropertyWidget(productProperty),
        );
      } else if (productProperty.type == ProductPropertyType.TEXT) {
        widgets.add(
          _getTextPropertyWidget(productProperty),
        );
      }

      widgets.add(
        SizedBox(
          height: Dimensions.getScaledSize(20.0),
        ),
      );
    });

    return widgets;
  }

  String? _getProductPropertyTitle(ProductProperty productProperty) {
    return productProperty.isRequired!
        ? '* ' + productProperty.title!
        : productProperty.title;
  }

  Widget _getDropDownPropertyWidget(ProductProperty productProperty) {
    return Row(
      children: [
        Flexible(
          child: Text(
            _getProductPropertyTitle(productProperty)!,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(15.0),
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColorDark,
            ),
          ),
        ),
        SizedBox(
          width: Dimensions.getScaledSize(10.0),
        ),
        Container(
          height: Dimensions.getScaledSize(36.0),
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(12.0),
            right: Dimensions.getScaledSize(12.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Dimensions.getScaledSize(12.0),
            ),
            border: Border.all(
              width: Dimensions.getScaledSize(1),
              color: CustomTheme.mediumGrey,
            ),
          ),
          child: DropdownButton(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            underline: Container(),
            hint: Text(
              AppLocalizations.of(context)!.bookingScreen_choose,
              style: TextStyle(
                fontSize: Dimensions.getScaledSize(14.0),
                color: CustomTheme.primaryColorDark,
              ),
            ),
            items: productProperty.dropdownValues!
                .map(
                  (dropdownValue) => DropdownMenuItem(
                    child: Text(
                      dropdownValue.text!,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(16.0),
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                    value: dropdownValue.value,
                  ),
                )
                .toList(),
            value: _getCurrentValueForProductProperty(productProperty.id!),
            onChanged: (String? value) {
              setState(() {
                _updateProductProperty(productProperty.id!, value!);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _getNumberPropertyWidget(ProductProperty productProperty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getProductPropertyTitle(productProperty)!,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(15.0),
            fontWeight: FontWeight.bold,
            color: CustomTheme.primaryColorDark,
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(10.0),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: Dimensions.getScaledSize(36.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: Dimensions.getScaledSize(1),
                  color: CustomTheme.mediumGrey),
            ),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            maxLines: 1,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            controller: _propertyTextEditingControllers[productProperty.id],
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(16.0),
              color: CustomTheme.primaryColorDark,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.bookingScreen_enterData,
              hintStyle: TextStyle(
                fontSize: Dimensions.getScaledSize(14),
                color: CustomTheme.mediumGrey,
              ),
              border: InputBorder.none,
            ),
            cursorColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              setState(() {
                _updateProductProperty(productProperty.id!, value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _getTextPropertyWidget(ProductProperty productProperty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getProductPropertyTitle(productProperty)!,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(15.0),
            fontWeight: FontWeight.bold,
            color: CustomTheme.primaryColorDark,
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(10.0),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: Dimensions.getScaledSize(36.0),
          child: TextField(
            maxLines: 1,
            controller: _propertyTextEditingControllers[productProperty.id],
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(16.0),
              color: CustomTheme.primaryColorDark,
            ),
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.bookingScreen_enterData,
              hintStyle: TextStyle(
                fontSize: Dimensions.getScaledSize(12),
                color: CustomTheme.mediumGrey,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: Dimensions.getScaledSize(1),
                  color: CustomTheme.mediumGrey,
                ),
              ),
            ),
            onChanged: (value) {
              _updateProductProperty(productProperty.id!, value);
            },
          ),
        ),
      ],
    );
  }

  String? _getCurrentValueForProductProperty(String id) {
    final productProperty = orderProduct!.properties!.firstWhere(
      (element) => element.id == id,
      // orElse: () => null,
    );

    if (productProperty == null) return null;

    return productProperty.value;
  }

  void _updateProductProperty(String id, String value) {
    final productProperty = orderProduct!.properties!.firstWhere(
      (element) => element.id == id,
      // orElse: () => null,
    );

    setState(() {
      if (productProperty == null) {
        orderProduct!.properties!.add(
          OrderProductProperty(
            id: id,
            value: value,
          ),
        );
        return;
      }

      productProperty.value = value;
    });
  }

  Widget _getAdditionalServicesWidget() {
    return widget.product!.additionalServices != null &&
            widget.product!.additionalServices!.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!
                            .bookingScreen_additionallService,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(15.0),
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.primaryColorDark,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: Dimensions.getScaledSize(10),
                    // ),
                    // SimpleTooltip(
                    //   animationDuration: Duration(milliseconds: 10),
                    //   show: _showToolTip,
                    //   tooltipDirection: TooltipDirection.up,
                    //   borderWidth: 0,
                    //   ballonPadding: EdgeInsets.all(
                    //     Dimensions.getScaledSize(10.0),
                    //   ),
                    //   customShadows: [],
                    //   backgroundColor: CustomTheme.accentColor3,
                    //   tooltipTap: () {
                    //     setState(() {
                    //       _showToolTip = !_showToolTip;
                    //     });
                    //   },
                    //   content: Container(
                    //     width: MediaQuery.of(context).size.width * 0.5,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: CustomTheme.accentColor3,
                    //     ),
                    //     child: Text(
                    //       widget.product.additionalServicesDescription,
                    //       style: TextStyle(
                    //         fontSize: Dimensions.getScaledSize(11.0),
                    //         color: CustomTheme.darkGrey,
                    //         fontWeight: FontWeight.bold,
                    //         decoration: TextDecoration.none,
                    //       ),
                    //     ),
                    //   ),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         _showToolTip = !_showToolTip;
                    //       });
                    //     },
                    //     child: Icon(
                    //       Icons.info_outlined,
                    //       size: Dimensions.getScaledSize(24.0),
                    //       color: _showToolTip
                    //           ? CustomTheme.accentColor3
                    //           : CustomTheme.darkGrey.withOpacity(0.5),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                height: Dimensions.getScaledSize(220.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    bottom: Dimensions.getScaledSize(10.0),
                    left: Dimensions.getScaledSize(16.0),
                    right: Dimensions.getScaledSize(16.0),
                  ),
                  children: [
                    ..._getAdditionalServiceItems(),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  List<Widget> _getAdditionalServiceItems() {
    return widget.product!.additionalServices!
        .map(
          (additionalService) => Container(
            padding: EdgeInsets.all(Dimensions.getScaledSize(10.0)),
            width: Dimensions.getScaledSize(150.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  _navigateToSelectAdditionalServicesView(additionalService),
                );
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: Dimensions.getScaledSize(120.0),
                        width: Dimensions.getScaledSize(130.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimensions.getScaledSize(12.0),
                          ),
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              blurRadius: Dimensions.getScaledSize(6.0),
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              Dimensions.getScaledSize(16.0)),
                          child: loadCachedNetworkImage(
                            additionalService.image!.publicUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      orderProduct!.additionalServices!.any(
                              (element) => element.id == additionalService.id)
                          ? Container(
                              height: Dimensions.getScaledSize(120.0),
                              width: Dimensions.getScaledSize(130.0),
                              color: Colors.white.withOpacity(0.5),
                            )
                          : Container(),
                      orderProduct!.additionalServices!.any(
                              (element) => element.id == additionalService.id)
                          ? Positioned(
                              top: Dimensions.getScaledSize(6.0),
                              right: Dimensions.getScaledSize(6.0),
                              child: GestureDetector(
                                onTap: () {
                                  _removeAdditionalService(
                                      additionalService.id!);
                                },
                                child: Container(
                                  height: Dimensions.getScaledSize(32.0),
                                  width: Dimensions.getScaledSize(32.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.getScaledSize(60.0)),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.delete_outlined,
                                    color: CustomTheme.accentColor1,
                                    size: Dimensions.getScaledSize(24.0),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.getScaledSize(15.0),
                  ),
                  Text(
                    additionalService.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(12.0),
                      color: CustomTheme.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Route _navigateToSelectAdditionalServicesView(
      ProductAdditionalService productAdditionalService) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BookingScreenSelectAdditionalServicesView(
        additionalService: productAdditionalService,
        onAddAdditionalService: _addAdditionalService,
        bookingDetails: widget.bookingDetails!,
        orderProduct: orderProduct!,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _addAdditionalService(OrderProductAdditionalService additionalService) {
    final index = orderProduct!.additionalServices!.indexWhere(
      (element) => element.id == additionalService.id,
    );
    setState(() {
      if (index == -1) {
        orderProduct!.additionalServices!.add(additionalService);
      } else {
        orderProduct!.additionalServices![index] = additionalService;
      }
    });
  }

  void _removeAdditionalService(String additionalServiceId) {
    setState(() {
      orderProduct!.additionalServices!
          .removeWhere((element) => element.id == additionalServiceId);
    });
  }

  String _getFirstQuotaText() {
    if (widget.bookingScreenTimeSlotItemModel!.remainingQuota -
            orderProduct!.amount! >
        10) {
      return AppLocalizations.of(context)!.bookingScreen_moreThan;
    } else {
      return AppLocalizations.of(context)!.bookingScreen_more;
    }
  }

  String _getSecondQuotaText() {
    if (widget.bookingScreenTimeSlotItemModel!.remainingQuota -
            orderProduct!.amount! >
        10) {
      return AppLocalizations.of(context)!.bookingScreen_available;
    } else if (widget.bookingScreenTimeSlotItemModel!.remainingQuota -
            orderProduct!.amount! ==
        1) {
      return AppLocalizations.of(context)!.bookingScreen_ticketAvailable;
    } else {
      return AppLocalizations.of(context)!.bookingScreen_ticketsAvailablePlural;
    }
  }
}
