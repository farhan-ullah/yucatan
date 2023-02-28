import 'package:yucatan/screens/authentication/register/components/register_validations_bloc.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InputCheckboxRich extends StatefulWidget {
  final TextSpan text;
  final Function(bool)? onChanged;
  final RegisterValidationBloc? registerValidationBloc;
  const InputCheckboxRich(
      {Key? key,
      required this.text,
      this.onChanged,
      this.registerValidationBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputCheckboxRichState();
}

class _InputCheckboxRichState extends State<InputCheckboxRich> {
  var _checked = false;
  bool isRegisterSubmitButtonPressed = false;
  @override
  void initState() {
    if (widget.registerValidationBloc != null) {
      widget.registerValidationBloc!.registerValidationStream
          .listen((bool event) {
        if (event == true) {
          setState(() {
            this.isRegisterSubmitButtonPressed = event;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Theme(
              data: ThemeData(
                unselectedWidgetColor: getColorValue(),
                //unselectedWidgetColor: isRegisterSubmitButtonPressed && _checked ? CustomTheme.accentColor2 : CustomTheme.accentColor1
              ),
              child: Checkbox(
                value: _checked,
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value!;
                    widget.onChanged?.call(value);
                  });
                },
                activeColor: CustomTheme.primaryColorLight,
              ),
            ),
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    overflow: TextOverflow.clip,
                    text: TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: CustomTheme.fontFamily),
                        children: [widget.text]),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  getColorValue() {
    Color? color;
    if (!this.isRegisterSubmitButtonPressed) {
      color = CustomTheme.darkGrey;
    } else if (this.isRegisterSubmitButtonPressed && !_checked) {
      color = CustomTheme.accentColor1;
    }
    return color;
  }
}
