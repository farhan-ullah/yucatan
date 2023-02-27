import 'package:appventure/components/colored_divider.dart';
import 'package:appventure/components/custom_app_bar.dart';
import 'package:appventure/screens/authentication/register/components/register_bloc.dart';
import 'package:appventure/screens/authentication/register/components/register_details.dart';
import 'package:appventure/screens/authentication/register/components/register_email.dart';
import 'package:appventure/screens/authentication/register/components/register_password.dart';
import 'package:appventure/screens/authentication/register/components/register_policy.dart';
import 'package:appventure/screens/authentication/register/models/details_model.dart';
import 'package:appventure/screens/authentication/register/models/password_model.dart';
import 'package:appventure/screens/authentication/register/models/policy_model.dart';
import 'package:appventure/services/response/user_login_response.dart';
import 'package:appventure/services/user_provider.dart';
import 'package:appventure/services/user_service.dart';
import 'package:appventure/size_config.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/country_utils.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/country_selection.dart';
import 'components/register_validations_bloc.dart';
import 'models/country_model.dart';
import 'models/details_email.dart';

class RegisterScreen extends StatefulWidget {
  static const route = '/register';

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterDetailModel _detailModel;
  RegisterEmailModel _emailModel;
  RegisterPasswordModel _passwordModel;
  RegisterPolicyModel _policyModel;

  CountryPhoneModel _countryPhoneModel;
  final RegisterBloc bloc = RegisterBloc();
  final registerValidationBloc = RegisterValidationBloc();
  bool isSubmitButtonPressed;

  @override
  void initState() {
    isSubmitButtonPressed = false;
    registerValidationBloc.registerSubmitButtonPressed(isSubmitButtonPressed);
    registerValidationBloc.eventSink
        .add(RegisterValidationAction.IsButtonPressed);
    _getRegisterResponse();
    _getLoadingState();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    registerValidationBloc.dispose();
    super.dispose();
  }

  void _getLoadingState() {
    bloc.getLoadingState.listen((loading) {
      switch (loading) {
        case LoadingState.START:
          hideKeyboard(context);
          showLoader(context);
          break;
        case LoadingState.STOP:
          Navigator.pop(context);
          break;
      }
    });
  }

