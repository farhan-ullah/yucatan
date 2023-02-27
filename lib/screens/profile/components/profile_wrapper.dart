import 'package:appventure/screens/authentication/register/components/country_selection.dart';
import 'package:appventure/screens/authentication/register/models/country_model.dart';
import 'package:appventure/screens/profile/bloc/profile_bloc.dart';
import 'package:appventure/screens/profile/components/profile_fields.dart';
import 'package:appventure/screens/profile/components/profile_header.dart';
import 'package:appventure/screens/profile/profile_event_handler.dart';
import 'package:appventure/services/response/user_login_response.dart';
import 'package:appventure/size_config.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/country_utils.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileWrapper extends StatefulWidget {
  final UserLoginModel model;

  const ProfileWrapper({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileWrapperState();
}

class _ProfileWrapperState extends State<ProfileWrapper> {
  final _formKey = GlobalKey<FormState>();
  final _eventHandler = ProfileEventHandler();
  bool showSpinner = false;
  bool showBtn = true;
  UserLoginModel
      _internalModel; // used to store values of the fields that will be passe to the service
  var countryWidget;
  CountryPhoneModel _countryPhoneModel;
  ProfileBloc bloc = ProfileBloc();

  _ProfileWrapperState() {
    _eventHandler.subscribe(_profileEventListener);
  }

  @override
  void initState() {
    _getUpdateResponse();
    super.initState();
  }

  void _getUpdateResponse() {
    bloc.resultStream.listen((result) {
      Fluttertoast.showToast(
          msg: result == null ? "Erfolgreich gespeichert" : "${result.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: CustomTheme.theme.primaryColorDark,
          textColor: Colors.white);

      if (result == null && _internalModel != null) {
        bloc.setUserStream = _internalModel;
      }
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: Dimensions.getScaledSize(20.0),
          //bottom: Dimensions.getScaledSize(20.0),
          left: Dimensions.getScaledSize(15.0),
          right: Dimensions.getScaledSize(15.0),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: StreamBuilder<UserLoginModel>(
              stream: bloc.userStream,
              builder: (context, snapshot) {
                UserLoginModel userModel = snapshot.data ?? widget.model;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(
                        model: userModel, eventHandler: _eventHandler),
                    SizedBox(
                      height: Dimensions.getScaledSize(40.0),
                    ),
                    ProfileField(
                        initialValue: "${userModel.username ?? ''}",
                        placeHolder: "Benutzername",
                        formCallback: this._usernameCallback,
                        eventHandler: _eventHandler),
                    SizedBox(
                      height: Dimensions.getScaledSize(10.0),
                    ),
                    ProfileField(
                        initialValue: userModel.email,
                        placeHolder: 'E-Mail Adresse',
                        textInputType: TextInputType.emailAddress),
                    SizedBox(
                      height: Dimensions.getScaledSize(10.0),
                    ),
                    ProfileField(
                        initialValue: userModel.lastname,
                        placeHolder: "Nachname",
                        formCallback: this._lastnameCallback,
                        eventHandler: _eventHandler),
                    SizedBox(
                      height: Dimensions.getScaledSize(10.0),
                    ),
                    ProfileField(
                        initialValue: userModel.firstname,
                        placeHolder: "Vorname",
                        formCallback: this._firstnameCallback,
                        eventHandler: _eventHandler),
                    SizedBox(
                      height: Dimensions.getScaledSize(10.0),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: ProfileField(
                              initialValue: userModel.street,
                              placeHolder: 'Straße',
                              formCallback: this._streetCallback,
                              eventHandler: _eventHandler),
                        ),
                        Expanded(
                            flex: 5,
                            child: ProfileField(
                                initialValue: userModel.housenumber,
                                placeHolder: 'Nr.',
                                formCallback: this._houseNrCallback,
                                eventHandler: _eventHandler)),
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.getScaledSize(10.0),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: ProfileField(
                              initialValue: userModel.zipcode,
                              placeHolder: 'PLZ',
                              formCallback: this._zipCodeCallback,
                              eventHandler: _eventHandler,
                              textInputType: TextInputType.number,
                              maxLength: 5),
                        ),
                        Expanded(
                            flex: 5,
                            child: ProfileField(
                                initialValue: userModel.city,
                                placeHolder: 'Ort',
                                formCallback: this._cityCallback,
                                eventHandler: _eventHandler)),
                      ],
                    ),
                    /*BlackDivider(
                    height: Dimensions.getScaledSize(1.0),
                  ),*/
                    SizedBox(
                      height: Dimensions.getScaledSize(10.0),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(10.0),
                          Dimensions.getScaledSize(20.0),
                          Dimensions.getScaledSize(10.0),
                          0),
                      child: CountrySelection(
                        isComingFromProfile: true,
                        countryObject: CountryUtils.getInstance().countryObject,
                        phone: userModel.phone,
                        onChange: (CountryPhoneModel model) {
                          _countryPhoneModel = model;
                          if (model.phone.isNotEmpty) {
                            _countryPhoneModel.isValid = true;
                          } else {
                            _countryPhoneModel.isValid = false;
                          }
                        },
                        userLoginModel: userModel,
                      ),
                    ),
                    StreamBuilder<bool>(
                        stream: bloc.showProgressStream,
                        builder: (context, snapshotProgress) {
                          return Visibility(
                            visible: snapshotProgress.data ?? false,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(18.0),
                                  right: Dimensions.getScaledSize(18.0),
                                  top: Dimensions.getScaledSize(20.0)),
                              child: Center(
                                child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            CustomTheme.theme.primaryColor)),
                              ),
                            ),
                          );
                        }),
                    StreamBuilder<bool>(
                        stream: bloc.showButtonStream,
                        builder: (context, snapshotButton) {
                          return Visibility(
                            visible: snapshotButton.data ?? true,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: Dimensions.getScaledSize(18.0),
                                  right: Dimensions.getScaledSize(18.0),
                                  top: Dimensions.getScaledSize(15.0)),
                              child: ButtonTheme(
                                minWidth: SizeConfig.screenWidth,
                                // ignore: deprecated_member_use
                                child: ElevatedButton(
                                  // elevation: 0,
                                  // color: Colors.white,
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(5.0),
                                  //     side: BorderSide(
                                  //         color: CustomTheme.primaryColorDark)),
                                  onPressed: () {
                                    _submitForm();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .profile_save_button,
                                    style: TextStyle(
                                        color: CustomTheme.primaryColorDark,
                                        fontSize: Dimensions.getScaledSize(18)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                );
              }),
        ),
      ),
    );
  }

  //---------------------------------------------

  _firstnameCallback(String firstname) {
    _internalModel.firstname = firstname;
  }

  _lastnameCallback(String lastname) {
    _internalModel.lastname = lastname;
  }

  _usernameCallback(String username) {
    _internalModel.username = username;
  }

  // currently made email read-only hence this will stay here for now
  // ignore: unused_element
  _emailCallback(String email) {
    _internalModel.email = email;
  }

  /*_phoneCallback(String phone) {
    _internalModel.phone = phone;
  }*/

  _streetCallback(String street) {
    _internalModel.street = street;
  }

  _houseNrCallback(String nr) {
    _internalModel.housenumber = nr;
  }

  _zipCodeCallback(String zipCode) {
    _internalModel.zipcode = zipCode;
  }

  _cityCallback(String city) {
    _internalModel.city = city;
  }

  _profileEventListener(bool isEdit) {
    debugPrint(isEdit ? "switching to EDIT" : "switching to DEFAULT");
    // this.setState(() {});
  }

  /*_resetForm() {
    this.setState(() {
      _eventHandler.broadcastState(false);
      _formKey.currentState?.reset();
    });
  }*/

  _submitForm() async {
    if (!_countryPhoneModel.isValid) {
      return;
    }
    // _eventHandler.broadcastState(false);
    _internalModel = new UserLoginModel();
    _internalModel.phone = _countryPhoneModel.phone;
    _internalModel.areaCode = _countryPhoneModel.areaCode;
    _internalModel.countryISO2 = _countryPhoneModel.countryISO2Code;
    _internalModel.email = widget.model.email; // email must always be set
    _formKey.currentState?.save();

    bloc.updateProfile(_internalModel);

    _eventHandler?.broadcastUsernameState(_internalModel.username);
  }
}
