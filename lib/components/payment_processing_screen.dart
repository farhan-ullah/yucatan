import 'package:yucatan/components/custom_app_bar.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/rive_animation.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PaymentProcessingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: AppLocalizations.of(context)!.paymentPayPalScreen_title,
        centerTitle: true,
      ),
      body: PaymentProcessingScreenBody(),
    );
  }
}

class PaymentProcessingScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            AppLocalizations.of(context)!.payment_processing_screen_description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.getScaledSize(20.0),
              letterSpacing: CustomTheme.letterSpacing,
              color: CustomTheme.primaryColorDark,
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(50),
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: RiveAnimation(
              riveFileName: 'safe_payment_loop.riv',
              riveAnimationName: 'Animation 1',
              placeholderImage: 'lib/assets/images/payment.png',
              startAnimationAfterMilliseconds: 0,
            ),
          ),
        ),
      ],
    );
  }
}
