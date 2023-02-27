import 'package:appventure/components/black_divider.dart';
import 'package:appventure/models/activity_model.dart';
import 'package:appventure/models/order_model.dart';
import 'package:appventure/screens/checkout_screen/components/booking_bar.dart';
import 'package:appventure/screens/payment_credit_card_screen/bloc/input_field_bloc.dart';
import 'package:appventure/screens/payment_credit_card_screen/bloc/payment_credit_card_bloc.dart';
import 'package:appventure/screens/payment_credit_card_screen/components/payment_credit_card_screen_three_d_secure_view.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:card_scanner/card_scanner.dart';
import 'package:card_scanner/models/card_scan_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

class PaymentCreditCardScreenView extends StatefulWidget {
  final OrderModel order;
  final ActivityModel activity;

  PaymentCreditCardScreenView({
    @required this.order,
    @required this.activity,
  });

  @override
  _PaymentCreditCardScreenViewState createState() =>
      _PaymentCreditCardScreenViewState();
}

class _PaymentCreditCardScreenViewState
    extends State<PaymentCreditCardScreenView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String maskedCardNumber = "";
  String maskedExpDate = "";

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();
  PaymentCreditCardBloc bloc = PaymentCreditCardBloc();

  @override
  initState() {
    cardNumberController.addListener(() {
      maskedCardNumber = cardNumberController.text;
    });
    expDateController.addListener(() {
      maskedExpDate = expDateController.text;
    });
    cardNumberController.addListener(() {
      String currentValue = cardNumberController.text;
      String currentValueNotFormatted = currentValue.replaceAll(' ', '');
      String newValue = formatCreditCardNumber(currentValueNotFormatted);
      if (newValue != currentValue) {
        cardNumberController.value = TextEditingValue(
            composing: TextRange(start: newValue.length, end: newValue.length),
            selection: TextSelection.collapsed(offset: newValue.length),
            text: newValue);

        cardNumberController.clearComposing();
      }
    });
    _getEmptyValidation();
    _getInvalidValidation();
    _getPaymentResponse();
    super.initState();
  }

  void _getPaymentResponse() {
    bloc.getPaymentResponse.listen((event) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentCreditCardScreenThreeDSecureView(
              future: event,
              activity: widget.activity,
              order: widget.order.products),
        ),
      );
    });
  }

  void _getEmptyValidation() {
    bloc.getEmptyValidation.listen((isValid) {
      if (!isValid) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context).commonWords_formNotFilled,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: CustomTheme.theme.primaryColorDark,
          textColor: Colors.white,
        );
      }
    });
  }

  void _getInvalidValidation() {
    bloc.getInvalidValidation.listen((isValid) {
      if (!isValid) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)
              .paymentCreditCardScreen_valuesInvalid,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: CustomTheme.theme.primaryColorDark,
          textColor: Colors.white,
        );
      }
    });
  }

  dispose() {
    bloc.dispose();
    cvcController.dispose();
    cardHolderController.dispose();
    cardNumberController.dispose();
    expDateController.dispose();

    super.dispose();
  }

  String formatCreditCardNumber(String inputText) {
    String s = "";
    for (int i = 0; i < inputText.length; i++) {
      if (i > 0 && i % 4 == 0) s += " ";
      s += inputText.characters.elementAt(i);
    }
    return s;
  }

  String formatExpDate(String inputText) {
    String s = "";
    for (int i = 0; i < inputText.length; i++) {
      if (i == 2) s += "/";
      s += inputText.characters.elementAt(i);
    }
    return s;
  }

  void scanCard() async {
    CardScanOptions scanOptions = CardScanOptions(
      considerPastDatesInExpiryDateScan: true,
      scanExpiryDate: true,
      enableLuhnCheck: true,
      scanCardHolderName: true,
      validCardsToScanBeforeFinishingScan: 6,
    );

    bloc.setScanning = true;

    Future.delayed(Duration(seconds: 3), () {
      bloc.setScanning = false;
    });

    CardDetails cardDetails;
    try {
      cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
    } on Exception catch (_) {
      return;
    } on Error catch (_) {
      return;
    }

    bloc.setScanning = false;

    if (cardDetails == null) return;

    if (cardDetails.expiryDate != null) {
      String expDateValue = cardDetails.expiryDate
          .toString()
          .replaceAll('/', '')
          .replaceAll(' ', '');
      expDateController.text = formatExpDate(expDateValue);
      maskedExpDate = formatExpDate(expDateValue);
    }

    if (cardDetails.cardNumber != null) {
      String creditCardNumberValue = cardDetails.cardNumber.toString();
      cardNumberController.text = formatCreditCardNumber(creditCardNumberValue);
      maskedCardNumber = formatCreditCardNumber(creditCardNumberValue);
    }

    cardHolderController.text = cardDetails?.cardHolderName;
  }

  bool _showToolTip = false;

  DateTime expDateToDateTime(String expDate) {
    List<String> expDates = expDate.split('/');
    DateTime date =
        DateTime(2000 + int.parse(expDates[1]), int.parse(expDates[0]));
    return date;
  }

  validateExpDateTime(String expDate) {
    try {
      DateTime cardDate = expDateToDateTime(expDate);
      DateTime compareDate =
          DateTime(DateTime.now().year, DateTime.now().month);
      return !compareDate.isAfter(cardDate);
    } on RangeError {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height -
              Dimensions.getScaledSize(60.0) -
              MediaQuery.of(context).padding.bottom,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.getScaledSize(20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Dimensions.getScaledSize(24.0),
                        right: Dimensions.getScaledSize(24.0)),
                    child: Text(
                      widget.activity.activityDetails.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(18.0),
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.getScaledSize(20.0),
                  ),
                  BlackDivider(
                    height: Dimensions.getScaledSize(1.0),
                  ),
                  SizedBox(
                    height: Dimensions.getScaledSize(20.0),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: Dimensions.getScaledSize(24.0),
                        right: Dimensions.getScaledSize(24.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .paymentCreditCardScreen_creditCardDetails,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(18.0),
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.primaryColorDark,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getScaledSize(20.0),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: Dimensions.getScaledSize(12.0),
                            bottom: Dimensions.getScaledSize(12.0),
                            left: Dimensions.getScaledSize(12.0),
                            right: Dimensions.getScaledSize(12.0),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomTheme.darkGrey.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(
                                Dimensions.getScaledSize(16.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: Dimensions.getScaledSize(50.0),
                                child: Image(
                                  image: AssetImage(
                                      'lib/assets/images/creditcardslogo.png'),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              InputField(
                                context: context,
                                hint: 'Karteninhaber',
                                keyboardType: TextInputType.text,
                                validation: RegExp(r'.*'),
                                leading: StreamBuilder<bool>(
                                    stream: bloc.getScanning,
                                    builder: (context, snapshot) {
                                      if (snapshot.data ?? false) {
                                        return Container(
                                          height: Dimensions.getScaledSize(24),
                                          width: Dimensions.getScaledSize(24),
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return GestureDetector(
                                        onTap: () async {
                                          if (await Permission.camera
                                              .request()
                                              .isGranted) {
                                            scanCard();
                                          }
                                        },
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: Dimensions.getScaledSize(24),
                                          color: CustomTheme.darkGrey
                                              .withOpacity(0.5),
                                        ),
                                      );
                                    }),

                                // SvgPicture.asset(
                                //   'lib/assets/images/calendar.svg',
                                //   height: Dimensions.getScaledSize(24.0),
                                //   width: Dimensions.getScaledSize(24.0),
                                //   color: CustomTheme.darkGrey.withOpacity(0.5),
                                // ),
                                textEditingController: cardHolderController,
                              ),
                              BlackDivider(
                                  height: Dimensions.getScaledSize(1.0)),
                              InputField(
                                context: context,
                                hint: AppLocalizations.of(context)
                                    .paymentCreditCardScreen_creditCardNumber,
                                keyboardType: TextInputType.number,
                                validation:
                                    RegExp(r'^([0-9]{4}\s){3}[0-9]{3,4}$'),
                                textInputFormatter: MaskTextInputFormatter(
                                  mask: '#### #### #### ####',
                                  initialText: maskedCardNumber,
                                ),
                                textEditingController: cardNumberController,
                              ),
                              BlackDivider(
                                  height: Dimensions.getScaledSize(1.0)),
                              InputField(
                                context: context,
                                hint: AppLocalizations.of(context)
                                    .paymentCreditCardScreen_expDateHint,
                                keyboardType: TextInputType.number,
                                validation: RegExp(
                                    r'^(1[0-2]{0,1}|0[0-9]{0,1})\/\d{2}$'),
                                leading: SvgPicture.asset(
                                  'lib/assets/images/calendar.svg',
                                  height: Dimensions.getScaledSize(24.0),
                                  width: Dimensions.getScaledSize(24.0),
                                  color: CustomTheme.darkGrey.withOpacity(0.5),
                                ),
                                textInputFormatter: MaskTextInputFormatter(
                                    mask: '##/##', initialText: maskedExpDate),
                                textEditingController: expDateController,
                                validationFunction: validateExpDateTime,
                              ),
                              BlackDivider(
                                height: Dimensions.getScaledSize(1.0),
                              ),
                              InputField(
                                context: context,
                                hint: AppLocalizations.of(context)
                                    .paymentCreditCardScreen_securityCode,
                                keyboardType: TextInputType.number,
                                validation: RegExp(r'^\d{1,4}$'),
                                leading: Stack(
                                  children: [
                                    StreamBuilder<bool>(
                                        stream: bloc.getToolTip,
                                        builder: (context, snapshot) {
                                          _showToolTip = snapshot.data ?? false;
                                          return SimpleTooltip(
                                            animationDuration:
                                                Duration(milliseconds: 10),
                                            show: _showToolTip,
                                            tooltipDirection:
                                                TooltipDirection.up,
                                            borderWidth: 0,
                                            ballonPadding: EdgeInsets.all(
                                              Dimensions.getScaledSize(10.0),
                                            ),
                                            customShadows: [],
                                            backgroundColor:
                                                CustomTheme.accentColor3,
                                            tooltipTap: () {
                                              bloc.setToolTip = !_showToolTip;
                                            },
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            minimumOutSidePadding:
                                                Dimensions.getScaledSize(29),
                                            content: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .getScaledSize(20.0)),
                                                color: CustomTheme.accentColor3,
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .paymentCreditCardScreen_securityCodeInvalid,
                                                style: TextStyle(
                                                  fontSize:
                                                      Dimensions.getScaledSize(
                                                          13.0),
                                                  color: CustomTheme.darkGrey,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                bloc.setToolTip = !_showToolTip;
                                              },
                                              child: Icon(
                                                Icons.info_outlined,
                                                size: Dimensions.getScaledSize(
                                                    24.0),
                                                color: _showToolTip
                                                    ? CustomTheme.accentColor3
                                                    : CustomTheme.darkGrey
                                                        .withOpacity(0.5),
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                                textInputFormatter: MaskTextInputFormatter(
                                  mask: '####',
                                ),
                                textEditingController: cvcController,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.getScaledSize(10.0),
                        ),
                        Center(
                          child: Image.asset(
                            'lib/assets/images/payment.png',
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom +
                              Dimensions.getScaledSize(65),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return isKeyboardVisible
                ? Container()
                : Positioned(
                    bottom: 0,
                    child: BookingBar(
                      bookingDetails: widget.activity.bookingDetails,
                      orderProducts: widget.order.products,
                      onTap: _processPayment,
                      buttonText: AppLocalizations.of(context)
                          .paymentCreditCardScreen_payNow,
                      showDivider: true,
                    ),
                  );
          },
        ),
      ],
    );
  }

  //fixme: unused methods! better to remove
/*  handleCardNumberChanged(String value) {
    setState(() {
      this.cardNumber = value;
    });
  }

  handleNameChanged(String value) {
    setState(() {
      this.name = value;
    });
  }

  handleExpDateChanged(String value) {
    setState(() {
      this.expDate = value;
    });
  }

  handleCvcChanged(String value) {
    setState(() {
      this.cvc = value;
    });
  }*/

  // String getCreditCardType(String cardNumber) {
  //   if (cardNumber != null &&
  //       cardNumber != '' &&
  //       double.tryParse(cardNumber) != null) {
  //     var type = detectCCType(cardNumber);
  //     if (type == CreditCardType.visa)
  //       return 'Visa';
  //     else if (type == CreditCardType.mastercard)
  //       return 'Mastercard';
  //     else if (type == CreditCardType.amex) return 'AMEX';
  //   }
  //   return '';
  // }

  _processPayment() {
    var cardNumber = cardNumberController.text;
    var name = nameController.text;
    var expDate = expDateController.text;
    var cvc = cvcController.text;

    final FormState form1 = _formKey.currentState;
    if (!form1.validate()) {
      bloc.setInvalidValidation = false;
      return;
    }
    bloc.setInvalidValidation = true;

    bloc.payment(name, cardNumber, expDate, cvc, widget.order);
    return;
  }
}

enum ValidationType {
  NoValue,
  Valid,
  Invalid,
}

class InputField extends StatefulWidget {
  final BuildContext context;
  final String hint;
  final TextInputType keyboardType;
  final RegExp validation;
  final Widget leading;
  final MaskTextInputFormatter textInputFormatter;
  final TextEditingController textEditingController;
  final String errorMsg;
  final Function validationFunction;

  InputField({
    this.context,
    this.hint,
    this.keyboardType,
    this.validation,
    this.leading,
    this.textInputFormatter,
    this.textEditingController,
    this.errorMsg,
    this.validationFunction,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  InputFieldBloc bloc = InputFieldBloc();
  bool showBorder = false;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.getScaledSize(15.0),
        left: Dimensions.getScaledSize(8.0),
        bottom: Dimensions.getScaledSize(3),
      ),
      child: StreamBuilder<ValidationType>(
          stream: bloc.validationStream,
          builder: (context, snapshot) {
            return StreamBuilder<bool>(
                stream: bloc.showBorderStream,
                builder: (context, showBorderSnap) {
                  showBorder = showBorderSnap.data ?? false;
                  return TextFormField(
                    maxLines: 1,
                    controller: widget.textEditingController,
                    inputFormatters: widget.textInputFormatter != null
                        ? [widget.textInputFormatter]
                        : [],
                    keyboardType: widget.keyboardType,
                    validator: (String arg) {
                      bloc.showBorder = false;
                      if (arg == null || arg == '') {
                        bloc.validation = ValidationType.NoValue;
                        return null;
                      } else if (widget.validation == null) {
                        bloc.validation = ValidationType.Valid;
                        return null;
                      } else {
                        var validationResult =
                            widget.validation.hasMatch(arg) ? null : ' ';
                        bool newShowBorder = false;
                        ValidationType currentValidation;

                        if (validationResult == null ||
                            validationResult == '') {
                          currentValidation = ValidationType.Valid;
                        } else {
                          currentValidation = ValidationType.Invalid;
                        }

                        if (widget.validationFunction != null &&
                            !widget.validationFunction(arg) &&
                            currentValidation == ValidationType.Valid) {
                          validationResult = ' ';
                          currentValidation = ValidationType.Invalid;
                          newShowBorder = true;
                        }

                        bloc.validation = currentValidation;
                        bloc.showBorder = newShowBorder;
                        return validationResult;
                      }
                    },
                    style: TextStyle(
                      fontSize: Dimensions.getScaledSize(14.0),
                      letterSpacing: CustomTheme.letterSpacing,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: new InputDecoration(
                      errorStyle: TextStyle(height: 0),
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: TextStyle(color: CustomTheme.dividerColor),
                      prefixIcon: widget.leading != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                bottom: Dimensions.getScaledSize(5.0),
                                right: Dimensions.getScaledSize(10.0),
                              ),
                              child: widget.leading,
                            )
                          : null,
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                      ),
                      suffixIcon: snapshot.data == ValidationType.Valid
                          ? Icon(
                              Icons.check,
                              color: CustomTheme.accentColor2,
                            )
                          : snapshot.data == ValidationType.Invalid
                              ? Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                )
                              : null,
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: showBorder
                                  ? CustomTheme.accentColor1
                                  : Colors.transparent,
                              width: Dimensions.getScaledSize(2))),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: showBorder
                                  ? CustomTheme.accentColor1
                                  : Colors.transparent,
                              width: Dimensions.getScaledSize(2))),
                    ),
                  );
                });
          }),
    );
  }
}
