import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Not longer in use, kept for possible reuse

class TotalCostCard extends StatefulWidget {
  final Map<ActivityPersonGroup, int>? persons;
  // final ActivityBookingTicket ticketVariant;
  // final List<ActivityBookingTicketUpsell> upsells;
  final Function? callback;

  TotalCostCard({
    this.persons,
    // this.ticketVariant,
    // this.upsells,
    this.callback,
  });

  @override
  _TotalCostCardState createState() => _TotalCostCardState();
}

class _TotalCostCardState extends State<TotalCostCard> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      bottom: Dimensions.getScaledSize(50.0),
      child: Center(
        child: Container(
          height: Dimensions.getScaledSize(120.0),
          width: Dimensions.getScaledSize(280.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(CustomTheme.borderRadius),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: CustomTheme.grey,
                offset: Offset(4, 4),
                blurRadius: Dimensions.getScaledSize(16.0),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context).primaryColor,
                    size: Dimensions.getScaledSize(46.0),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.bookingScreen_total}: ${_getTotal()}€',
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(16.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.callback!.call();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.bookingScreen_checkout,
                        style: TextStyle(
                          fontSize: Dimensions.getScaledSize(16.0),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getTotal() {
    // var ticketVariantTotal = 0.0;
    // var upsellsTotal = 0.0;

    // widget.persons?.forEach((key, value) {
    //   ticketVariantTotal += (widget.ticketVariant.prices
    //               .firstWhere((element) => element.group == key.name)
    //               .price
    //               .decimalValue *
    //           value)
    //       .toDouble();

    //   widget.upsells?.forEach((upsell) {
    //     upsellsTotal += (upsell.prices
    //                 .firstWhere((element) => element.group == key.name)
    //                 .price
    //                 .decimalValue *
    //             value)
    //         .toDouble();
    //   });
    // });

    // return ticketVariantTotal + upsellsTotal;
    return 0;
  }
}
