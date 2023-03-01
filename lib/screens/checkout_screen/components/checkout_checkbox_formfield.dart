import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutCheckboxFormField extends FormField<bool> {
  CheckoutCheckboxFormField(
      {TextSpan? text,
      bool initialValue = false,
      bool isComingFromContactScreen = false,
      bool isSubmitPressed = false,
      AutovalidateMode? autovalidateMode,
      Function? callback})
      : super(
          autovalidateMode: autovalidateMode,
          initialValue: initialValue,
          validator: (value) {
            if (!value!) return "error";
            return null;
          },
          builder: (FormFieldState<bool> state) {
            return Row(
              crossAxisAlignment: isComingFromContactScreen
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isComingFromContactScreen
                    ? Theme(
                        data: ThemeData(
                            //unselectedWidgetColor: CustomTheme.disabledColor.withOpacity(0.3),
                            unselectedWidgetColor: isSubmitPressed
                                ? CustomTheme.accentColor1
                                : CustomTheme.disabledColor.withOpacity(0.3)),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 12,
                            right: 12,
                            bottom: 12,
                          ),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: state.value,
                              activeColor: CustomTheme.primaryColorLight,
                              onChanged: (value) {
                                callback!(value);
                                state.didChange(value);
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(
                          top: 12,
                          right: 12,
                          bottom: 12,
                        ),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            activeColor: CustomTheme.primaryColorLight,
                            value: state.value,
                            onChanged: (value) {
                              callback!(value);
                              state.didChange(value);
                            },
                          ),
                        ),
                      ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: isComingFromContactScreen ? 10 : 0),
                        child: RichText(
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                              style: TextStyle(
                                  color: isComingFromContactScreen
                                      ? CustomTheme.disabledColor
                                          .withOpacity(0.8)
                                      : Colors.black,
                                  fontFamily: CustomTheme.fontFamily),
                              children: [text!]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
}
