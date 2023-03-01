import 'package:yucatan/screens/authentication/components/input_checkbox_rich.dart';
import 'package:yucatan/screens/authentication/components/input_field_box.dart';
import 'package:yucatan/screens/authentication/register/components/register_validations_bloc.dart';
import 'package:yucatan/screens/authentication/register/models/policy_model.dart';
import 'package:yucatan/screens/impressum_datenschutz/impressum_datenschutz.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPolicy extends StatefulWidget {
  final ValueChanged<RegisterPolicyModel>? onChange;
  final RegisterValidationBloc? registerValidationBloc;
  const RegisterPolicy({Key? key, this.onChange, this.registerValidationBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPolicyState();
}

class _RegisterPolicyState extends State<RegisterPolicy> {
  final _model = RegisterPolicyModel();

  @override
  Widget build(BuildContext context) {
    return InputFieldBox(
        fields: [
          InputCheckboxRich(
            registerValidationBloc: widget.registerValidationBloc,
            text: TextSpan(children: [
              TextSpan(
                  text: AppLocalizations.of(context)!.commonWords_AGBpolicy1),
              TextSpan(
                text: AppLocalizations.of(context)!.commonWords_AGBpolicy2,
                style: TextStyle(
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
            onChanged: (bool checked) {
              _model.tosAccepted = checked;
              _model.isValid = _model.tosAccepted && _model.privacyAccepted;
              widget.onChange!.call(_model);
            },
          ),
          InputCheckboxRich(
            registerValidationBloc: widget.registerValidationBloc,
            text: TextSpan(children: [
              TextSpan(
                  text: AppLocalizations.of(context)!.commonWords_DSpolicy1),
              TextSpan(
                text: AppLocalizations.of(context)!.commonWords_DSpolicy2,
                style: TextStyle(
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
              TextSpan(
                  text: AppLocalizations.of(context)!.commonWords_DSpolicy3)
            ]),
            onChanged: (bool checked) {
              _model.privacyAccepted = checked;
              _model.isValid = _model.tosAccepted && _model.privacyAccepted;
              widget.onChange!.call(_model);
            },
          ),
        ],
        onValidated: (bool isValid) {
          setState(() {
            debugPrint("onValidated RP");
            _model.isValid =
                isValid && _model.tosAccepted && _model.privacyAccepted;
            widget.onChange!.call(_model);
          });
        });
  }
}
