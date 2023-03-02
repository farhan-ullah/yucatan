import 'package:yucatan/screens/authentication/components/input_field_box.dart';
import 'package:yucatan/screens/authentication/components/input_textfield.dart';
import 'package:yucatan/screens/authentication/register/models/country_model.dart';
import 'package:yucatan/services/response/user_login_response.dart';
import 'package:yucatan/utils/StringUtils.dart';
import 'package:yucatan/utils/country_utils.dart';
import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yucatan/screens/authentication/register/components/register_validations_bloc.dart';
import '../../auth_regex.dart';

class CountrySelection extends StatefulWidget {
  final ValueChanged<CountryPhoneModel>? onChange;
  final UserLoginModel? userLoginModel;
  final CountryObject? countryObject;
  final String? phone;
  final bool? isComingFromProfile;
  final RegisterValidationBloc? registerValidationBloc;

  CountrySelection({
    Key? key,
    this.onChange,
    this.countryObject,
    this.phone = "",
    this.userLoginModel,
    this.isComingFromProfile = false,
    this.registerValidationBloc,
  });

  @override
  State<StatefulWidget> createState() => _CountrySelectionState();
}

class _CountrySelectionState extends State<CountrySelection> {
  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>>? key = GlobalKey();
  bool showWhichErrorText = false;
  String defaultPhoneValue = "+49";
  String defaultFlagValue = "DE";
  final _model = CountryPhoneModel();

  @override
  void initState() {
    super.initState();
    if (widget.userLoginModel != null) {
      defaultPhoneValue = widget.userLoginModel!.areaCode;
      _model.areaCode = widget.userLoginModel!.areaCode;
      _model.countryISO2Code = widget.userLoginModel!.countryISO2;
      _model.countryISO2Name = widget.countryObject!.countryList
          .firstWhere(
              (element) =>
                  element.country.toLowerCase() ==
                  _model.countryISO2Code!.toLowerCase(),
              orElse: () => CountryData('', ''))
          .countryName;

      _model.phone = (widget.phone == null ? "" : widget.phone)!;

      var flagValue = widget.countryObject!.jsonPhoneMap.keys.firstWhere(
          (k) => widget.countryObject!.jsonPhoneMap[k] == defaultPhoneValue,
          orElse: () => "DE");

      defaultFlagValue = flagValue;
    } else {
      _model.areaCode = defaultPhoneValue;
      _model.countryISO2Code = "DE";
      _model.countryISO2Name = "Deutschland";
      _model.phone = "";
    }
    widget.onChange!.call(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Dimensions.pixels_10, Dimensions.pixels_5, Dimensions.pixels_10, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(Dimensions.pixels_5, 0, 0, 0),
            child: SimpleAutoCompleteTextField(
              key: key!,
              decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context)!.commonWords_land_required,
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30,
                  )),
              controller: TextEditingController(text: _model.countryISO2Name),
              suggestions: widget.countryObject!.countryList2,
              textChanged: (text) => currentText = text,
              clearOnSubmit: false,
              submitOnSuggestionTap: true,
              textSubmitted: (text) {
                _model.countryISO2Name = text;
                CountryData findCountry(String countryName) {
                  return widget.countryObject!.countryList
                      .firstWhere((country) => country.countryName == text);
                }

                setState(() {
                  String country = findCountry(text).country;

                  this.defaultPhoneValue =
                      widget.countryObject!.jsonPhoneMap[country];
                  this.defaultFlagValue = country;
                  _model.areaCode = widget.countryObject!.jsonPhoneMap[country];
                  _model.countryISO2Code = country;

                  widget.onChange!.call(_model);
                });
              },
            ),
          ),
          Row(
            children: [
              Container(
                width: Dimensions.getWidth(percentage: 25.0),
                margin: EdgeInsets.fromLTRB(Dimensions.pixels_5,
                    Dimensions.pixels_10, 0, Dimensions.pixels_10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton<String>(
                    key: UniqueKey(),
                    iconSize: 0.0,
                    underline: Container(
                      width: 0,
                      height: 0,
                    ),
                    isExpanded: true,
                    iconEnabledColor: Colors.white,
                    iconDisabledColor: Colors.white,
                    value: isNotNullOrEmpty(defaultPhoneValue)
                        ? defaultPhoneValue
                        : "+49",
                    selectedItemBuilder: (BuildContext context) {
                      return widget.countryObject!.countryPhoneList
                          .map<Widget>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              // Flag(
                              //   defaultFlagValue,
                              //   width: Dimensions.getScaledSize(32),
                              //   height: Dimensions.getScaledSize(22),
                              //   fit: BoxFit.fill,
                              // ),
                              Expanded(
                                child: Text(
                                  value.contains("+") ? value : "+$value",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: widget.isComingFromProfile!
                                      ? TextStyle(
                                          fontSize:
                                              Dimensions.getScaledSize(15),
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    items: widget.countryObject!.countryPhoneList
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.contains("+") ? value : "+$value",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: widget.isComingFromProfile!
                              ? TextStyle(
                                  fontSize: Dimensions.getScaledSize(15),
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      setState(() {
                        this.defaultPhoneValue = val!;
                        var flagValue = widget.countryObject!.jsonPhoneMap.keys
                            .firstWhere(
                                (k) =>
                                    widget.countryObject!.jsonPhoneMap[k] ==
                                    val,
                                orElse: () => "DE");
                        defaultFlagValue = flagValue;
                        _model.areaCode = defaultPhoneValue;
                        widget.onChange!.call(_model);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: InputFieldBox(
                  fields: [
                    InputTextField(
                        registerValidationBloc:
                            widget.registerValidationBloc == null
                                ? null
                                : widget.registerValidationBloc,
                        showUnderline: false,
                        isComingFromCheckout: true,
                        phoneNumberValue: widget.phone,
                        isProfilePhoneNumber: true,
                        hintText: AppLocalizations.of(context)!
                            .commonWords_phone_required,
                        textInputType: TextInputType.number,
                        validationErrorMsg: AppLocalizations.of(context)!
                            .commonWords_phoneInvalid,
                        validation:
                            _model.phone == null || _model.phone!.isEmpty
                                ? AuthRegex.emptyValue
                                : null,
                        autocorrect: false,
                        onTextChanged: (String text) {
                          _model.phone = text;
                          widget.onChange!.call(_model);
                        }),
                  ],
                  onValidated: (bool isValid) {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
