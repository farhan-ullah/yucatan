import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/screens/booking/util/booking_time_quota_util.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/networkImage/network_image_loader.dart';
import 'package:yucatan/utils/price_format_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingScreenCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final Function callback;
  final bool isProduct;
  final Product product;
  final DateTime selectedDate;

  BookingScreenCard({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.callback,
    this.isProduct,
    this.product,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.getScaledSize(10.0),
        bottom: Dimensions.getScaledSize(10.0),
        left: Dimensions.getScaledSize(24.0),
        right: Dimensions.getScaledSize(24.0),
      ),
      child: GestureDetector(
        onTap: _isNotAvailableOnSelectedDate() ? () {} : callback,
        child: Container(
          height: Dimensions.getScaledSize(130.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Dimensions.getScaledSize(16.0),
            ),
            color: Colors.white,
            boxShadow: CustomTheme.shadow,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            Dimensions.getScaledSize(16.0),
                          ),
                          bottomLeft: Radius.circular(
                            Dimensions.getScaledSize(16.0),
                          ),
                        ),
                        child: loadCachedNetworkImage(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: Dimensions.getScaledSize(150.0),
                        ),
                      ),
                      _isNotAvailableOnSelectedDate()
                          ? Container(
                              height: Dimensions.getScaledSize(150.0),
                              decoration: BoxDecoration(
                                color: CustomTheme.lightGrey.withOpacity(0.8),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: Dimensions.getScaledSize(130),
                width: Dimensions.getScaledSize(1),
                color: CustomTheme.mediumGrey,
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.all(
                    Dimensions.getScaledSize(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(16.0),
                          fontWeight: FontWeight.bold,
                          color: _isNotAvailableOnSelectedDate()
                              ? CustomTheme.darkGrey.withOpacity(0.5)
                              : CustomTheme.primaryColorDark,
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(5.0),
                      ),
                      isProduct
                          ? Text(
                              description ?? '',
                              style: TextStyle(
                                fontSize: Dimensions.getScaledSize(12.0),
                                color: CustomTheme.darkGrey,
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          isProduct
                              ? Container()
                              : Text(
                                  '${AppLocalizations.of(context)!.commonWords_from} ',
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(11.0),
                                    fontWeight: FontWeight.bold,
                                    color: _isNotAvailableOnSelectedDate()
                                        ? CustomTheme.darkGrey.withOpacity(0.5)
                                        : CustomTheme.primaryColor,
                                  ),
                                ),
                          Text(
                            '${formatPriceDouble(price)}',
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(16.0),
                              fontWeight: FontWeight.bold,
                              color: _isNotAvailableOnSelectedDate()
                                  ? CustomTheme.darkGrey.withOpacity(0.5)
                                  : CustomTheme.primaryColor,
                            ),
                          ),
                          Text(
                            '€',
                            style: TextStyle(
                              fontSize: Dimensions.getScaledSize(14.0),
                              fontWeight: FontWeight.bold,
                              color: _isNotAvailableOnSelectedDate()
                                  ? CustomTheme.darkGrey.withOpacity(0.5)
                                  : CustomTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isNotAvailableOnSelectedDate() {
    return isProduct && selectedDate != null && product != null
        ? BookingTimeQuotaUtil.isProductAvailableOnDate(
            product,
            selectedDate,
          )
            ? false
            : true
        : false;
  }
}
