import 'package:yucatan/screens/authentication/components/input_field_box.dart';
import 'package:yucatan/screens/authentication/components/input_textfield.dart';
import 'package:yucatan/screens/authentication/register/components/register_validations_bloc.dart';
import 'package:yucatan/screens/authentication/register/models/details_email.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../auth_regex.dart';

class RegisterEmail extends StatefulWidget {
  final ValueChanged<RegisterEmailModel>? onChange;
  final RegisterValidationBloc? registerValidationBloc;
  const RegisterEmail({Key? key, this.onChange, this.registerValidationBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final RegisterEmailModel _model = RegisterEmailModel();

  @override
  Widget build(BuildContext context) {
    return InputFieldBox(
      fields: [
        InputTextField(
            //title: 'E-Mail-Adresse*',
            registerValidationBloc: widget.registerValidationBloc,
            hintText:
                '${AppLocalizations.of(context)!.authenticationSceen_email}*',
            textInputType: TextInputType.emailAddress,
            validation: AuthRegex.email,
            validationErrorMsg:
                AppLocalizations.of(context)!.authenticationSceen_emailInvalid,
            autocorrect: false,
            onTextChanged: (String text) {
              _model.email = text;
              widget.onChange!.call(_model);
              bool isEmail = text.contains(AuthRegex.email);
              if (isEmail) {
                _model.isValid = true;
              } else {
                _model.isValid = false;
              }
            }),
      ],
      onValidated: (bool isValid) {
        _model.isValid = isValid;
        widget.onChange!.call(_model);
      },
    );
  }
}
