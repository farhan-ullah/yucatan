import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InputCheckbox extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(bool)? onChanged;

  const InputCheckbox(
      {Key? key, required this.title, this.subtitle = "", this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputCheckboxState();
}

class _InputCheckboxState extends State<InputCheckbox> {
  var _checked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _checked,
              onChanged: (bool? value) {
                setState(() {
                  _checked = value!;
                  widget.onChanged?.call(value);
                });
              },
              activeColor: CustomTheme.accentColor2,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
            )
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: Dimensions.getScaledSize(15.0)),
          child: Text(
            widget.subtitle,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              fontSize: Dimensions.getScaledSize(12.0),
              //color: Colors.white70
            ),
          ),
        )
      ],
    );
  }
}
