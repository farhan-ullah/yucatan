import 'package:yucatan/screens/authentication/components/input_textfield.dart';
import 'package:yucatan/screens/authentication/register/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterAddress extends StatefulWidget {
  final ValueChanged<RegisterAddressModel>? onChange;

  const RegisterAddress({Key? key, this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterAddressState();
}

class _RegisterAddressState extends State<RegisterAddress> {
  final RegisterAddressModel _model = new RegisterAddressModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputTextField(
          hintText: AppLocalizations.of(context)!.commonWords_name + '*',
          onTextChanged: (String text) {
            setState(() {
              //_model.firstname = text;
              _updateModelValid();
              widget.onChange!.call(_model);
            });
          },
        ),
        InputTextField(
          hintText: AppLocalizations.of(context)!.commonWords_surname + '*',
          onTextChanged: (String text) {
            setState(() {
              //_model.nachName = text;
              _updateModelValid();
              widget.onChange!.call(_model);
            });
          },
        ),
        /*InputTextField(
          hintText: 'Vor- und Nachname*',
          onTextChanged: (String text) {
            setState(() {
              _model.name = text;
              _updateModelValid();
              widget.onChange.call(_model);
            });
          },
        ),*/
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: InputTextField(
                hintText:
                    AppLocalizations.of(context)!.commonWords_street + '*',
                onTextChanged: (String text) {
                  setState(() {
                    //_model.street = text;
                    _updateModelValid();
                    widget.onChange!.call(_model);
                  });
                },
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.20,
                child: InputTextField(
                  hintText: AppLocalizations.of(context)!
                          .commonWords_number_abbreviation +
                      '*',
                  onTextChanged: (String text) {
                    setState(() {
                      // _model.houseNo = text;
                      _updateModelValid();
                      widget.onChange!.call(_model);
                    });
                  },
                ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: InputTextField(
                hintText:
                    AppLocalizations.of(context)!.commonWords_postalCode + '*',
                onTextChanged: (String text) {
                  setState(() {
                    //_model.zipCode = text;
                    _updateModelValid();
                    widget.onChange!.call(_model);
                  });
                },
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: InputTextField(
                  hintText:
                      '${AppLocalizations.of(context)!.commonWords_city}*',
                  onTextChanged: (String text) {
                    setState(() {
                      //_model.city = text;
                      _updateModelValid();
                      widget.onChange!.call(_model);
                    });
                  },
                )),
          ],
        ),
      ],
    );
  }

  void _updateModelValid() {
    /*_model.isValid =
        isNotNullOrEmpty(_model.firstname) &&
            isNotNullOrEmpty(_model.nachName)  &&
        isNotNullOrEmpty(_model.street) &&
        isNotNullOrEmpty(_model.houseNo) &&
        isNotNullOrEmpty(_model.zipCode) &&
        isNotNullOrEmpty(_model.city);*/
  }
}
