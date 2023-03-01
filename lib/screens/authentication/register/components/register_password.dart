import 'package:yucatan/screens/authentication/register/bloc/password_bloc.dart';
import 'package:yucatan/screens/authentication/register/components/register_validations_bloc.dart';
import 'package:yucatan/screens/authentication/register/models/password_model.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../auth_regex.dart';

class RegisterPassword extends StatefulWidget {
  final ValueChanged<RegisterPasswordModel>? onChange;
  final RegisterValidationBloc? registerValidationBloc;
  const RegisterPassword({Key? key, this.onChange, this.registerValidationBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword> {
  final _model = RegisterPasswordModel();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();
  bool _obscureText = false;
  bool _obscurePasswordRepeatText = false;
  PasswordBloc bloc = PasswordBloc();
  bool isRegisterSubmitButtonPressed = false;

  @override
  void initState() {
    if (widget.registerValidationBloc != null) {
      widget.registerValidationBloc!.registerValidationStream
          .listen((bool event) {
        if (event == true) {
          this.isRegisterSubmitButtonPressed = event;
          _formKey.currentState!.validate();
        }
      });
    }
    super.initState();
  }

  void _toggle() {
    bloc.setToggle = !_obscureText;
  }

  void _togglePasswordRepeat() {
    bloc.setToggle2 = !_obscurePasswordRepeatText;
  }

  static const color = Color(0xFF777777);

  Widget _passwordToggle() {
    return IconButton(
      color: color,
      icon: _obscureText
          ? Icon(Icons.visibility_off, size: 20)
          : Icon(Icons.visibility, size: 20),
      onPressed: _toggle,
    );
  }

  Widget _passwordRepeatToggle() {
    return IconButton(
      color: color,
      icon: _obscurePasswordRepeatText
          ? Icon(Icons.visibility_off, size: 20)
          : Icon(Icons.visibility, size: 20),
      onPressed: _togglePasswordRepeat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimensions.getScaledSize(10.0),
          Dimensions.getScaledSize(5.0), Dimensions.getScaledSize(10.0), 0),
      decoration: BoxDecoration(
          color: Color(0xFFf8f8f8),
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Dimensions.getScaledSize(10.0)),
                StreamBuilder<bool>(
                    stream: bloc.toggleStream,
                    builder: (context, snapshot) {
                      _obscureText = snapshot.data ?? true;
                      return TextFormField(
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (String? arg) {
                          if (isRegisterSubmitButtonPressed == false) {
                            return null;
                          }
                          bool isPasswordCompliant =
                              AuthRegex.isPasswordCompliant(arg!);
                          return isPasswordCompliant
                              ? null
                              : AppLocalizations.of(context)!
                                  .registerPassword_validation_msg;
                        },
                        onChanged: (String text) {
                          _model.password = text;

                          if (isRegisterSubmitButtonPressed)
                            _model.isValid = _formKey.currentState!.validate();
                          widget.onChange!.call(_model);
                        },
                        controller: _passwordController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          errorMaxLines: 4,
                          contentPadding: EdgeInsets.fromLTRB(
                              Dimensions.getScaledSize(5.0), 0, 0, 0),
                          hintText: AppLocalizations.of(context)!
                              .authenticationSceen_password,
                          hintStyle: TextStyle(color: CustomTheme.hintText),
                          errorStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                          suffixIcon: _passwordToggle(),
                        ),
                      );
                    }),
                SizedBox(height: Dimensions.getScaledSize(20.0)),
                StreamBuilder<bool>(
                    stream: bloc.toggle2Stream,
                    builder: (context, snapshot) {
                      _obscurePasswordRepeatText = snapshot.data ?? true;
                      return TextFormField(
                        obscureText: _obscurePasswordRepeatText,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (String? arg) {
                          if (isRegisterSubmitButtonPressed == false) {
                            return null;
                          }
                          if (isRegisterSubmitButtonPressed && arg!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .authenticationSceen_confirmPasswordInvalid;
                          } else {
                            return _passwordController.text == arg
                                ? null
                                : AppLocalizations.of(context)!
                                    .authenticationSceen_confirmPasswordInvalid;
                          }
                        },
                        onChanged: (String text) {
                          _model.passwordRepeat = text;
                          if (isRegisterSubmitButtonPressed)
                            _model.isValid = _formKey.currentState!.validate();
                          widget.onChange!.call(_model);
                        },
                        controller: _passwordRepeatController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            errorMaxLines: 4,
                            contentPadding: EdgeInsets.fromLTRB(
                                Dimensions.getScaledSize(5.0), 0, 0, 0),
                            hintText: AppLocalizations.of(context)!
                                .authenticationSceen_confirmPassword,
                            hintStyle: TextStyle(color: CustomTheme.hintText),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                            suffixIcon: _passwordRepeatToggle()),
                      );
                    }),
                SizedBox(height: Dimensions.getScaledSize(10.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
