import 'package:yucatan/models/transaction_model.dart';
import 'package:yucatan/services/response/api_error.dart';

class TransactionMultiResponseEntity {
  int? status;
  List<TransactionModel>? data;
  ApiError? errors;
  List<TransactionModel> transactionDataList = [];

  static fromJson(json) {
    TransactionMultiResponseEntity data = TransactionMultiResponseEntity();
    if (json['status'] != null) {
      data.status = json['status']?.toInt();
    }
    if (json['data'] != null) {
      data.data = <TransactionModel>[];
      (json['data'] as List).forEach((v) {
        data.data!.add(new TransactionModel.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      data.errors = new ApiError().fromJson(json['errors']);
    }
    return data;
  }
}
