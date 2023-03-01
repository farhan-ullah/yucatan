import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/order_model.dart';
import 'package:yucatan/screens/authentication/components/input_field_box.dart';
import 'package:yucatan/screens/authentication/components/input_textfield.dart';
import 'package:yucatan/screens/checkout_screen/components/booking_bar.dart';
import 'package:yucatan/screens/checkout_screen/components/payment_provider.dart';
import 'package:yucatan/screens/impressum_datenschutz/impressum_datenschutz.dart';
import 'package:yucatan/screens/inquiry/components/inquiry_screen_parameter.dart';
import 'package:yucatan/screens/inquiry/inquiry_screen.dart';
import 'package:yucatan/screens/payment_credit_card_screen/components/payment_credit_card_screen_parameter.dart';
import 'package:yucatan/services/analytics_service.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/country_utils.dart';
import 'package:yucatan/utils/regex_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flag/flag.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'checkout_checkbox_formfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flag/flag.dart';

class CheckoutScreenView extends StatefulWidget {
  final ActivityModel activity;
  final OrderModel order;

  CheckoutScreenView({required this.activity, required this.order});

  @override
  _CheckoutScreenViewState createState() => _CheckoutScreenViewState();
}

class _CheckoutScreenViewState extends State<CheckoutScreenView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedRoute = '';
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  String currentText = "";
  String defaultPhoneValue = "+49";
  String defaultFlagValue = "DE";
  Future<UserLoginModel>? user;
  UserLoginModel? _loadedUser;
  bool initialValuesSet = false;
  bool isWeiterBtnPressed = false;

  String? name;
  String? lastName;
  String? street;
  String? houseNumber;
  String? zipCode;
  String? city;
  //String country;
  String? email;
  String? areaCode;
  String? phoneNumber;
  String? countryISO2Code;
  String? countryISO2Name;
  String? countryISO3166;
  bool? checkboxAGB;
  bool? checkboxData;
  ValidationType? nameValidationType;
  ValidationType? lastNameValidationType;
  ValidationType? streetValidationType;
  ValidationType? houseNumberValidationType;
  ValidationType? zipCodeValidationType;
  ValidationType? cityValidationType;
  ValidationType? countryValidationType;
  ValidationType? emailValidationType;
  ValidationType? phoneValidationType;
  TextEditingController countryTextEditingController = TextEditingController();
  late Product product;

  @override
  void initState() {
    AnalyticsService.logInitiatedCheckout(widget.order);

    user = UserProvider.getUser();
    this.countryISO2Code = "DE";
    this.countryISO2Name = "Deutschland";
    this.areaCode = defaultPhoneValue;
    phoneNumber = "";
    countryTextEditingController.text = countryISO2Name!;

    CountryData findCountry(String countryName) => CountryUtils.getInstance()
        .countryObject!
        .countryList
        .firstWhere((country) => country.country == countryISO2Code);

    String flagValue = findCountry(countryISO2Code!).country;
    countryISO3166 = flagValue;
    super.initState();
  }

  BoxDecoration myBoxDecoration() {
    Color undelineColor;
    if (isWeiterBtnPressed && phoneNumber!.isEmpty) {
      undelineColor = CustomTheme.accentColor1;
    } else {
      undelineColor = CustomTheme.darkGrey.withOpacity(0.5);
    }
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          //color: CustomTheme.darkGrey.withOpacity(0.5),
          color: undelineColor,
          width: 1.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
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
                      widget.activity.activityDetails!.title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(18.0),
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.getScaledSize(10.0),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                      horizontal: Dimensions.getScaledSize(24),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.getScaledSize(10),
                      vertical: Dimensions.getScaledSize(10),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CustomTheme.mediumGrey,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dimensions.getScaledSize(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.commonWords_invoiceAddress,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.getScaledSize(18.0),
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.primaryColorDark,
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          left: Dimensions.getScaledSize(24.0),
                          right: Dimensions.getScaledSize(24.0)),
                      child: FutureBuilder<UserLoginModel>(
                          future: user,
                          builder: (context, snapshot) {
                            _loadedUser = snapshot.data;
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (initialValuesSet == false) {
                                initialValuesSet = true;

                                defaultPhoneValue = snapshot.data!.areaCode;
                                var flagValue = CountryUtils.getInstance()
                                    .countryObject!
                                    .jsonPhoneMap
                                    .keys
                                    .firstWhere(
                                        (k) =>
                                            CountryUtils.getInstance()
                                                .countryObject!
                                                .jsonPhoneMap[k] ==
                                            defaultPhoneValue,
                                        orElse: () => "DE");
                                defaultFlagValue = flagValue;

                                name = snapshot.data!.firstname;
                                lastName = snapshot.data!.lastname;
                                street = snapshot.data!.street;
                                houseNumber = snapshot.data!.housenumber;
                                zipCode = snapshot.data!.zipcode;
                                city = snapshot.data!.city;
                                email = snapshot.data!.email;
                                phoneNumber = snapshot.data!.phone;
                                countryISO2Code = snapshot.data!.countryISO2;
                                countryISO2Name = CountryUtils.getInstance()
                                    .countryObject!
                                    .countryList
                                    .firstWhere(
                                        (element) =>
                                            element.country.toLowerCase() ==
                                            countryISO2Code!.toLowerCase(),
                                        orElse: () => CountryData('', ''))
                                    .countryName;
                              }

                              return snapshot.hasData
                                  ? _getInputFieldsForm(
                                      initialFirstname: name!,
                                      initialLastname: lastName!,
                                      initialStreet: street!,
                                      initialHousenumber: houseNumber!,
                                      initialZipcode: zipCode!,
                                      initialCity: city!,
                                      initialEmail: email!,
                                      initialPhone: phoneNumber!,
                                      countryIso2Code: countryISO2Code!,
                                      countryIso2Name: countryISO2Name!,
                                    )
                                  : _getInputFieldsForm();
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: Dimensions.getScaledSize(10.0),
                                    left: Dimensions.getScaledSize(20.0),
                                    bottom: Dimensions.getScaledSize(20.0),
                                    right: Dimensions.getScaledSize(20.0)),
                                child: Text('${snapshot.error}'),
                              );
                            }

                            return const Center(child: CircularProgressIndicator());
                          })),
                  SizedBox(
                    height: Dimensions.getScaledSize(90.0) +
                        MediaQuery.of(context).padding.bottom,
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
                      bookingDetails: widget.activity.bookingDetails!,
                      orderProducts: widget.order.products!,
                      onTap: () {
                        setState(() {
                          this.isWeiterBtnPressed = true;
                        });
                        _proceedToPayment();
                      },
                      buttonText:
                          AppLocalizations.of(context)!.commonWords_further,
                      showDivider: true,
                    ),
                  );
          },
        ),
      ],
    );
  }

  _getInputFieldsForm({
    String initialFirstname = "",
    String initialLastname = "",
    String initialStreet = "",
    String initialHousenumber = "",
    String initialZipcode = "",
    String initialCity = "",
    String initialEmail = "",
    String initialPhone = "",
    String countryIso2Code = "",
    String countryIso2Name = "",
  }) {
    countryTextEditingController.text = countryIso2Name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputField(
          context: context,
          hint: AppLocalizations.of(context)!.commonWords_name,
          keyboardType: TextInputType.text,
          callback: handleNameChanged,
          initialValue: initialFirstname,
          isWeiterBtnPressed: this.isWeiterBtnPressed,
        ),
        InputField(
          context: context,
          hint: AppLocalizations.of(context)!.commonWords_surname,
          keyboardType: TextInputType.text,
          callback: handleLastNameChanged,
          initialValue: initialLastname,
          isWeiterBtnPressed: this.isWeiterBtnPressed,
        ),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: InputField(
                context: context,
                isWeiterBtnPressed: this.isWeiterBtnPressed,
                hint: AppLocalizations.of(context)!.commonWords_street,
                keyboardType: TextInputType.text,
                callback: handleStreetChanged,
                initialValue: initialStreet,
              ),
            ),
            SizedBox(
              width: Dimensions.getScaledSize(10.0),
            ),
            Expanded(
              flex: 4,
              child: InputField(
                context: context,
                isWeiterBtnPressed: this.isWeiterBtnPressed,
                hint: AppLocalizations.of(context)!
                    .commonWords_number_abbreviation,
                keyboardType: TextInputType.text,
                callback: handleHouseNumberChanged,
                initialValue: initialHousenumber,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: InputField(
                context: context,
                isWeiterBtnPressed: this.isWeiterBtnPressed,
                hint: AppLocalizations.of(context)!.commonWords_postalCode,
                keyboardType: TextInputType.number,
                callback: handleZipCodeChanged,
                initialValue: initialZipcode,
                validation: RegexUtils.zipcode,
                validationErrorMsg:
                    AppLocalizations.of(context)!.commonWords_postalCodeInvalid,
              ),
            ),
            SizedBox(
              width: Dimensions.getScaledSize(10),
            ),
            Expanded(
              flex: 6,
              child: InputField(
                isWeiterBtnPressed: this.isWeiterBtnPressed,
                context: context,
                hint: AppLocalizations.of(context)!.commonWords_location,
                keyboardType: TextInputType.text,
                initialValue: initialCity,
                callback: handleCityChanged,
              ),
            ),
          ],
        ),
        /*InputField(
          isWeiterBtnPressed: this.isWeiterBtnPressed,
          context: context,
          hint: 'Land',
          keyboardType: TextInputType.name,
          callback: handleCountryChanged,
        ),*/

        Container(
          margin: EdgeInsets.fromLTRB(
            Dimensions.getScaledSize(5),
            Dimensions.getScaledSize(15),
            Dimensions.getScaledSize(5),
            Dimensions.getScaledSize(10),
          ),
          child: SimpleAutoCompleteTextField(
            key: key,
            decoration: new InputDecoration(
              hintText: AppLocalizations.of(context)!.commonWords_land,
              suffixIcon: new Icon(
                Icons.keyboard_arrow_down_rounded,
                size: Dimensions.getScaledSize(30),
              ),
            ),
            //controller: TextEditingController(text: this.countryISO2Name/*countryIso2Name*/),
            controller: countryTextEditingController,
            suggestions: CountryUtils.getInstance().countryObject!.countryList2,
            textChanged: (text) => currentText = text,
            clearOnSubmit: false,
            submitOnSuggestionTap: true,
            style: TextStyle(fontSize: Dimensions.getScaledSize(15)),
            textSubmitted: (text) {
              this.countryISO2Name = text;
              CountryData findCountry(String countryName) =>
                  CountryUtils.getInstance()
                      .countryObject!
                      .countryList
                      .firstWhere((country) => country.countryName == text);
              String flagValue = findCountry(text).country;
              this.countryISO2Code = flagValue;
              countryISO3166 = flagValue;
              setState(() {
                handlePhoneChanged(flagValue);
                this.defaultPhoneValue = CountryUtils.getInstance()
                    .countryObject!
                    .jsonPhoneMap[flagValue];
                this.defaultFlagValue = flagValue;
                print(
                    "defaultFlagValue=$defaultFlagValue and defaultPhoneValue=$defaultPhoneValue");
              });
            },
          ),
        ),
        InputField(
          isWeiterBtnPressed: this.isWeiterBtnPressed,
          context: context,
          hint: AppLocalizations.of(context)!.authenticationSceen_email,
          keyboardType: TextInputType.emailAddress,
          callback: handleEmailChanged,
          initialValue: initialEmail,
          validation: RegexUtils.email,
          validationErrorMsg:
              AppLocalizations.of(context)!.authenticationSceen_emailInvalid,
        ),
        Container(
          decoration: myBoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Dimensions.getWidth(percentage: 25.0),
                margin: EdgeInsets.fromLTRB(
                  Dimensions.getScaledSize(5),
                  Dimensions.getScaledSize(20),
                  Dimensions.getScaledSize(0),
                  Dimensions.getScaledSize(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<String>(
                    iconSize: 0.0,
                    underline: Container(
                      width: 0,
                      height: 0,
                    ),
                    isExpanded: true,
                    iconEnabledColor: Colors.white,
                    iconDisabledColor: Colors.white,
                    value: isNotNullOrEmpty(defaultPhoneValue)
                        ? defaultPhoneValue
                        : "+49",
                    selectedItemBuilder: (BuildContext context) {
                      return CountryUtils.getInstance()
                          .countryObject!
                          .countryPhoneList
                          .map<Widget>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Flag.fromString(
                                '$defaultFlagValue',
                                width: Dimensions.getScaledSize(32),
                                height: Dimensions.getScaledSize(22),
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: Dimensions.pixels_10,
                              ),
                              Expanded(
                                child: Text(
                                  '${value.contains("+") ? value : "+$value"}',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    items: CountryUtils.getInstance()
                        .countryObject!
                        .countryPhoneList
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          '${value.contains("+") ? value : "+$value"}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: Dimensions.getScaledSize(15),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      //print("onChanged=${val}");
                      var result = CountryUtils.getInstance()
                          .countryObject!
                          .jsonPhoneMap
                          .keys
                          .firstWhere(
                              (k) =>
                                  CountryUtils.getInstance()
                                      .countryObject!
                                      .jsonPhoneMap[k] ==
                                  val,
                              // orElse: () => null
                      );
                      //print("CountryUtils.getInstance()=${result} and countryISO3166=${countryISO3166}");
                      //print("CountryName=${CountryUtils.getInstance().countryObject.jsonMap[result]}");
                      countryIso2Name = CountryUtils.getInstance()
                          .countryObject!
                          .jsonMap[result];
                      countryISO3166 = result;
                      this.countryISO2Name = countryIso2Name;
                      this.defaultFlagValue = result;
                      countryTextEditingController.text = countryIso2Name;
                      setState(() {
                        handlePhoneChanged(val!);
                        this.defaultPhoneValue = val;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    Dimensions.pixels_10,
                    Dimensions.pixels_15,
                    0,
                    0,
                  ),
                  child: InputFieldBox(
                    fields: [
                      InputTextField(
                          isComingFromCheckout: true,
                          isProfilePhoneNumber: true,
                          phoneNumberValue: phoneNumber,
                          hintText:
                              AppLocalizations.of(context)!.commonWords_phone,
                          showUnderline: false,
                          textInputType: TextInputType.number,
                          validationErrorMsg: AppLocalizations.of(context)!
                              .commonWords_phoneInvalid,
                          autocorrect: false,
                          onTextChanged: (String text) {
                            this.phoneNumber = text;
                            //setState(() { _model.email = text; widget.onChange.call(_model); });
                          }),
                    ],
                    onValidated: (bool isValid) {
                      //setState(() { _model.isValid = isValid; widget.onChange.call(_model); });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(30.0),
        ),
        CheckoutCheckboxFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: false,
          callback: handlecheckboxAGBChanged,
          text: TextSpan(children: [
            TextSpan(
                text: AppLocalizations.of(context)!.commonWords_AGBpolicy1),
            TextSpan(
              text: AppLocalizations.of(context)!.commonWords_AGBpolicy2,
              style: const TextStyle(
                  color: CustomTheme.primaryColor,
                  fontFamily: CustomTheme.fontFamily),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImpressumDatenschutz(
                              isComingFromCheckOut: true,
                              webViewValues: WebViewValues.TOS,
                            )),
                  );
                },
            ),
            TextSpan(
                text: AppLocalizations.of(context)!.commonWords_AGBpolicy3),
          ]),
        ),
        CheckoutCheckboxFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: false,
          callback: handlecheckboxDataChanged,
          text: TextSpan(children: [
            TextSpan(text: AppLocalizations.of(context)!.commonWords_DSpolicy1),
            TextSpan(
              text: AppLocalizations.of(context)!.commonWords_DSpolicy2,
              style: const TextStyle(
                  color: CustomTheme.primaryColor,
                  fontFamily: CustomTheme.fontFamily),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImpressumDatenschutz(
                              isComingFromCheckOut: true,
                              webViewValues: WebViewValues.PRIVACY,
                            )),
                  );
                },
            ),
            TextSpan(text: AppLocalizations.of(context)!.commonWords_DSpolicy3)
          ]),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(20),
        ),
        Text(
          AppLocalizations.of(context)!.checkoutScreen_paymentMethod,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(18.0),
            fontWeight: FontWeight.bold,
            color: CustomTheme.primaryColorDark,
          ),
        ),
        SizedBox(
          height: Dimensions.getScaledSize(20.0),
        ),
        PaymentProviderList(
          callback: onTapPaymentProvider,
        ),
      ],
    );
  }

  handlecheckboxDataChanged(bool value) {
    setState(() {
      this.checkboxData = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  handlecheckboxAGBChanged(bool value) {
    setState(() {
      this.checkboxAGB = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  handleNameChanged(String value) {
    setState(() {
      this.name = value;
      final FormState form = _formKey.currentState!;

      form.validate();
    });
  }

  handleLastNameChanged(String value) {
    setState(() {
      this.lastName = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  handleStreetChanged(String value) {
    setState(() {
      this.street = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  handleHouseNumberChanged(String value) {
    setState(() {
      this.houseNumber = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  handleZipCodeChanged(String value) {
    setState(() {
      this.zipCode = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  handleCityChanged(String value) {
    setState(() {
      this.city = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  /*handleCountryChanged(String value) {
    //setState(() {
      this.city = value;
      final FormState form = _formKey.currentState;
      form.validate();
    //});
  }*/

  handleEmailChanged(String value) {
    setState(() {
      this.email = value;
      final FormState form = _formKey.currentState!;
      form.validate();
    });
  }

  handlePhoneChanged(String value) {
    //setState(() {
    this.areaCode = value;
    final FormState form = _formKey.currentState!;
    form.validate();
    //});
  }

  onTapPaymentProvider(String route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  _proceedToPayment() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      FocusScope.of(context).unfocus();
      if (name != null &&
          name != '' &&
          lastName != null &&
          lastName != '' &&
          street != null &&
          street != '' &&
          houseNumber != null &&
          houseNumber != '' &&
          zipCode != null &&
          zipCode != '' &&
          city != null &&
          city != '' &&
          email != null &&
          email != '' &&
          this.phoneNumber != null &&
          this.phoneNumber != '' &&
          countryISO2Code != null &&
          countryISO2Code != '' &&
          countryISO2Name != null &&
          countryISO2Code != '') {
        widget.order.address = AddressModel(
            name: '$name $lastName',
            email: email!,
            street: street!,
            houseNumber: houseNumber!,
            zipCode: zipCode!,
            city: city!,
            phone: phoneNumber,
            areaCode: areaCode!,
            countryISO2: countryISO3166!);

        if (_selectedRoute == '') {
          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!
                .checkoutScreen_selectPaymentMethod,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: CustomTheme.theme.primaryColorDark,
            textColor: Colors.white,
          );
        } else {
          _updateUserAddress();
          if (_requestRequestForBooking()) {
            Navigator.of(context).pushNamed(
              InquiryScreen.route,
              arguments: InquiryScreenParameter(
                activity: widget.activity,
                order: widget.order,
                selectedPaymentRoute: _selectedRoute,
              ),
            );
          } else {
            Navigator.of(context).pushNamed(
              _selectedRoute,
              arguments: PaymentCreditCardScreenParameter(
                  activity: widget.activity, order: widget.order),
            );
          }
        }
      } else {
        //ADD FORM FIELD IN TRANSLATION
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.commonWords_formNotFilled,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: CustomTheme.theme.primaryColorDark,
          textColor: Colors.white,
        );
      }
    } else {
      String errorMsg =
          AppLocalizations.of(context)!.checkoutScreen_requierdFieldsNotFilled;
      if (checkboxAGB == null || checkboxAGB == false)
        errorMsg = AppLocalizations.of(context)!.checkoutScreen_acceptAGB;
      else if (checkboxData == null || checkboxData == false)
        errorMsg = AppLocalizations.of(context)!.checkoutScreen_acceptPrivacy;
      Fluttertoast.showToast(
        msg: errorMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: CustomTheme.theme.primaryColorDark,
        textColor: Colors.white,
      );
    }
  }

  /// Each field gets checked individually. If it is null/empty then saving the value for that field in shared prefs
  void _updateUserAddress() async {
    UserLoginModel userModel = _loadedUser!;
    if (!checkIfNullOrEmpty(userModel.lastname)) {
      userModel.lastname = lastName!;
    }
    if (!checkIfNullOrEmpty(userModel.firstname)) {
      userModel.firstname = name!;
    }
    if (!checkIfNullOrEmpty(userModel.street)) {
      userModel.street = street!;
    }
    if (!checkIfNullOrEmpty(userModel.housenumber)) {
      userModel.housenumber = houseNumber!;
    }
    if (!checkIfNullOrEmpty(userModel.zipcode)) {
      userModel.zipcode = zipCode!;
    }
    if (!checkIfNullOrEmpty(userModel.city)) {
      userModel.city = city!;
    }
    if (!checkIfNullOrEmpty(userModel.phone)) {
      userModel.phone = phoneNumber!;
    }
    if (!checkIfNullOrEmpty(userModel.areaCode)) {
      userModel.areaCode = areaCode!;
    }
    if (!checkIfNullOrEmpty(userModel.countryISO2)) {
      userModel.countryISO2 = countryISO2Code!;
    }
    await UserProvider.update(userModel);
  }

  bool _requestRequestForBooking() {
    bool requestRequired = false;

    widget.order.products!.forEach((productElement) {
      Product product = _findProduct(productElement.id!);
      if (product.requestRequired!) {
        requestRequired = true;
      }
    });

    return requestRequired;
  }

  Product _findProduct(String productId) {
    // Product product;

    widget.activity.bookingDetails!.productCategories!.forEach(
      (productCategoryElement) {
        productCategoryElement.products!.forEach(
          (productElement) {
            if (productElement.id == productId) {
              product = productElement;
            }
          },
        );
        productCategoryElement.productSubCategories!.forEach(
          (productSubCategoryElement) {
            productSubCategoryElement.products!.forEach(
              (productElement) {
                if (productElement.id == productId) {
                  product = productElement;
                }
              },
            );
          },
        );
      },
    );

    return product;
  }
}

enum ValidationType {
  NoValue,
  Valid,
  Invalid,
}

class InputField extends StatefulWidget {
  final BuildContext? context;
  final String? hint;
  final ValueChanged<String>? callback;
  final TextInputType? keyboardType;
  final Function(String)? validationFunc;
  final RegExp? validation;
  final String? validationErrorMsg;
  final String? initialValue;
  final bool? isWeiterBtnPressed;

  InputField(
      {this.context,
      this.hint,
      this.callback,
      this.keyboardType,
      this.validationFunc,
      this.validation,
      this.validationErrorMsg,
      this.isWeiterBtnPressed,
      this.initialValue});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  ValidationType? validationType;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.addListener(() {
      final arg = textEditingController.value.text;
      if (arg == null || arg == '') {
        setState(() {
          validationType = ValidationType.NoValue;
        });
        return null;
      } else if (widget.validationFunc != null) {
        var validationResult = widget.validationFunc?.call(arg);
        setState(() {
          if (validationResult == null || validationResult == '') {
            validationType = ValidationType.Valid;
          } else {
            validationType = ValidationType.Invalid;
          }
        });
        return validationResult;
      } else if (widget.validation == null) {
        setState(() {
          validationType = ValidationType.Valid;
        });
        return null;
      } else if (arg.length == 0) {
        setState(() {
          validationType = ValidationType.Valid;
        });
        return null;
      } else {
        var validationResult =
            widget.validation!.hasMatch(arg) ? null : widget.validationErrorMsg;
        setState(() {
          if (validationResult == null || validationResult == '') {
            validationType = ValidationType.Valid;
          } else {
            validationType = ValidationType.Invalid;
          }
        });
        return null;
      }
    });

    textEditingController.text = widget.initialValue!;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Container(
        color: Colors.white,
        /*decoration: BoxDecoration(
          border: Border(
            bottom: widget.isWeiterBtnPressed
                ? BorderSide.none
                : BorderSide(
                    color: CustomTheme.darkGrey.withOpacity(0.5),
                  ),
          ),
          color: Colors.white,
        ),*/
        child: Padding(
          padding: const EdgeInsets.only(
            right: 8,
            left: 8,
          ),
          child: Container(
            child: Center(
              child: TextFormField(
                maxLines: 1,
                controller: textEditingController,
                onChanged: (String value) {
                  widget.callback!(value);
                },
                keyboardType: widget.keyboardType,
                validator: (String? arg) {
                  //This has to be checked
                  if (arg == null || arg == '') {
                    return null;
                  } else if (widget.validationFunc != null) {
                    var validationResult = widget.validationFunc?.call(arg);
                    return validationResult;
                  } else if (widget.validation == null) {
                    return null;
                  } else if (arg.length == 0) {
                    return null;
                  } else {
                    var validationResult =
                        widget.validation!.hasMatch(arg) ? null : '';
                    return validationResult;
                  }
                },
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(15.0),
                  letterSpacing: CustomTheme.letterSpacing,
                ),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  /*focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textEditingController.text.isEmpty ? Colors.cyan : Colors.deepOrange),
                  ),*/
                  enabledBorder: UnderlineInputBorder(
                      borderSide: widget.isWeiterBtnPressed!
                          ? BorderSide(
                              color: textEditingController.text.isEmpty
                                  ? CustomTheme.accentColor1
                                  : CustomTheme.darkGrey.withOpacity(0.5))
                          //: BorderSide.none,
                          : BorderSide(
                              color: CustomTheme.darkGrey.withOpacity(0.5))),
                  errorText: null,
                  //border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: CustomTheme.hintText),
                  suffixIcon: validationType == ValidationType.Valid
                      ? const Icon(
                          Icons.check,
                          color: CustomTheme.accentColor2,
                        )
                      : validationType == ValidationType.Invalid
                          ? const Icon(
                              Icons.clear,
                              color: Colors.red,
                            )
                          : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
