import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static Future<bool> displayForgotDialog(BuildContext context, String title,
      String body, String buttonText1, String buttonText2,
      {bool showOKButton, bool showCancelButton}) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: ButtonBarTheme(
            data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_outlined,
                    color: CustomTheme.accentColor2,
                    size: 35,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomTheme.accentColor2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: Text(
                body,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Visibility(
                        visible: showOKButton,
                        child: MaterialButton(
                          minWidth: 150.0,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: CustomTheme.primaryColorDark,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            buttonText2,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          textColor: CustomTheme.primaryColorDark,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            // true here means you clicked ok
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> displayDialog(BuildContext context, String title,
      String body, String buttonText1, String buttonText2,
      {bool showOKButton, bool showCancelButton}) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              body,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Visibility(
                visible: showCancelButton,
                child: new TextButton(
                  child: new Text(
                    buttonText1,
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
              Visibility(
                visible: showOKButton,
                child: new TextButton(
                  child: Text(
                    buttonText2,
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    // true here means you clicked ok
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> displayDeniedBookingInfoDialog(BuildContext context,
      String title, String body, String buttonText1) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            title: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      }),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomTheme.accentColor1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            content: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Text(
                    body,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(true);
                      // true here means you clicked ok
                    },
                    child: Container(
                      width: 130,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: CustomTheme.accentColor1.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          buttonText1,
                          style: TextStyle(
                            fontSize: 18,
                            color: CustomTheme.accentColor1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
