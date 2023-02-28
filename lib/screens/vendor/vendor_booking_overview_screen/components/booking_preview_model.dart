import 'package:yucatan/models/transaction_model.dart';
import 'package:flutter/material.dart';

class VendorBookingPreviewModel {
  TransactionModel transactionModel;
  DateTime dateTime;
  String tickets;
  String buyer;
  double totalPrice;
  List<TransactionTicket> ticketList;

  VendorBookingPreviewModel(
      {required this.transactionModel,
      required this.dateTime,
      required this.buyer,
      required this.tickets,
      required this.totalPrice,
      required this.ticketList});
}
