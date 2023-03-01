import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/screens/authentication/login/login_screen.dart';
import 'package:yucatan/screens/booking/components/booking_bar.dart';
import 'package:yucatan/screens/booking/components/booking_delete_dialog.dart';
import 'package:yucatan/screens/booking/components/booking_screen_add_button.dart';
import 'package:yucatan/screens/booking/components/booking_screen_card.dart';
import 'package:yucatan/screens/booking/components/booking_screen_select_properties_view.dart';
import 'package:yucatan/screens/booking/components/booking_screen_selected_date.dart';
import 'package:yucatan/screens/booking/components/booking_screen_time_selection.dart';
import 'package:yucatan/screens/booking/components/booking_screen_time_slot_item_model.dart';
import 'package:yucatan/screens/checkout_screen/checkout_screen.dart';
import 'package:yucatan/screens/checkout_screen/components/checkout_screen_parameter.dart';
import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'discard_dialog.dart';

class BookingScreenView extends StatefulWidget {
  final ActivityModel? activity;

  BookingScreenView({
    this.activity,
  });

  @override
  State<StatefulWidget> createState() => _BookingScreenViewState();
}

class _BookingScreenViewState extends State<BookingScreenView> {
  DateTime? _selectedDate;
  BookingStep? _bookingStep;
  ProductCategory? _selectedProductCategory;
  ProductSubCategory? _selectedProductSubCategory;
  Product? _selectedProduct;
  BookingScreenTimeSlotItemModel? _selectedBookingScreenTimeSlotItemModel;
  List<OrderProduct> orderProducts = [];
  List<BookingScreenTimeSlotItemModel> _availableTimeSlots = [];

  ItemScrollController? _categoriesSliderController;
  late Product productToReturn;
  late ProductCategory productCategory;
  late ProductSubCategory productSubCategory;

