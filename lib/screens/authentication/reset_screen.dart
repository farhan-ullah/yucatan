import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'auth_regex.dart';
import 'components/input_field.dart';
import 'components/input_field_box.dart';
import 'header_fragment.dart';

class ResetScreen extends StatefulWidget {
  static const route = '/reset';
  @override
  State<StatefulWidget> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  var _showButton = false;
  var _showSpinner = false;
  var _showForm = true;
  var _resetEmailUser = '';
  var _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              AuthenticationHeader(
                  title:
                      AppLocalizations.of(context)!.resetPasswordSceen_title),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment(0.0, 0.0),
                  margin: EdgeInsets.only(
                      top: Dimensions.getScaledSize(20.0),
                      left: Dimensions.getScaledSize(20.0),
                      right: Dimensions.getScaledSize(20.0)),
                  transform: Matrix4.translationValues(
                      0, Dimensions.getScaledSize(50.0), 0),
                  child: Column(
                    children: [
                      Visibility(
                        child: InputFieldBox(
                          fields: [
                            InputField(
                              title: AppLocalizations.of(context)!
                                  .resetPasswordSceen_email_username,
                              textInputType: TextInputType.emailAddress,
                              autocorrect: false,
                              validation: AuthRegex.email,
                              validationFunc: (String arg) {
                                if (arg.length == 0) return null;
                                if (arg.contains('@') &&
                                    !AuthRegex.email.hasMatch(arg))
                                  return AppLocalizations.of(context)!
                                      .resetPasswordSceen_enter_valid_email;
                                else if (!AuthRegex.username.hasMatch(arg))
                                  return AppLocalizations.of(context)!
                                      .resetPasswordSceen_email_or_username_required;
                                else
                                  return null;
                              },
                              onTextChanged: (String text) {
                                setState(() {
                                  _resetEmailUser = text;
                                });
                              },
                            ),
                          ],
                          onValidated: (bool isValid) {
                            if (isValid) {
                              setState(() {
                                _isValid = isValid &&
                                    (AuthRegex.email
                                            .hasMatch(_resetEmailUser) ||
                                        AuthRegex.username
                                            .hasMatch(_resetEmailUser));
                                _showButton = _isValid;
                              });
                            }
                          },
                        ),
                        visible: _showForm,
                        maintainState: true,
                      ),
                      Visibility(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    CustomTheme.theme.primaryColor)),
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.getScaledSize(10.0)),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .resetPasswordSceen_reset_sent,
                                style: TextStyle(
                                    fontSize: Dimensions.getScaledSize(15.0),
                                    color: CustomTheme.theme.primaryColor),
                              ),
                            )
                          ],
                        ),
                        visible: _showSpinner,
                        maintainState: true,
                      ),
                      Visibility(
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              _showForm = false;
                              _showButton = false;
                              _showSpinner = true;
                              _performReset(context);
                            });
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .resetPasswordSceen_reset,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        visible: _showButton,
                        maintainState: true,
                      )
                    ],
                  ),
                ),
              )),
            ],
          )),
    );
  }

  void _performReset(BuildContext context) async {
    /*
      1) verify if request was successful
      2) show request successful fragment
      3) User button to go back
     */

    // TODO: implement _performReset()
  }
}
