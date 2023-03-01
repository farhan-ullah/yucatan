import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingBar extends StatefulWidget {
  final ActivityBookingDetails bookingDetails;
  final List<OrderProduct> orderProducts;
  final Function onTap;
  final String buttonText;
  final bool showDivider;


  BookingBar({
    required this.bookingDetails,
    required this.orderProducts,
    required this.onTap,
    required this.buttonText,
    this.showDivider = false,
  });

  @override
  _BookingBarState createState() => _BookingBarState();
}
late Product productToReturn;
class _BookingBarState extends State<BookingBar> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.showDivider
            ? ColoredDivider(
                height: Dimensions.getScaledSize(3.0),
              )
            : Container(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: Dimensions.getScaledSize(60.0) +
              MediaQuery.of(context).padding.bottom,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          color: CustomTheme.primaryColorDark,
          child: Padding(
            padding: EdgeInsets.only(
              left: Dimensions.getScaledSize(20.0),
              right: Dimensions.getScaledSize(20.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.bookingScreen_total,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(15.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatPriceDouble(_getTotal()),
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(21.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "€",
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      widget.onTap();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: Dimensions.getScaledSize(12.0),
                        bottom: Dimensions.getScaledSize(12.0),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomTheme.borderRadius,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: Dimensions.getScaledSize(2.0),
                          ),
                          child: Text(
                            widget.buttonText,
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(20),
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColorDark,
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
      ],
    );
  }

  double _getTotal() {
    double total = 0.0;

    widget.orderProducts.forEach((element) {
      total += _calculatePriceForOrderProduct(element);
    });

    return total;
  }

  Product _findProduct(String productId) {


    widget.bookingDetails.productCategories!.forEach(
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
}
