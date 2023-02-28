import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String? title;
  final bool? isPassword;
  final bool? autocorrect;
  final TextInputType? textInputType;
  final RegExp? validation;
  final Function(String)? validationFunc;
  final Function(String)? onTextChanged;
  final String? initialValue;
  final String? validationErrorMsg;

  const InputField(
      {Key? key,
      this.title,
      this.isPassword = false,
      this.textInputType = TextInputType.text,
      this.validation,
      this.autocorrect = true,
      this.onTextChanged,
      this.initialValue,
      this.validationErrorMsg,
      this.validationFunc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _InputFieldState(this.isPassword ?? false);
}

class _InputFieldState extends State<InputField> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textFocus = FocusNode();
  bool? _obscureText;

  static const color = Color(0xFF777777);

  _InputFieldState(bool? obscureText) {
    _obscureText = obscureText!;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title!,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: Dimensions.getScaledSize(13.0),
                color: color),
          ),
          SizedBox(
            height: Dimensions.getScaledSize(5.0),
          ),
          TextFormField(
            initialValue: widget.initialValue,
            obscureText: _obscureText!,
            keyboardType: widget.textInputType,
            validator: (String? arg) {
              if (widget.validationFunc != null)
                return widget.validationFunc?.call(arg!);
              else if (widget.validation == null)
                return null;
              else if (arg!.length == 0)
                return null;
              else
                return widget.validation!.hasMatch(arg)
                    ? null
                    : widget.validationErrorMsg;
            },
            onChanged: widget.onTextChanged,
            autocorrect: widget.autocorrect!,
            decoration: InputDecoration(
                border: new OutlineInputBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(0.0)),
                    borderSide: BorderSide(
                        width: 0.5, style: BorderStyle.solid, color: color)),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.getScaledSize(15.0), vertical: 0),
                fillColor: Color(0xffffff),
                filled: true,
                errorStyle: TextStyle(
                  //color: CustomTheme.yellow,
                  fontStyle: FontStyle.italic,
                ),
                suffixIcon: _passwordToggle()),
            controller: _controller,
            focusNode: _textFocus,
          ),
        ],
      ),
    );
  }

  //---------------------------------------------

  Widget? _passwordToggle() {
    if (widget.isPassword!) {
      return IconButton(
        color: color,
        icon:
            _obscureText! ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        onPressed: _toggle,
      );
    } else {
      return null;
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText!;
    });
  }

  /*void _emitChanges() {
    widget.onTextChanged(_controller.text);
  }*/
}
