import 'package:yucatan/models/contact_model.dart';
import 'package:yucatan/screens/checkout_screen/components/checkout_checkbox_formfield.dart';
import 'package:yucatan/screens/impressum_datenschutz/impressum_datenschutz.dart';
import 'package:yucatan/screens/notifications/notification_view.dart';
import 'package:yucatan/screens/profile/components/profile_fields.dart';
import 'package:yucatan/services/contact_service.dart';
import 'package:yucatan/services/response/contact_response.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/services/user_provider.dart';
import 'package:yucatan/size_config.dart';
import 'package:yucatan/theme/custom_theme.dart';
import 'package:yucatan/utils/common_widgets.dart';
import 'package:yucatan/utils/network_utils.dart';
import 'package:yucatan/utils/regex_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactScreen extends StatefulWidget {
  static const String route = '/contact';
  ContactScreen();

  @override
  _ContactScreenState createState() {
    return _ContactScreenState();
  }
}

class _ContactScreenState extends State<ContactScreen> {
  UserLoginModel userLoginModel;
  var contactModel = ContactModel();
  bool isDataProtectionChecked;
  bool showSpinner = false;
  bool showBtn = true;
  bool isUserLoggedIn = false;
  bool isSubmitPressed = false;
  ScrollController _scrollController = new ScrollController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isSubmitPressed = false;
    isDataProtectionChecked = false;
    contactModel.firstname = "";
    contactModel.lastname = "";
    contactModel.phone = "";
    contactModel.email = "";
    contactModel.message = "";
    messageController.text = contactModel.message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Kontakt"),
        backgroundColor: CustomTheme.primaryColorDark,
        actions: [
          NotificationView(
            negativePadding: false,
          ),
          SizedBox(
            width: Dimensions.getScaledSize(24.0),
          ),
        ],
      ),
      body: FutureBuilder<UserLoginModel>(
        future: UserProvider.getUser(), // async work
        builder:
            (BuildContext context, AsyncSnapshot<UserLoginModel> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                this.userLoginModel = snapshot.data;
                if (userLoginModel == null) {
                  this.isUserLoggedIn = false;
                  return showContactView(false);
                } else {
                  this.isUserLoggedIn = true;
                  return showContactView(true);
                }
              }
          }
        },
      ),
    );
  }

  Widget showContactView(bool isUserLoggedIn) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          margin: EdgeInsets.fromLTRB(
            Dimensions.getScaledSize(20.0),
            Dimensions.getScaledSize(20.0),
            Dimensions.getScaledSize(20.0),
            Dimensions.getScaledSize(20.0),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUserLoggedIn
                    ? "${AppLocalizations.of(context)!.contactUserName_hallo} ${userLoginModel.username}!"
                    : '${AppLocalizations.of(context)!.contactUserName_title}!',
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(18.0),
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              SizedBox(
                height: Dimensions.getScaledSize(15.0),
              ),
              Text(
                AppLocalizations.of(context)!.contactInformation_message,
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(14.0),
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              Visibility(
                visible: showBtn,
                child: Column(
                  children: [
                    Visibility(
                      visible: isUserLoggedIn ? false : true,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dimensions.getScaledSize(30.0),
                          ),
                          ProfileField(
                            lengthLimit: 30,
                            onChanged: (value) {
                              contactModel.firstname = value;
                            },
                            initialValue: contactModel.firstname,
                            placeHolder:
                                AppLocalizations.of(context)!.contact_firstname,
                            isComingFromContactScreen: true,
                            isSubmitPressed: false,
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(20.0),
                          ),
                          ProfileField(
                            lengthLimit: 30,
                            initialValue: contactModel.lastname,
                            onChanged: (value) {
                              contactModel.lastname = value;
                            },
                            placeHolder:
                                AppLocalizations.of(context)!.contact_lastname,
                            isComingFromContactScreen: true,
                            isSubmitPressed: false,
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(20.0),
                          ),
                          ProfileField(
                            lengthLimit: 15,
                            onChanged: (value) {
                              contactModel.phone = value;
                            },
                            initialValue: contactModel.phone,
                            placeHolder:
                                AppLocalizations.of(context)!.contact_phone,
                            isComingFromContactScreen: true,
                            textInputType: TextInputType.number,
                            isSubmitPressed: false,
                          ),
                          SizedBox(
                            height: Dimensions.getScaledSize(20.0),
                          ),
                          ProfileField(
                            onChanged: (value) {
                              contactModel.email = value;
                            },
                            initialValue: contactModel.email,
                            placeHolder:
                                AppLocalizations.of(context)!.contact_email,
                            isComingFromContactScreen: true,
                            textInputType: TextInputType.emailAddress,
                            isSubmitPressed: this.isSubmitPressed,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(20.0),
                    ),
                    Container(
                      height: Dimensions.getScaledSize(270),
                      padding: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(5),
                          Dimensions.getScaledSize(10),
                          Dimensions.getScaledSize(5),
                          Dimensions.getScaledSize(10)),
                      //decoration: messageBoxDecoration(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: Dimensions.getScaledSize(250),
                        ),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: SizedBox(
                              height: Dimensions.getScaledSize(250),
                              child: TextField(
                                controller: messageController,
                                onChanged: (value) {
                                  contactModel.message = value;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(500),
                                ],
                                maxLines: 100,
                                decoration: new InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.getScaledSize(8))),
                                    borderSide: this.isSubmitPressed
                                        ? BorderSide(
                                            color:
                                                messageController.text.isEmpty
                                                    ? CustomTheme.accentColor1
                                                    : CustomTheme.disabledColor
                                                        .withOpacity(0.075),
                                            width: 1)
                                        : BorderSide(
                                            color: CustomTheme.disabledColor
                                                .withOpacity(0.075),
                                            width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.getScaledSize(8))),
                                    borderSide: BorderSide(
                                        color: CustomTheme.disabledColor
                                            .withOpacity(0.075),
                                        width: 1),
                                  ),
                                  hintText: AppLocalizations.of(context)!
                                      .contact_message,
                                  hintStyle: TextStyle(
                                    color: CustomTheme.disabledColor
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(20.0),
                    ),
                    CheckoutCheckboxFormField(
                      isComingFromContactScreen: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: isDataProtectionChecked,
                      isSubmitPressed: this.isSubmitPressed,
                      callback: handlecheckboxDataChanged,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .contact_dataprotection_text),
                          TextSpan(
                            text: AppLocalizations.of(context)!
                                .contact_dataprotection,
                            style: TextStyle(
                              color: CustomTheme.primaryColor,
                              fontFamily: CustomTheme.fontFamily,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImpressumDatenschutz(
                                      isComingFromCheckOut: true,
                                      webViewValues: WebViewValues.PRIVACY,
                                    ),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(20.0),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showSpinner,
                child: Container(
                  color: Colors.white,
                  height: Dimensions.getHeight(percentage: 64.0),
                  child: CommonWidget.showSpinner(),
                ),
              ),
              Visibility(
                visible: showBtn,
                child: showSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration messageBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: this.isSubmitPressed
          ? messageController.text.trim().isEmpty
              ? Border.all(
                  color: CustomTheme.accentColor1, // set border color
                  width: 1.0,
                )
              : Border.all(
                  color: CustomTheme.disabledColor
                      .withOpacity(0.075), // set border color
                  width: 1.0,
                )
          : Border.all(
              color: CustomTheme.disabledColor
                  .withOpacity(0.075), // set border color
              width: 1.0,
            ), // set border width
      borderRadius: BorderRadius.all(
        Radius.circular(Dimensions.getScaledSize(8)),
      ),
    );
  }

  Widget showSubmitButton() {
    return ButtonTheme(
      minWidth: SizeConfig.screenWidth,
      child: MaterialButton(
        elevation: 0.0,
        color: CustomTheme.backgroundColor,
        textColor: CustomTheme.primaryColorDark,
        disabledColor: CustomTheme.grey,
        disabledTextColor: CustomTheme.primaryColorDark,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.getScaledSize(8.0)),
            side: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 1.0)),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.getScaledSize(10.0),
            horizontal: Dimensions.getScaledSize(20.0)),
        onPressed: () async {
          setState(() {
            this.isSubmitPressed = true;
          });
          bool isNetworkAvailable = await NetworkUtils.isNetworkAvailable();
          if (isNetworkAvailable) {
            _performContact(context);
          } else {
            Fluttertoast.showToast(
              msg: "No network connection!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: CustomTheme.theme.primaryColorDark,
              textColor: Colors.white,
            );
          }
        },
        child: Text(
          AppLocalizations.of(context)!.contact_submit,
          style: TextStyle(
            fontSize: Dimensions.getScaledSize(18.0),
            color: CustomTheme.primaryColorDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  handlecheckboxDataChanged(bool value) {
    this.isDataProtectionChecked = value;
  }

  Future<void> _performContact(BuildContext context) async {
    bool isDataValidated = validateData();
    if (isDataValidated && isDataProtectionChecked) {
      messageController.text = contactModel.message;
      setState(() {
        this.showSpinner = true;
        this.showBtn = false;
      });
      ContactResponse contactResponse =
          await ContactService.sendContactQuery(contactModel, isUserLoggedIn);
      if (contactResponse != null) {
        if (contactResponse.status == 200 &&
            contactResponse.statusCodeApiRequest == 200) {
          CommonWidget.showToast(
            AppLocalizations.of(context)!.contact_api_success_msg,
          );
          resetData();
        }
      }
      setState(() {
        this.showSpinner = false;
        this.showBtn = true;
      });
    } else {
      /*CommonWidget.showToast(
          AppLocalizations.of(context)!.contact_screen_validation_text);*/
      //print("isDataValidated=$isDataValidated");
    }
  }

  /// if a user is logged in and one if a user is not logged in.
  bool validateData() {
    bool isDataValidated = false;
    if (userLoginModel != null && contactModel.message.trim().isNotEmpty) {
      isDataValidated = true;
    } else if (userLoginModel == null) {
      bool emailValid = RegexUtils.email.hasMatch(contactModel.email.trim());
      if (/*contactModel.firstname.trim().isNotEmpty &&*/
          /*contactModel.lastname.trim().isNotEmpty &&*/
          contactModel.email.trim().isNotEmpty &&
              /*contactModel.phone.trim().isNotEmpty &&*/
              contactModel.message.trim().isNotEmpty &&
              emailValid) {
        isDataValidated = true;
      } else {
        isDataValidated = false;
      }
    }
    return isDataValidated;
  }

  resetData() {
    isDataProtectionChecked = false;
    this.isSubmitPressed = false;
    /*contactModel.firstname = "";
    contactModel.lastname = "";
    contactModel.phone = "";*/
    contactModel.email = "";
    contactModel.message = "";
    messageController.text = "";
  }
}
