import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/models/transaction_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class TransactionSingleResponseEntity
    with JsonConvert<TransactionSingleResponseEntity> {
  int? status;
  TransactionModel? data;
  ApiError? errors;
}