  void _getRegisterResponse() {
    bloc.getRegisterResponse.listen((response) {
      if (response.errors != null) {
        Fluttertoast.showToast(
            msg: response.errors.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: CustomTheme.theme.primaryColorDark,
            textColor: Colors.white);
      } else {
        UserProvider.login(response.data.email, _passwordModel.password)
            .then((value) {
          Navigator.pop(context, true);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).registerScreen_title,
        appBar: AppBar(
          elevation: 0,
        ),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          AppLocalizations.of(context).registerScreen_subTitle,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.getScaledSize(16.0))),
                    ),
                    SizedBox(height: 5),
                    Text(AppLocalizations.of(context)
                        .registerScreen_dataRequiredText)
                  ],
                ),
              ),
              //AuthenticationHeader(title: 'Registrieren'),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment(0.0, 0.0),
                  margin: EdgeInsets.only(
                      top: 0,
                      left: Dimensions.getScaledSize(20.0),
                      right: Dimensions.getScaledSize(20.0)),
                  transform: Matrix4.translationValues(
                      0, Dimensions.getScaledSize(20.0), 0),
                  child: Column(
                    children: [
                      Visibility(
                        child: Column(
                          children: [
                            SizedBox(height: Dimensions.getScaledSize(10.0)),
                            usernameWidget(),
                            //SizedBox(height: Dimensions.pixels_5),
                            // _addressWidget,
                            SizedBox(height: Dimensions.getScaledSize(10.0)),
                            _emailWidget(),
                            SizedBox(height: Dimensions.getScaledSize(25.0)),
                            _countryWidget(),
                            SizedBox(height: Dimensions.getScaledSize(30.0)),
                            _passwordWidget(),
                            SizedBox(height: Dimensions.getScaledSize(20.0)),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                    text: TextSpan(
                                        text: AppLocalizations.of(context)
                                            .registerScreen_secure_password_text,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: CustomTheme.fontFamily),
                                        children: [
                                      TextSpan(
                                        text: AppLocalizations.of(context)
                                            .registerScreen_learn_more_text,
                                        style: TextStyle(
                                            color: CustomTheme.primaryColor,
                                            fontFamily: CustomTheme.fontFamily),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            return modalBottomSheetMenu();
                                          },
                                      ),
                                    ]))),
                            SizedBox(height: Dimensions.getScaledSize(15.0)),
                            _policyWidget(),
                            SizedBox(height: Dimensions.getScaledSize(25.0)),
                            _showRegisterButton(
                                context,
                                AppLocalizations.of(context)
                                    .registerScreen_start),
                            SizedBox(height: Dimensions.pixels_100),
                            // just needed to compensate for matrix transformation of the container
                          ],
                        ),
                        visible: true,
                        maintainState: true,
                      ),
                    ],
                  ),
                ),
              )),
              ColoredDivider(
                height: Dimensions.getScaledSize(3.0),
              ),
              Container(
                width: double.infinity,
                height: Dimensions.getScaledSize(60.0) +
                    MediaQuery.of(context).padding.bottom,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                color: CustomTheme.primaryColorDark,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "${AppLocalizations.of(context).registerScreen_bottomBarText1} ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.getScaledSize(15.0))),
                    RichText(
                      text: TextSpan(
                        text:
                            "${AppLocalizations.of(context).registerScreen_bottomBarText2} ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.getScaledSize(15.0)),
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)
                                  .registerScreen_bottomBarText3,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.getScaledSize(15.0),
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget usernameWidget() => RegisterDetails(
        onChange: (RegisterDetailModel model) {
          _detailModel = model;
        },
        registerValidationBloc: this.registerValidationBloc,
      );

  Widget _emailWidget() => RegisterEmail(
        onChange: (RegisterEmailModel model) {
          _emailModel = model;
        },
        registerValidationBloc: this.registerValidationBloc,
      );

  Widget _countryWidget() => CountrySelection(
      registerValidationBloc: this.registerValidationBloc,
      isComingFromProfile: true,
      countryObject: CountryUtils.getInstance().countryObject,
      onChange: (CountryPhoneModel model) {
        _countryPhoneModel = model;
        if (model.phone.isNotEmpty) {
          _countryPhoneModel.isValid = true;
        } else {
          _countryPhoneModel.isValid = false;
        }
      });

  Widget _passwordWidget() => RegisterPassword(
      onChange: (RegisterPasswordModel model) {
        _passwordModel = model;
      },
      registerValidationBloc: this.registerValidationBloc);

  Widget _policyWidget() => RegisterPolicy(
        onChange: (RegisterPolicyModel model) {
          _policyModel = model;
        },
        registerValidationBloc: this.registerValidationBloc,
      );

  void modalBottomSheetMenu() {
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: Dimensions.pixels_450,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColoredDivider(height: Dimensions.getScaledSize(3.0)),
                SizedBox(
                  height: Dimensions.getScaledSize(20.0),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        Dimensions.getScaledSize(15.0), 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.clear,
                        size: Dimensions.getScaledSize(30.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.getScaledSize(20.0),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(width / 6, 0, 0, 0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)
                              .registerScreen_securePasswordCriteria,
                          style: TextStyle(
                              color: CustomTheme.primaryColorLight,
                              fontSize: Dimensions.getScaledSize(20.0),
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.getScaledSize(10.0),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)
                              .registerScreen_minCharacters,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: CustomTheme.primaryColorDark,
                            fontSize: Dimensions.getScaledSize(15.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)
                              .registerScreen_minCapitalCharacters,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: CustomTheme.primaryColorDark,
                            fontSize: Dimensions.getScaledSize(15.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).registerScreen_minDigit,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: CustomTheme.primaryColorDark,
                            fontSize: Dimensions.getScaledSize(15.0),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)
                              .registerScreen_minSpecialCharacters,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: CustomTheme.primaryColorDark,
                            fontSize: Dimensions.getScaledSize(15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  width: double.infinity,
                  height: Dimensions.getScaledSize(56.0) +
                      MediaQuery.of(context).padding.bottom,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  color: CustomTheme.primaryColorDark,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${AppLocalizations.of(context).registerScreen_bottomBarText1} ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.getScaledSize(15.0))),
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)
                              .registerScreen_bottomBarText2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.getScaledSize(15.0)),
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context)
                                    .registerScreen_bottomBarText3,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.getScaledSize(15.0),
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performRegister(BuildContext context) async {
    if (_detailModel == null || _passwordModel == null) {
      debugPrint("Cannot register. One of the models is null!");
      return;
    }
    if (!_policyModel.isValid ||
        !_countryPhoneModel.isValid ||
        !_passwordModel.isValid ||
        !_emailModel.isValid ||
        !_detailModel.isValid) {
      return;
    }
    showLoader(context);
    //var name = _addressModel.name.split(" ");
    var loginModel = UserLoginModel();
    loginModel.email = _emailModel.email;
    loginModel.username = _detailModel.username;
    /*loginModel.lastname = _addressModel.nachName;
    loginModel.firstname = _addressModel.firstname;*/
    loginModel.phone = _countryPhoneModel.phone;
    loginModel.areaCode = _countryPhoneModel.areaCode;
    loginModel.countryISO2 = _countryPhoneModel.countryISO2Code;
    /*loginModel.street = _addressModel.street;
    loginModel.housenumber = _addressModel.houseNo;
    loginModel.zipcode = _addressModel.zipCode;
    loginModel.city = _addressModel.city;*/
    var response = await UserService.createUser(loginModel,
        _passwordModel.password.trim(), _passwordModel.passwordRepeat.trim());
    Navigator.pop(context);
    hideKeyboard(context);
    if (response.errors != null) {
      Fluttertoast.showToast(
          msg: response.errors.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: CustomTheme.theme.primaryColorDark,
          textColor: Colors.white);
    } else {
      /*Fluttertoast.showToast(
          msg: "Redirecting to previous page...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          backgroundColor: CustomTheme.theme.primaryColorDark,
          textColor: Colors.white
      );*/
      // directly login user after successful register
      UserProvider.login(response.data.email, _passwordModel.password)
          .then((value) {
        // Redirect to previous page
        Navigator.pop(context, true);
      });
    }
  }

  //---------------------------------------------

  Widget _showRegisterButton(BuildContext context, String title) {
    var button = ButtonTheme(
      minWidth: SizeConfig.screenWidth,
      child: MaterialButton(
        elevation: 0.0,
        color: CustomTheme.backgroundColor,
        textColor: CustomTheme.primaryColorDark,
        disabledColor: CustomTheme.grey,
        disabledTextColor: CustomTheme.primaryColorDark,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.getScaledSize(10.0)),
            side: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 1.0)),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.getScaledSize(10.0),
            horizontal: Dimensions.getScaledSize(20.0)),
        onPressed: () {
          // _performRegister(context);
          this.isSubmitButtonPressed = true;
          registerValidationBloc
              .registerSubmitButtonPressed(isSubmitButtonPressed);
          registerValidationBloc.eventSink
              .add(RegisterValidationAction.IsButtonPressed);
          bloc.register(_detailModel, _emailModel, _passwordModel, _policyModel,
              _countryPhoneModel);
        },
        child: Text(
          title,
          style: TextStyle(
              fontSize: Dimensions.getScaledSize(18.0),
              color: CustomTheme.primaryColorDark,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
    return button;
  }

  void showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(
                    CustomTheme.theme.primaryColorDark)),
          );
        });
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
