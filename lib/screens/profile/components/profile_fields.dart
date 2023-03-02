import 'package:yucatan/screens/profile/profile_event_handler.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileField extends StatefulWidget {
  final Function(String)? formCallback;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? placeHolder;
  final ProfileEventHandler? eventHandler;
  final TextInputType? textInputType;
  final int? maxLength;
  final bool? isComingFromContactScreen;
  final int? lengthLimit;
  final bool? isSubmitPressed;

  const ProfileField(
      {Key? key,
      this.formCallback,
      this.lengthLimit = 50,
      this.onChanged,
      this.initialValue,
      this.placeHolder,
      this.eventHandler,
      this.textInputType,
      this.isComingFromContactScreen = false,
      this.isSubmitPressed = false,
      this.maxLength})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ProfileFieldState(initialValue!, eventHandler!);
}

class _ProfileFieldState extends State<ProfileField> {
  TextEditingController? _controller;
  var _isEnabled = false;

  _ProfileFieldState(String? initialValue, ProfileEventHandler? eventHandler) {
    this._controller = new TextEditingController(text: (initialValue ?? ''));
    eventHandler!.subscribe(_profileEventListener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: Dimensions.getScaledSize(
                widget.isComingFromContactScreen! ? 0 : 10.0),
            right: Dimensions.getScaledSize(
                widget.isComingFromContactScreen! ? 0 : 10.0),
            bottom: Dimensions.getScaledSize(5.0),
            top: Dimensions.getScaledSize(5.0)),
        child: Container(
          /*decoration: BoxDecoration(
              color: _isEnabled ? CustomTheme.disabledColor.withOpacity(0.075)  : Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.getScaledSize(5.0)),
              border: Border.all( color: CustomTheme.disabledColor.withOpacity(0.075), width: 1.0)
          ),*/
          decoration: BoxDecoration(
            //color: CustomTheme.disabledColor.withOpacity(0.075),
            //borderRadius: BorderRadius.circular(Dimensions.getScaledSize(5.0)),
            border: Border(
              bottom: BorderSide(
                //                   <--- left side
                color: CustomTheme.disabledColor.withOpacity(0.075),
                width: 1.0,
              ),
            ),
          ),
          child: TextFormField(
            inputFormatters: widget.isComingFromContactScreen!
                ? <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(widget.lengthLimit)
                  ]
                : null,
            style: TextStyle(fontSize: Dimensions.getScaledSize(15)),
            controller: _controller,
            keyboardType: widget.textInputType ?? TextInputType.text,
            maxLines: 1,
            maxLength: widget.maxLength,
            maxLengthEnforcement: widget.maxLength != null
                ? MaxLengthEnforcement.enforced
                : MaxLengthEnforcement.none,
            buildCounter: (BuildContext? context,
                {int? currentLength, int? maxLength, bool? isFocused}) {
              return null;
            },
            // hide character counter
            decoration: _getFormFieldDecoration(),
            onSaved: (String? value) {
              widget.formCallback?.call(value!);
            },
            onChanged: (String value) {
              try {
                widget.onChanged!(value);
              } catch (e) {}
            },
            enabled: widget.isComingFromContactScreen! ? true : _isEnabled,
          ),
        ));
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
    );
  }

  /// Defines how the form field looks like
  InputDecoration _getFormFieldDecoration() {
    return InputDecoration(
      isDense: true,
      // required to remove all initial (unwanted) padding
      contentPadding: EdgeInsets.only(
          top: Dimensions.getScaledSize(10.0),
          bottom: Dimensions.getScaledSize(5.0),
          left: Dimensions.getScaledSize(10.0),
          right: Dimensions.getScaledSize(10.0)),

      /* // the icon itself has a huge box around it that interferes with the removed padding
      suffixIcon: Padding(
        padding: EdgeInsets.zero,
        child: Icon(Icons.edit),
      ),*/

      hintText: widget.placeHolder,
      hintStyle: TextStyle(color: CustomTheme.disabledColor.withOpacity(0.5)),
      focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: CustomTheme.disabledColor.withOpacity(0.075)),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: widget.isSubmitPressed!
              ? BorderSide(
                  color: _controller!.text.isEmpty
                      ? CustomTheme.accentColor1
                      : CustomTheme.disabledColor.withOpacity(0.075))
              : BorderSide(
                  color: CustomTheme.disabledColor.withOpacity(0.075))),
      //border: InputBorder.none,
      /*focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,*/
    );
  }

  //---------------------------------------------

  _profileEventListener(bool isEdit) {
    this.setState(() {
      _isEnabled = isEdit;
    });
  }
}