  @override
  void initState() {
    _selectedProductCategory =
        widget.activity!.bookingDetails!.productCategories![0];

    _bookingStep = BookingStep.SelectSubCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: (Dimensions.getScaledSize(65.0)),
            ),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bookingStep == BookingStep.SelectTime
                        ? Container()
                        : SizedBox(
                            height: Dimensions.getScaledSize(20.0),
                          ),
                    _bookingStep == BookingStep.SelectTime
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(
                              left: Dimensions.getScaledSize(24.0),
                              right: Dimensions.getScaledSize(24.0),
                            ),
                            child: Text(
                              widget.activity!.title!,
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(18.0),
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.primaryColorDark,
                              ),
                            ),
                          ),
                    _bookingStep == BookingStep.ShowItems
                        ? SizedBox(
                            height: Dimensions.getScaledSize(10.0),
                          )
                        : Container(),
                    _bookingStep == BookingStep.ShowItems
                        ? BookingScreenSelectedDate(
                            date: _selectedDate,
                          )
                        : Container(),
                    _bookingStep == BookingStep.SelectTime
                        ? Container()
                        : SizedBox(
                            height: Dimensions.getScaledSize(10.0),
                          ),
                    _bookingStep == BookingStep.ShowItems
                        ? _getShowItemsUi()
                        : Container(),
                    _bookingStep == BookingStep.SelectSubCategory
                        ? _getSelectProductSubCategoryUi()
                        : Container(),
                    _bookingStep == BookingStep.SelectProduct
                        ? _getSelectProductUi()
                        : Container(),
                    _bookingStep == BookingStep.SelectTime
                        ? BookingScreenTimeSelection(
                            product: _selectedProduct!,
                            onTimeSlotSelected: _onTimeSlotSelected,
                            category: _selectedProductCategory!,
                            subCategory: _selectedProductSubCategory!,
                            specificDate: _selectedDate,
                            onAvailableTimeSlotsChanged:
                                _handleOnAvailableTimeSlotsChanged,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
          _bookingStep == BookingStep.ShowItems
              ? BookingScreenAddButton(
                  nextBookingStep: _nextBookingStep,
                )
              : Container(),
          Positioned(
            bottom: 0,
            child: BookingBar(
              bookingDetails: widget.activity!.bookingDetails!,
              orderProducts: orderProducts,
              onTap: () {
                _handleContinueButton();
              },
              buttonText: orderProducts.isNotEmpty
                  ? AppLocalizations.of(context)!.bookingScreen_pay
                  : AppLocalizations.of(context)!.bookingScreen_further,
              showDivider: true,
            ),
          ),
          /*BookingScreenDiscardPopup(
            showDiscardContainer: _showDiscardContainer,
            onCancel: () {
              setState(() {
                _showDiscardContainer = false;
              });
            },
          ),*/
        ],
      ),
      onWillPop: () {
        return Future.sync(() {
          if (_bookingStep == BookingStep.SelectSubCategory &&
              orderProducts.isEmpty) {
            return true;
          } else if (_bookingStep == BookingStep.SelectSubCategory ||
              _bookingStep == BookingStep.SelectProduct ||
              _bookingStep == BookingStep.SelectTime) {
            _previousBookingStep();
            return false;
          } else if (orderProducts.isNotEmpty) {
            showDialog(
                context: context,
                builder: (context) => DiscardDialog(
                      () {
                        Navigator.of(context).pop();
                      },
                      () {},
                      false,
                    ));
            /* setState(() {
              _showDiscardContainer = true;
            });*/
            return false;
          } else
            return true;
        });
      },
    );
  }

  void _nextBookingStep({BookingStep? nextBookingStep}) {
    print('Data Showed Farhan : $nextBookingStep');
    setState(() {
      if (nextBookingStep != null) {
        _bookingStep = nextBookingStep;
        if (nextBookingStep == BookingStep.SelectProperties) {
          Navigator.of(context).push(_navigateToSelectPropertiesView());
        }
      } else if (_bookingStep == BookingStep.ShowItems) {
        if (_selectedProductCategory!.productSubCategories == null ||
            _selectedProductCategory!.productSubCategories!.isEmpty)
          _bookingStep = BookingStep.SelectProduct;
        else
          _bookingStep = BookingStep.SelectSubCategory;
      } else if (_bookingStep == BookingStep.SelectSubCategory) {
        _bookingStep = BookingStep.SelectProduct;
      } else if (_bookingStep == BookingStep.SelectProduct) {
        _bookingStep = BookingStep.SelectTime;
      } else if (_bookingStep == BookingStep.SelectTime) {
        _bookingStep = BookingStep.SelectProperties;
        Navigator.of(context).push(_navigateToSelectPropertiesView());
      } else if (_bookingStep == BookingStep.SelectProperties) {
        _bookingStep = BookingStep.ShowItems;
      }
    });
  }

  Future<bool> _previousBookingStep() {
    return Future<bool>.sync(() {
      if (_bookingStep == BookingStep.ShowItems) {
        return true;
      }
      setState(() {
        if (_bookingStep == BookingStep.SelectSubCategory) {
          _bookingStep = BookingStep.ShowItems;
          _selectedProductCategory =
              widget.activity!.bookingDetails!.productCategories![0];
        } else if (_bookingStep == BookingStep.SelectProduct) {
          if (_selectedProductSubCategory != null) {
            _selectedProductSubCategory = null;
            _bookingStep = BookingStep.SelectSubCategory;
          } else {
            _bookingStep = BookingStep.ShowItems;
          }
        } else if (_bookingStep == BookingStep.SelectTime) {
          if (_selectedProductSubCategory != null) {
            _bookingStep = BookingStep.SelectProduct;
          } else {
            _bookingStep = BookingStep.SelectSubCategory;
          }
          _selectedProduct = null;
        } else if (_bookingStep == BookingStep.SelectProperties) {
          _bookingStep = BookingStep.SelectTime;
        }
      });
      return false;
    });
  }

  Widget _getShowItemsUi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimensions.getScaledSize(5.0),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(24.0),
            right: Dimensions.getScaledSize(24.0),
          ),
          child: Text(
            AppLocalizations.of(context)!.bookingScreen_yourChoice,
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(16.0),
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColorDark,
            ),
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
          child: orderProducts.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.61 -
                      MediaQuery.of(context).padding.bottom,
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.getScaledSize(
                        50,
                      ),
                    ),
                    children: [
                      ..._getOrderProductItems(),
                    ],
                  ),
                )
              : Text(
                  AppLocalizations.of(context)
                      .bookingScreen_noProductsSelectedError,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(16.0),
                    color: CustomTheme.disabledColor,
                  ),
                ),
        ),
        orderProducts.isNotEmpty
            ? Container()
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('lib/assets/images/booking_empty.png'),
              ),
      ],
    );
  }

  List<Widget> _getOrderProductItems() {
    return orderProducts.map(
      (orderProduct) {
        final product = _findProduct(orderProduct.id!);

        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            top: Dimensions.getScaledSize(10.0),
            bottom: Dimensions.getScaledSize(10.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                Dimensions.getScaledSize(10.0),
              ),
              topRight: Radius.circular(
                Dimensions.getScaledSize(10.0),
              ),
            ),
            border: Border.all(
              color: CustomTheme.mediumGrey,
            ),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(
                  Dimensions.getScaledSize(12.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _editOrderProduct(
                          orderProduct,
                          orderProducts.indexOf(orderProduct),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        size: Dimensions.getScaledSize(24.0),
                        color: CustomTheme.darkGrey.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.getScaledSize(12.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width -
                              Dimensions.getScaledSize(144.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${_getCategoryForProduct(product) != null ? '${_getCategoryForProduct(product).title!},' : ''} ${_getProductSubCategoryForProduct(product) != null ? '${_getProductSubCategoryForProduct(product).title!}, ' : ''}${product.title}',
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
                                width: Dimensions.getScaledSize(24.0),
                              ),
                            ],
                          ),
                        ),
                        orderProduct.bookingScreenTimeSlotItemModel!
                                    .timeString !=
                                null
                            ? SizedBox(
                                height: Dimensions.getScaledSize(5.0),
                              )
                            : Container(),
                        orderProduct.bookingScreenTimeSlotItemModel!
                                    .timeString !=
                                null
                            ? Text(
                                "${orderProduct.bookingScreenTimeSlotItemModel!.timeString} Uhr",
                                style: TextStyle(
                                  fontSize: Dimensions.getScaledSize(14),
                                  color: CustomTheme.primaryColorDark,
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: Dimensions.getScaledSize(5.0),
                        ),
                        ...orderProduct.properties!.map((orderProperty) {
                          if (orderProperty.value == null ||
                              orderProperty.value == "") {
                            return Container();
                          }

                          final property = product.properties!.firstWhere(
                            (element) => element.id == orderProperty.id,
                          );

                          return Padding(
                            padding: EdgeInsets.only(
                              top: Dimensions.getScaledSize(5.0),
                              bottom: Dimensions.getScaledSize(5.0),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${property.title}:',
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(14.0),
                                    color: CustomTheme.primaryColorDark,
                                  ),
                                ),
                                SizedBox(
                                  width: Dimensions.getScaledSize(5.0),
                                ),
                                Text(
                                  property.type == ProductPropertyType.DROPDOWN
                                      ? property.dropdownValues!
                                          .firstWhere((element) =>
                                              element.value ==
                                              orderProperty.value)
                                          .text!
                                      : orderProperty.value!,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(14.0),
                                    color: CustomTheme.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        orderProduct.additionalServices != null &&
                                orderProduct.additionalServices!.isNotEmpty
                            ? orderProduct.additionalServices!.firstWhere(
                                      (element) => element.amount! > 0,
                                      // orElse: () => null
                                    ) !=
                                    null
                                ? Text(
                                    AppLocalizations.of(context)!
                                        .bookingScreen_additionallService,
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(14.0),
                                      color: CustomTheme.primaryColorDark,
                                    ),
                                  )
                                : Container()
                            : Container(),
                        ...orderProduct.additionalServices!
                            .map((additionalService) {
                          if (additionalService.amount! <= 0) {
                            return Container();
                          }

                          final additionalServiceProperty =
                              product.additionalServices!.firstWhere(
                            (element) => element.id == additionalService.id,
                            // orElse: () => null
                          );

                          if (additionalServiceProperty == null) {
                            return Container();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${additionalService.amount}x ${additionalServiceProperty.title}",
                                style: TextStyle(
                                  fontSize: Dimensions.getScaledSize(14.0),
                                  color: CustomTheme.primaryColorDark,
                                ),
                              ),
                              ...additionalServiceProperty.properties!
                                  .map((property) {
                                final selectedAdditionalServiceProperty =
                                    additionalService.properties!.firstWhere(
                                  (element) => element.id == property.id,
                                  // orElse: () => null
                                );

                                if (selectedAdditionalServiceProperty == null) {
                                  return Container();
                                }

                                return Row(
                                  children: [
                                    Text(
                                      '${property.title}:',
                                      style: TextStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(14.0),
                                        color: CustomTheme.primaryColorDark,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimensions.getScaledSize(5.0),
                                    ),
                                    Text(
                                      property.type ==
                                              ProductPropertyType.DROPDOWN
                                          ? property.dropdownValues!
                                              .firstWhere((element) =>
                                                  element.value ==
                                                  selectedAdditionalServiceProperty
                                                      .value)
                                              .text!
                                          : selectedAdditionalServiceProperty
                                              .value!,
                                      style: TextStyle(
                                        fontSize:
                                            Dimensions.getScaledSize(14.0),
                                        color: CustomTheme.primaryColorDark,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              SizedBox(
                                height: Dimensions.getScaledSize(5.0),
                              ),
                            ],
                          );
                        }).toList(),
                        SizedBox(
                          height: Dimensions.getScaledSize(15.0),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              Dimensions.getScaledSize(120.0),
                          child: Row(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Container(
                                height: Dimensions.getScaledSize(30.0),
                                width: Dimensions.getScaledSize(90.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (orderProduct.amount! > 1) {
                                              orderProduct.amount! - 1;
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  Dimensions.getScaledSize(
                                                      5.0)),
                                              bottomLeft: Radius.circular(
                                                  Dimensions.getScaledSize(
                                                      5.0)),
                                            ),
                                            border: Border.all(
                                              color: CustomTheme.mediumGrey,
                                            ),
                                            color: CustomTheme.lightGrey,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.remove,
                                              color: product.properties!.isEmpty
                                                  ? orderProduct.amount! > 1
                                                      ? CustomTheme.darkGrey
                                                      : CustomTheme.mediumGrey
                                                  : CustomTheme.mediumGrey,
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
                                            color: CustomTheme.mediumGrey,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: Dimensions.getScaledSize(2),
                                            ),
                                            child: Text(
                                              orderProduct.amount.toString(),
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.getScaledSize(
                                                        16.0),
                                                fontWeight: FontWeight.bold,
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
                                          if (product.properties!.isEmpty) {
                                            setState(() {
                                              if (orderProduct
                                                          .bookingScreenTimeSlotItemModel!
                                                          .remainingQuota -
                                                      orderProduct.amount! >
                                                  0) {
                                                orderProduct.amount! + 1;
                                              }
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  Dimensions.getScaledSize(
                                                      5.0)),
                                              bottomRight: Radius.circular(
                                                  Dimensions.getScaledSize(
                                                      5.0)),
                                            ),
                                            border: Border.all(
                                              color: CustomTheme.mediumGrey,
                                            ),
                                            color: CustomTheme.lightGrey,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: product.properties!.isEmpty
                                                  ? orderProduct.bookingScreenTimeSlotItemModel!
                                                                  .remainingQuota -
                                                              orderProduct
                                                                  .amount! >
                                                          0
                                                      ? CustomTheme.darkGrey
                                                      : CustomTheme.mediumGrey
                                                  : CustomTheme.mediumGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: [
                                  Text(
                                    '${formatPriceDouble(_calculatePriceForOrderProduct(orderProduct))}',
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(16.0),
                                      fontWeight: FontWeight.bold,
                                      color: CustomTheme.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    '€',
                                    style: TextStyle(
                                      fontSize: Dimensions.getScaledSize(14.0),
                                      fontWeight: FontWeight.bold,
                                      color: CustomTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BookingDeleteDialog(
                          delete: () => _removeOrderProduct(orderProduct),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: Dimensions.getScaledSize(30.0),
                    width: Dimensions.getScaledSize(30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight:
                            Radius.circular(Dimensions.getScaledSize(5.0)),
                      ),
                      color: CustomTheme.darkGrey.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.delete_outlined,
                        size: Dimensions.getScaledSize(24.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: Dimensions.getScaledSize(3.0),
                  width: MediaQuery.of(context).size.width,
                  color: CustomTheme.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    ).toList();
  }

  Widget _getSelectProductSubCategoryUi() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          _getCategoriesSlider(),
          SizedBox(
            height: Dimensions.getScaledSize(10.0),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.61 -
                MediaQuery.of(context).padding.bottom,
            child: ListView(
              children: [
                ..._getProductSubCategories(),
                if (_selectedProductCategory!.products != null &&
                    _selectedProductCategory!.products!.isNotEmpty)
                  ..._selectedProductCategory!.products!
                      .map(
                        (product) => Container(
                          key: UniqueKey(),
                          child: BookingScreenCard(
                            title: product.title,
                            description: product.subtitle,
                            price: product.price,
                            imageUrl: product.image?.publicUrl,
                            callback: () {
                              setState(() {
                                _selectedProduct = product;
                                _nextBookingStep(
                                    nextBookingStep: BookingStep.SelectTime);
                              });

                              _sendFirebaseEventProductSelected();
                            },
                            isProduct: true,
                            product: product,
                            selectedDate: _selectedDate,
                          ),
                        ),
                      )
                      .toList()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectProductUi() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          _getCategoriesSlider(),
          SizedBox(
            height: Dimensions.getScaledSize(15.0),
          ),
          _selectedProductSubCategory != null
              ? _getSubCategoryItem()
              : Container(),
          SizedBox(
            height: Dimensions.getScaledSize(10.0),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.55 -
                MediaQuery.of(context).padding.bottom,
            child: ListView(
              children: [
                ..._getProductsDetailed(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoriesSlider() {
    _categoriesSliderController = ItemScrollController();

    var categoriesSliderItems = _getCategoriesSliderItems();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimensions.getScaledSize(48.0),
      child: ScrollablePositionedList.builder(
          itemScrollController: _categoriesSliderController,
          itemCount: categoriesSliderItems.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return categoriesSliderItems[index];
          }),
    );
  }

  List<Widget> _getCategoriesSliderItems() {
    List<Widget> widgets = [];

    widget.activity!.bookingDetails!.productCategories!.forEach(
      (category) {
        widgets.add(
          GestureDetector(
            onTap: () {
              _categoriesSliderController.scrollTo(
                index: widget.activity!.bookingDetails!.productCategories!
                    .indexOf(category),
                duration: Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
              );

              setState(() {
                if (_bookingStep == BookingStep.SelectProduct) {
                  _previousBookingStep();
                }

                _selectedProductCategory = category;
                _selectedProductSubCategory = null;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                left: Dimensions.getScaledSize(24),
                right: (widget.activity!.bookingDetails!.productCategories!
                                .length -
                            1) ==
                        widget.activity!.bookingDetails!.productCategories!
                            .indexOf(category)
                    ? Dimensions.getScaledSize(24)
                    : 0,
              ),
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.getScaledSize(13),
                horizontal: Dimensions.getScaledSize(13),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: CustomTheme.mediumGrey,
                ),
                borderRadius: BorderRadius.circular(
                  Dimensions.getScaledSize(8),
                ),
                color: _selectedProductCategory!.id == category.id
                    ? CustomTheme.primaryColorDark
                    : Colors.white,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  category.title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(16.0),
                    color: _selectedProductCategory!.id! == category.id
                        ? Colors.white
                        : CustomTheme.primaryColorDark,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return widgets;
  }

  List<Widget> _getProductSubCategories() {
    if (_selectedProductCategory!.productSubCategories != null &&
        _selectedProductCategory!.productSubCategories!.isNotEmpty) {
      return _selectedProductCategory!.productSubCategories!
          .map(
            (productSubCategory) => BookingScreenCard(
              title: productSubCategory.title,
              description: '',
              price: productSubCategory.priceFrom,
              imageUrl: productSubCategory.image?.publicUrl,
              callback: () {
                setState(() {
                  _selectedProductSubCategory = productSubCategory;
                  _nextBookingStep();
                });
              },
              isProduct: false,
              product: null,
              selectedDate: _selectedDate,
            ),
          )
          .toList();
    } else {
      return [];
    }
  }

  /*List<Widget> _getProducts() {
    if (_selectedProductCategory.products != null &&
        _selectedProductCategory.products.length > 0) {
      return _selectedProductCategory.products
          .map(
            (product) => BookingScreenCard(
              title: product.title,
              description: product.subtitle,
              price: product.price,
              imageUrl: product.image?.publicUrl,
              callback: () {
                setState(() {
                  _selectedProduct = product;
                  _nextBookingStep(nextBookingStep: BookingStep.SelectTime);
                });

                _sendFirebaseEventProductSelected();
              },
              isProduct: true,
              product: product,
              selectedDate: _selectedDate,
            ),
          )
          .toList();
    } else {
      return [];
    }
  }*/

  Widget _getSubCategoryItem() {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.getScaledSize(24.0),
        right: Dimensions.getScaledSize(24.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.getScaledSize(13),
          horizontal: Dimensions.getScaledSize(13),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Dimensions.getScaledSize(8.0),
          ),
          color: CustomTheme.primaryColorDark,
        ),
        child: Text(
          _selectedProductSubCategory!.title!,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(16.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  List<Widget> _getProductsDetailed() {
    if (_selectedProductSubCategory != null &&
        _selectedProductSubCategory!.products != null &&
        _selectedProductSubCategory!.products!.isNotEmpty) {
      return _selectedProductSubCategory!.products!
          .map(
            (product) => BookingScreenCard(
              title: product.title,
              description: product.subtitle,
              price: product.price,
              imageUrl: product.image?.publicUrl,
              callback: () {
                setState(() {
                  _selectedProduct = product;
                  _nextBookingStep();
                });

                _sendFirebaseEventProductSelected();
              },
              isProduct: true,
              product: product,
              selectedDate: _selectedDate,
            ),
          )
          .toList();
    } else {
      return _selectedProductCategory!.products!
          .map(
            (product) => BookingScreenCard(
              title: product.title,
              description: product.subtitle,
              price: product.price,
              imageUrl: product.image?.publicUrl,
              callback: () {
                setState(() {
                  _selectedProduct = product;
                  _nextBookingStep();
                });

                _sendFirebaseEventProductSelected();
              },
              isProduct: true,
              product: product,
              selectedDate: _selectedDate,
            ),
          )
          .toList();
    }
  }

  Route _navigateToSelectPropertiesView() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BookingScreenSelectPropertiesView(
        product: _selectedProduct,
        bookingScreenTimeSlotItemModel: _selectedBookingScreenTimeSlotItemModel,
        onAddOrderProduct: _addOrderProduct,
        onPreviousBookingStep: _previousBookingStep,
        bookingDetails: widget.activity!.bookingDetails,
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

  Route _navigateToSelectPropertiesViewEdit(
      Product product, OrderProduct orderProduct, int index) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          BookingScreenSelectPropertiesView(
        product: product,
        bookingScreenTimeSlotItemModel:
            orderProduct.bookingScreenTimeSlotItemModel,
        onAddOrderProduct: _addOrderProduct,
        onPreviousBookingStep: _editOrderProductPreviousBookingStep,
        bookingDetails: widget.activity!.bookingDetails,
        existingOrderProduct: orderProduct,
        index: index,
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

  void _onTimeSlotSelected(
      BookingScreenTimeSlotItemModel bookingScreenTimeSlotItemModel) {
    _selectedBookingScreenTimeSlotItemModel = bookingScreenTimeSlotItemModel;

    _nextBookingStep();
  }

  void _addOrderProduct(OrderProduct orderProduct, int index) {
    //Log firebase event

    AnalyticsService.logAddtoCart(orderProduct, _findProduct(orderProduct.id!));

    setState(() {
      if (index == null) {
        orderProducts.add(orderProduct);

        if (orderProducts.length > 1) return;

        var orderProductDate =
            orderProduct.bookingScreenTimeSlotItemModel!.dateTime;

        _selectedDate = DateTime.utc(
          orderProductDate.year,
          orderProductDate.month,
          orderProductDate.day,
        );
      } else {
        orderProducts[index] = orderProduct;
      }
    });

    _nextBookingStep();
  }

  ///Remove element from orderProducts
  void _removeOrderProduct(OrderProduct orderProduct) {
    //Log firebase event
    if (kReleaseMode) {
      FirebaseAnalytics().logEvent(
        name: 'remove_from_cart',
        parameters: <String, dynamic>{
          'item': orderProduct.id,
          'item_name': _findProduct(orderProduct.id!).title,
          'value': _findProduct(orderProduct.id!).price! * orderProduct.amount!,
          'time': DateTime.now().toIso8601String(),
        },
      );
    }

    setState(() {
      orderProducts.remove(orderProduct);
    });

    if (orderProducts.isNotEmpty) return;

    //Reset data
    setState(() {
      _selectedDate = null;
      _bookingStep = null;
      _selectedProductSubCategory = null;
      _selectedProduct = null;
      _selectedBookingScreenTimeSlotItemModel = null;
      _selectedProductCategory =
          widget.activity!.bookingDetails!.productCategories![0];

      //Reset the booking step, so the user needs to select a sub category or product again
      _bookingStep = BookingStep.SelectSubCategory;
    });
  }

  Product _findProduct(String productId) {
    // Product productToReturn;

    widget.activity!.bookingDetails!.productCategories!.forEach(
      (category) {
        category.products!.forEach(
          (product) {
            if (product.id == productId) {
              productToReturn = product;
            }
          },
        );

        category.productSubCategories!.forEach(
          (subCategory) {
            subCategory.products!.forEach(
              (product) {
                if (product.id == productId) {
                  productToReturn = product;
                }
              },
            );
          },
        );
      },
    );

    return productToReturn;
  }

  void _editOrderProduct(OrderProduct orderProduct, int index) {
    _bookingStep = BookingStep.SelectProperties;
    Navigator.of(context).push(
      _navigateToSelectPropertiesViewEdit(
          _findProduct(orderProduct.id!), orderProduct, index),
    );
  }

  void _editOrderProductPreviousBookingStep() {
    setState(() {
      _bookingStep = BookingStep.ShowItems;
    });
  }

  double _calculatePriceForOrderProduct(OrderProduct orderProduct) {
    final product = _findProduct(orderProduct.id!);

    double productTotal = product.price! * orderProduct.amount!;
    double additionalServicesTotal = 0.0;

    orderProduct.additionalServices!.forEach((element) {
      final additionalService = product.additionalServices!.firstWhere(
          (additionalServiceElement) =>
              additionalServiceElement.id == element.id);

      additionalServicesTotal += additionalService.price! * element.amount!;
    });

    return productTotal + additionalServicesTotal;
  }

  void _proceedToCheckoutIfOrderNotEmpty() async {
    if (orderProducts.isEmpty) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.bookingScreen_nothingSelected,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: CustomTheme.theme.primaryColorDark,
        textColor: Colors.white,
      );
    } else {
      // if the user is null, a login or register is required
      UserLoginModel user = await UserProvider.getUser();
      if (user == null) {
        Navigator.of(context).pushNamed(LoginScreen.route);
      } else {
        Navigator.of(context).pushNamed(
          CheckoutScreen.route,
          arguments: CheckoutScreenParameter(
            activity: widget.activity!,
            order: OrderModel(
              activityId: widget.activity!.sId,
              userId: user.sId,
              bookingDate: _selectedDate,
              products: orderProducts,
            ),
          ),
        );
      }
    }
  }

  ProductCategory _getCategoryForProduct(Product product) {
    // ProductCategory productCategory;

    widget.activity!.bookingDetails!.productCategories!.forEach((element) {
      element.products!.forEach((productElement) {
        if (productElement.id == product.id) {
          productCategory = element;
        }
      });
      element.productSubCategories!.forEach((subCategoryElement) {
        subCategoryElement.products!.forEach((productElement) {
          if (productElement.id == product.id) {
            productCategory = element;
          }
        });
      });
    });

    return productCategory;
  }

  ProductSubCategory _getProductSubCategoryForProduct(Product product) {
    // ProductSubCategory productSubCategory;

    widget.activity!.bookingDetails!.productCategories!.forEach((element) {
      element.productSubCategories!.forEach((subCategoryElement) {
        subCategoryElement.products!.forEach((productElement) {
          if (productElement.id == product.id) {
            productSubCategory = subCategoryElement;
          }
        });
      });
    });

    return productSubCategory;
  }

  void _sendFirebaseEventProductSelected() {
    //Log firebase event
    if (kReleaseMode) {
      FirebaseAnalytics().logEvent(
        name: 'select_item',
        parameters: <String, dynamic>{
          'product_id': _selectedProduct!.id,
          'product_name': _selectedProduct!.title,
          'value': _selectedProduct!.price,
          'activity_id': widget.activity!.sId,
          'category_id': _selectedProductCategory!.id,
          'sub_category_id': _selectedProductSubCategory?.id,
          'time': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  void _handleOnAvailableTimeSlotsChanged(
      List<BookingScreenTimeSlotItemModel> bookingScreenTimeSlotItemModels) {
    _availableTimeSlots = bookingScreenTimeSlotItemModels;
  }

  void _handleContinueButton() {
    if (_bookingStep == BookingStep.SelectTime) {
      if (_availableTimeSlots != null &&
          _availableTimeSlots.length == 1 &&
          _availableTimeSlots.first.remainingQuota > 0) {
        _selectedBookingScreenTimeSlotItemModel = _availableTimeSlots.first;
        print(
            'Data Showed 5 Farhan : $_selectedBookingScreenTimeSlotItemModel');
        _nextBookingStep();
      }
      return;
    }

    _proceedToCheckoutIfOrderNotEmpty();
  }

/*List<DateTime> _getClosedDates() {
    List<DateTime> closedDates = [];

    if (widget.activity.openingHours.regularOpeningHours != null) {
      DateTime currentDate = DateTime.now();
      currentDate = DateTime(
          currentDate.year, currentDate.month, currentDate.day, 0, 0, 0);
      DateTime maxDate =
          DateTime(currentDate.year + 2, currentDate.month, currentDate.day);

      while (currentDate.isBefore(maxDate) ||
          currentDate.isAtSameMomentAs(maxDate)) {
        int weekDay = currentDate.weekday == 7
            ? 0
            : currentDate
                .weekday; // Sunday = 0 in our model, monday = 1, saturday = 6

        RegularOpeningHours openingHours =
            widget.activity.openingHours.regularOpeningHours.firstWhere(
          (regularOpeningHoursElement) =>
              regularOpeningHoursElement.dayOfWeek == weekDay,
          orElse: () => null,
        );

        if (openingHours == null) {
          currentDate = currentDate.add(
            Duration(days: 1),
          );
          continue;
        }

        if (openingHours.open == false) {
          closedDates.add(currentDate);
        }

        currentDate = currentDate.add(
          Duration(days: 1),
        );
      }
    }

    if (widget.activity.openingHours.seasonalOpeningHours != null) {
      widget.activity.openingHours.seasonalOpeningHours.forEach((element) {
        element.periods.asMap().forEach((index, seasonalOpeningHoursPeriod) {
          DateTime currentPeriodDate = seasonalOpeningHoursPeriod.startDate;

          while (
              currentPeriodDate.isBefore(seasonalOpeningHoursPeriod.endDate) ||
                  currentPeriodDate
                      .isAtSameMomentAs(seasonalOpeningHoursPeriod.endDate)) {
            int weekDay =
                currentPeriodDate.weekday == 7 ? 0 : currentPeriodDate.weekday;

            OpeningHoursDay openingHoursDay =
                element.openingHourDays.firstWhere(
              (openingHoursDayElement) =>
                  openingHoursDayElement.dayOfWeek == weekDay,
              orElse: () => null,
            );

            if (openingHoursDay == null) {
              currentPeriodDate = currentPeriodDate.add(
                Duration(days: 1),
              );
              continue;
            }

            if (openingHoursDay.open == false) {
              bool closedDateExists = closedDates.any((closedDateElement) =>
                  closedDateElement.year == currentPeriodDate.year &&
                  closedDateElement.month == currentPeriodDate.month &&
                  closedDateElement.day == currentPeriodDate.day);

              if (closedDateExists == false) {
                closedDates.add(currentPeriodDate);
              }
            } else {
              bool closedDateExists = closedDates.any((closedDateElement) =>
                  closedDateElement.year == currentPeriodDate.year &&
                  closedDateElement.month == currentPeriodDate.month &&
                  closedDateElement.day == currentPeriodDate.day);

              if (closedDateExists) {
                closedDates.removeWhere((closedDateElement) =>
                    closedDateElement.year == currentPeriodDate.year &&
                    closedDateElement.month == currentPeriodDate.month &&
                    closedDateElement.day == currentPeriodDate.day);
              }
            }

            currentPeriodDate = currentPeriodDate.add(
              Duration(days: 1),
            );
          }
        });
      });
    }

    if (widget.activity.openingHours.specialOpeningHours != null) {
      widget.activity.openingHours.specialOpeningHours.forEach((element) {
        if (element.open == false) {
          bool closedDateExists = closedDates.any((closedDateElement) =>
              closedDateElement.year == element.date.year &&
              closedDateElement.month == element.date.month &&
              closedDateElement.day == element.date.day);

          if (closedDateExists == false) {
            closedDates.add(element.date);
          }
        } else {
          bool closedDateExists = closedDates.any((closedDateElement) =>
              closedDateElement.year == element.date.year &&
              closedDateElement.month == element.date.month &&
              closedDateElement.day == element.date.day);

          if (closedDateExists) {
            closedDates.removeWhere((closedDateElement) =>
                closedDateElement.year == element.date.year &&
                closedDateElement.month == element.date.month &&
                closedDateElement.day == element.date.day);
          }
        }
      });
    }

    return closedDates;
  }*/
}

enum BookingStep {
  ShowItems,
  SelectSubCategory,
  SelectProduct,
  SelectTime,
  SelectProperties,
}
