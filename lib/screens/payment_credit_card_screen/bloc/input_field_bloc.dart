import 'dart:async';

import 'package:yucatan/screens/payment_credit_card_screen/components/payment_credit_card_screen_view.dart';

class InputFieldBloc {
  final _validationController = StreamController<ValidationType>();
  final _borderController = StreamController<bool>();

  Stream<ValidationType> get validationStream => _validationController.stream;

  set validation(ValidationType validationType) =>
      _validationController.sink.add(validationType);

  Stream<bool> get showBorderStream => _borderController.stream;

  set showBorder(bool value) => _borderController.sink.add(value);

  dispose() {
    _validationController.close();
    _borderController.close();
  }
}
