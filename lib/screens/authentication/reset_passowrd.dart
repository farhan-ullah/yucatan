import 'package:yucatan/components/colored_divider.dart';
import 'package:yucatan/services/reset_password_service.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/DialogUtils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  static const String route = '/resetPassword';
  final String? link;
  final Function()? updateFragment;
  ResetPassword({this.link, this.updateFragment});

  @override
  _ResetPasswordState createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  bool _isHidden = true;
  bool _isPasswordHidden = true;
  String? _password, repeatPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.updateFragment!();
        //we need to return a future,Backbutton pressed (device or appbar button),
        return Future.value(false);
      },
      child: Scaffold(
          //resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                widget.updateFragment!();
                //Navigator.of(context, rootNavigator: true).pop(context);
              },
            ),
            title: Text(AppLocalizations.of(context)!.resetPasswordSceen_title),
            centerTitle: true,
            backgroundColor: CustomTheme.primaryColorDark,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: CustomTheme.primaryColorDark,
                            width: double.infinity,
                            height: Dimensions.getScaledSize(200.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      0,
                                      Dimensions.getScaledSize(20.0),
                                      0,
                                      Dimensions.getScaledSize(20.0)),
                                  width: double.infinity,
                                  height: Dimensions.getScaledSize(150.0),
                                  color: CustomTheme.primaryColorDark,
                                  child: SvgPicture.asset(
                                    'lib/assets/images/appventure_logo_neg.svg',
                                    color: Colors
                                        .white, //Does not work with .3 opacity
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .authenticationSceen_wellcome,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.getScaledSize(20.0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: Dimensions.getScaledSize(20.0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(
                                Dimensions.getScaledSize(40.0),
                                Dimensions.getScaledSize(40.0),
                                Dimensions.getScaledSize(40.0),
                                Dimensions.getScaledSize(20.0)),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    obscureText: _isHidden,
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .authenticationSceen_password,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[500]),
                                        suffix: InkWell(
                                          onTap: _togglePasswordView,
                                          child: Icon(
                                              _isHidden
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey),
                                        )),
                                    controller: passwordController,
                                    validator: (val) => val!.length < 6
                                        ? AppLocalizations.of(context)!
                                            .authenticationSceen_passwordInvalid
                                        : null,
                                    onSaved: (val) => _password = val,
                                  ),
                                  SizedBox(
                                    height: Dimensions.getScaledSize(15.0),
                                  ),
                                  TextFormField(
                                    obscureText: _isPasswordHidden,
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .authenticationSceen_confirmPassword,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[500]),
                                        suffix: InkWell(
                                          onTap: _toggleRepeatPasswordView,
                                          child: Icon(
                                              _isPasswordHidden
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey),
                                        )),
                                    controller: repeatPasswordController,
                                    validator: (val) => val!.length < 6
                                        ? AppLocalizations.of(context)!
                                            .authenticationSceen_confirmPasswordInvalid
                                        : null,
                                    onSaved: (val) => repeatPassword = val,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: InkWell(
                            onTap: validateAndSave,
                            child: Container(
                              width: Dimensions.getScaledSize(58.0),
                              height: Dimensions.getScaledSize(45.0),
                              margin: EdgeInsets.all(
                                  Dimensions.getScaledSize(15.0)),
                              padding: EdgeInsets.all(
                                  Dimensions.getScaledSize(28.0)),
                              decoration: BoxDecoration(
                                color: CustomTheme.primaryColorDark,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimensions.getScaledSize(
                                        5.0)) //                 <--- border radius here
                                    ),
                              ),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!
                                    .resetPasswordSceen_title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ColoredDivider(
                height: Dimensions.getScaledSize(3.0),
              ),
              Container(
                width: double.infinity,
                height: Dimensions.getScaledSize(60) +
                    MediaQuery.of(context).padding.bottom,
                color: CustomTheme.primaryColorDark,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        AppLocalizations.of(context)!
                            .authenticationSceen_bottomBar1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.getScaledSize(15.0))),
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!
                            .authenticationSceen_bottomBar2,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimensions.getScaledSize(15.0)),
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .authenticationSceen_bottomBar3,
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

  Future<void> validateAndSave() async {
    final FormState form = _formKey.currentState!;
    form.save();
    if (form.validate()) {
      if (_password != repeatPassword) {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!
                .authenticationSceen_confirmPasswordInvalid,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: CustomTheme.theme.primaryColorDark,
            textColor: Colors.white);
      } else {
        showLoader(context);
        String token = widget.link!.split("=").last;
        token = token.substring(0, token.length);
        var result =
            await ResetPasswordService.resetPassword(token, _password!);
        Navigator.pop(context);
        hideKeyboard(context);
        if (result.statusCode != 200) {
          showErrorMsg(result.message);
        } else {
          var dialogResult = await DialogUtils.displayDialog(
              context,
              AppLocalizations.of(context)!.authenticationSceen_forgotPassword,
              "${result.message}",
              AppLocalizations.of(context)!.actions_cancel,
              AppLocalizations.of(context)!.actions_confirm,
              showCancelButton: false,
              showOKButton: true);
          if (dialogResult != null) {
            if (dialogResult == true) widget.updateFragment!();
          }
        }
      }
    } else {
      print('Form is invalid');
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleRepeatPasswordView() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void showErrorMsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color(0xff656565).withOpacity(0.9),
        textColor: Colors.white,
        fontSize: Dimensions.getScaledSize(16.0));
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
