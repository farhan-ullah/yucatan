import 'dart:async';
import 'package:yucatan/models/transaction_model.dart';
import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/services/response/transaction_multi_response_entity.dart';
import 'package:yucatan/services/response/vendor_payouts_response.dart';
import 'package:rxdart/rxdart.dart';

enum TransactionsForDateRangeBlocAction { FetchVendorTransactions }

class TransactionsForDateRangeBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<TransactionMultiResponseEntity> _stateStreamController =
      new PublishSubject();
  StreamSink<TransactionMultiResponseEntity> get _vendorTransactionSink =>
      _stateStreamController.sink;
  Stream<TransactionMultiResponseEntity> get vendorTransactionStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<TransactionsForDateRangeBlocAction> _eventStreamController =
      PublishSubject();
  StreamSink<TransactionsForDateRangeBlocAction> get eventSink =>
      _eventStreamController.sink;
  Stream<TransactionsForDateRangeBlocAction> get _eventStream =>
      _eventStreamController.stream;

  TransactionsForDateRangeBloc() {
    _eventStream.listen((event) async {
      if (event == TransactionsForDateRangeBlocAction.FetchVendorTransactions) {
        TransactionMultiResponseEntity? response =
            await BookingService.getTransactionsForDateRange();

        List<TransactionModel> transactionDataList = response!.data!;
        for (int i = 0; i < vendorPayoutsResponseObj!.data!.length; i++) {
          PayoutData payoutData = vendorPayoutsResponseObj!.data![i];
          //payoutData.status = "PAID";
          if (payoutData.status == "PAID") {
            TransactionModel transactionModel = TransactionModel();
            transactionModel.dateTime = payoutData.payoutDate;
            transactionModel.isPayoutObject = true;
            transactionModel.payoutData = payoutData;
            transactionDataList.add(transactionModel);
          }
        }
        transactionDataList.sort((a, b) {
          return b.dateTime!.compareTo(a.dateTime!);
        });
        response.transactionDataList = transactionDataList;
        _vendorTransactionSink.add(response);
      }
    });
  }

  VendorPayoutsResponse? vendorPayoutsResponseObj;
  void sendVendorPayoutResponse(VendorPayoutsResponse vendorPayoutsResponse) {
    this.vendorPayoutsResponseObj = vendorPayoutsResponse;
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
