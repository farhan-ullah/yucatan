import 'package:yucatan/screens/authentication/components/input_field_box.dart';
import 'package:yucatan/screens/authentication/components/input_textfield.dart';
import 'package:yucatan/screens/authentication/register/components/register_validations_bloc.dart';
import 'package:yucatan/screens/authentication/register/models/details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterDetails extends StatefulWidget {
  final ValueChanged<RegisterDetailModel>? onChange;
  final RegisterValidationBloc? registerValidationBloc;
  const RegisterDetails({Key? key, this.onChange, this.registerValidationBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterDetailsState();
}

class _RegisterDetailsState extends State<RegisterDetails> {
  final RegisterDetailModel _model = RegisterDetailModel();
  @override
  Widget build(BuildContext context) {
    return InputFieldBox(
      fields: [
        InputTextField(
          registerValidationBloc: widget.registerValidationBloc,
          hintText: AppLocalizations.of(context)!.commonWords_username_required,
          validationFunc: (data) {
            if (data == null || data.length == 0 || data.length >= 5) {
              _model.isValid = true;
              widget.onChange!.call(_model);
              return null;
            }

            _model.isValid = false;
            widget.onChange!.call(_model);
            return AppLocalizations.of(context)!.commonWords_usernameInvalid;
          },
          onTextChanged: (String text) {
            _model.username = text;
            widget.onChange!.call(_model);

            if (_model.username == null ||
                _model.username.length == 0 ||
                _model.username.length >= 5) {
              _model.isValid = true;
            } else {
              _model.isValid = false;
            }
          },
        )
      ],
    );
  }
}
