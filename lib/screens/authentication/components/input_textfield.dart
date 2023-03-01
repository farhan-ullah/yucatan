import 'package:yucatan/screens/authentication/register/components/register_validations_bloc.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth_regex.dart';

class InputTextField extends StatefulWidget {
  final String? title;
  final bool? isPassword;
  final bool? isComingFromCheckout;
  final bool? autocorrect;
  final TextInputType? textInputType;
  final RegExp? validation;
  final Function(String)? validationFunc;
  final Function(String)? onTextChanged;
  final String? initialValue;
  final String? validationErrorMsg;
  final String? hintText;
  final bool? showUnderline;
  final bool? showHelpIcon;
  final bool? enable;
  final bool? isProfilePhoneNumber;
  final String? phoneNumberValue;
  final RegisterValidationBloc? registerValidationBloc;

  const InputTextField(
      {Key? key,
      this.title,
      this.registerValidationBloc,
      this.hintText,
      this.isPassword = false,
      this.textInputType = TextInputType.text,
      this.isComingFromCheckout = false,
      this.validation,
      this.autocorrect = true,
      this.onTextChanged,
      this.initialValue,
      this.enable = false,
      this.validationErrorMsg,
      this.showUnderline = true,
      this.showHelpIcon = true,
      this.isProfilePhoneNumber = false,
      this.phoneNumberValue = "",
      this.validationFunc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _InputTextFieldState(this.isPassword ?? false);
}

class _InputTextFieldState extends State<InputTextField> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool? _obscureText;
  static const color = Color(0xFF777777);
  bool? isRegisterSubmitButtonPressed = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _InputTextFieldState(bool? obscureText) {
    _obscureText = obscureText;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isProfilePhoneNumber!) {
      _controller.text = widget.phoneNumberValue!;
    }
    if (widget.registerValidationBloc != null) {
      widget.registerValidationBloc!.registerValidationStream
          .listen((bool? event) {
        if (event == true) {
          this.isRegisterSubmitButtonPressed = event;
          validate();
        }
        //print("---InputTextField---=${event} and ${_controller.text} and ${widget.initialValue}");
      });
    }
  }

  void validate() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      //print('Form is valid');
    } else {
      //print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    //_controller.addListener(_emitChanges);
    //_textFocus.addListener(_emitChanges);

    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.getScaledSize(10.0),
        bottom: Dimensions.getScaledSize(10.0),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              //textAlign: TextAlign.center,
              readOnly: widget.enable! ? true : false,
              //enabled: widget.enable ? true : false,
              initialValue: widget.initialValue,
              obscureText: _obscureText!,
              keyboardType: widget.textInputType,
              validator: (String? arg) {
                //print("--validator--arg=${arg} and ${isRegisterSubmitButtonPressed}");
                if (isRegisterSubmitButtonPressed == false) {
                  return null;
                }
                if (widget.validationFunc != null) {
                  return widget.validationFunc?.call(arg!);
                } else if (widget.validation == null) {
                  return null;
                } else if (arg!.length == 0) {
                  return widget.validationErrorMsg;
                } else {
                  if (widget.isPassword!) {
                    bool? isPasswordCompliant =
                        AuthRegex.isPasswordCompliant(arg.trim());
                    return isPasswordCompliant
                        ? null
                        : widget.validationErrorMsg;
                  } else {
                    return widget.validation!.hasMatch(arg)
                        ? null
                        : widget.validationErrorMsg;
                  }
                }
              },
              onChanged: widget.onTextChanged,
              autocorrect: widget.autocorrect!,
              controller: _controller,
              focusNode: _textFocus,
              style: widget.isComingFromCheckout!
                  ? TextStyle(fontSize: Dimensions.getScaledSize(15))
                  : null,
              textAlignVertical:
                  widget.isPassword! ? TextAlignVertical.center : null,
              decoration: InputDecoration(
                  errorMaxLines: 4,
                  contentPadding: EdgeInsets.fromLTRB(
                      Dimensions.getScaledSize(5.0), 0, 0, 0),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: CustomTheme.hintText),
                  border: widget.showUnderline!
                      ? null
                      : const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                  errorStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                  suffixIcon: widget.enable!
                      ? arrowIcon()
                      : widget.showHelpIcon!
                          ? _passwordToggle()
                          : helpIcon()),
            ),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------

  Widget _passwordToggle() {
    if (widget.isPassword!) {
      return IconButton(
        color: color,
        icon: _obscureText!
            ? const Icon(Icons.visibility, size: 20)
            : const Icon(Icons.visibility_off, size: 20),
        onPressed: _toggle,
      );
    } else
      return SizedBox();
  }

  Widget helpIcon() {
    return Icon(
      Icons.help,
      size: Dimensions.getScaledSize(10.0),
    );
  }

  Widget arrowIcon() {
    return const Icon(
      Icons.keyboard_arrow_down_sharp,
      size: 32,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText!;
    });
  }
}
