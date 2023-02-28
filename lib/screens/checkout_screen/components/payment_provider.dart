import 'package:yucatan/screens/payment_credit_card_screen/payment_credit_card_screen.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class PaymentProviderList extends StatefulWidget {
  final Function callback;

  PaymentProviderList({required this.callback});

  @override
  _PaymentProviderListState createState() => _PaymentProviderListState();
}

class _PaymentProviderListState extends State<PaymentProviderList> {
  String _selectedRoute = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.only(
              left: Dimensions.getScaledSize(12.0),
              right: Dimensions.getScaledSize(12.0),
            ),
            height: Dimensions.getScaledSize(50.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: CustomTheme.darkGrey.withOpacity(0.5),
              ),
              borderRadius:
                  BorderRadius.circular(Dimensions.getScaledSize(5.0)),
              color: _selectedRoute == _getPaymentProvider()[0].route
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : Colors.white,
            ),
            child: Image(
              image: AssetImage(_getPaymentProvider()[0].image),
              fit: BoxFit.scaleDown,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedRoute = _getPaymentProvider()[0].route;
            });
            widget.callback(_selectedRoute);
          },
        ),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.only(
              left: Dimensions.getScaledSize(12.0),
              right: Dimensions.getScaledSize(12.0),
            ),
            height: Dimensions.getScaledSize(50.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: CustomTheme.darkGrey.withOpacity(0.5),
              ),
              borderRadius:
                  BorderRadius.circular(Dimensions.getScaledSize(5.0)),
              color: _selectedRoute == _getPaymentProvider()[1].route
                  ? CustomTheme.darkGrey.withOpacity(0.5)
                  : Colors.white,
            ),
            child: Image(
              image: AssetImage(_getPaymentProvider()[1].image),
              fit: BoxFit.scaleDown,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedRoute = _getPaymentProvider()[1].route;
            });
            widget.callback(_selectedRoute);
          },
        ),
      ],
    );
  }

  List<PaymentProvider> _getPaymentProvider() {
    return List<PaymentProvider>.from(
      {
        PaymentProvider(
          image: 'lib/assets/images/creditcardslogo.png',
          route: PaymentCreditCardScreen.route,
        ),
        PaymentProvider(
          image: 'lib/assets/images/paypal.png',
          route: '/payment/paypal',
        ),
      },
    );
  }
}

class PaymentProvider {
  String image;
  String route;

  PaymentProvider({required this.image, required this.route});
}
