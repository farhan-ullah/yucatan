import 'package:appventure/components/BaseState.dart';
import 'package:appventure/models/transaction_model.dart';
import 'package:appventure/screens/vendor/order_overview/order_overview_bloc/transactions_for_date_range_bloc.dart';
import 'package:appventure/screens/vendor/order_overview/order_overview_bloc/vendor_account_balance_bloc.dart';
import 'package:appventure/screens/vendor/order_overview/order_overview_bloc/vendor_next_payout_date_bloc.dart';
import 'package:appventure/screens/vendor/order_overview/order_overview_bloc/vendor_payouts_bloc.dart';
import 'package:appventure/services/response/vendor_next_payout_response.dart';
import 'package:appventure/services/response/vendor_payouts_response.dart';
import 'package:appventure/services/response/vendor_dashboard_response.dart';
import 'package:appventure/services/response/transaction_multi_response_entity.dart';
import 'package:appventure/services/service_locator.dart';
import 'package:appventure/services/vendor_accountbalance_response.dart';
import 'package:appventure/utils/image_util.dart';
import 'package:appventure/utils/price_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class OrderOverviewScreenAccountView extends StatefulWidget {
  final VendorDashboardResponse vendorDashboardResponse;

  OrderOverviewScreenAccountView({
    @required this.vendorDashboardResponse,
  });

  @override
  _OrderOverviewScreenAccountViewState createState() =>
      _OrderOverviewScreenAccountViewState();
}

class _OrderOverviewScreenAccountViewState
    extends BaseState<OrderOverviewScreenAccountView> {
  //Future<TransactionMultiResponseEntity> _transactionsFuture;
  //bool isNetworkAvailable = true;
  VendorPayoutsResponse vendorPayoutsResponse;
  VendorAccountBalanceResponse vendorAccountBalanceResponse;
  final vendorPayoutsBloc = getIt.get<VendorPayoutsBloc>();
  final vendorAccountBalanceBloc = getIt.get<VendorAccountBalanceBloc>();
  final transactionsForDateRangeBloc =
      getIt.get<TransactionsForDateRangeBloc>();
  final vendorNextPayoutBloc = getIt.get<VendorNextPayoutBloc>();

  @override
  void initState() {
    //_getTransactionsData();
    initializeDateFormatting('de', null);
    vendorPayoutsBloc.eventSink.add(VendorPayoutAction.FetchPayoutData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: !this.network.offline
          ? CustomTheme.vendorMenubackground
          : CustomTheme.backgroundColor,
      child: StreamBuilder<VendorPayoutsResponse>(
        stream: vendorPayoutsBloc.vendorPayoutStream,
        builder: (context, snapshot) {
          if (this.network.offline) {
            return showPlaceholder();
          }
          if (snapshot.hasData) {
            if (snapshot.data.data == null) {
              return Container(
                margin: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text('Kontoübersicht kann nicht angezeigt werden'),
                ),
              );
            }
            this.vendorPayoutsResponse = snapshot.data;
            vendorAccountBalanceBloc.eventSink
                .add(VendorAccountBalanceAction.FetchVendorAccountBalance);
            return StreamBuilder(
              stream: vendorAccountBalanceBloc.vendorAccountBalanceStream,
              builder: (context, snapshotAccountBalance) {
                switch (snapshotAccountBalance.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshotAccountBalance.hasError) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.85,
                        margin: EdgeInsets.all(16.0),
                        color: CustomTheme.backgroundColor,
                        child: Center(
                          child: Text(
                            'Kontoübersicht nicht verfügbar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColorDark,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      this.vendorAccountBalanceResponse =
                          snapshotAccountBalance.data;
                      transactionsForDateRangeBloc
                          .sendVendorPayoutResponse(this.vendorPayoutsResponse);
                      transactionsForDateRangeBloc.eventSink.add(
                          TransactionsForDateRangeBlocAction
                              .FetchVendorTransactions);

                      return StreamBuilder<TransactionMultiResponseEntity>(
                        //future: BookingService.getTransactionsForDateRange(),
                        stream: transactionsForDateRangeBloc
                            .vendorTransactionStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.data == null) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                      'Kontoübersicht kann nicht angezeigt werden'),
                                ),
                              );
                            }

                            List<TransactionModel> transactionDataList =
                                snapshot.data.transactionDataList;

                            vendorNextPayoutBloc.eventSink.add(
                                VendorNextPayoutAction.FetchVendorNextPayout);

                            return Container(
                              decoration: BoxDecoration(
                                color: CustomTheme.backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              height: double.infinity,
                              margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: CustomTheme.accentColor3,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: const Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              color:
                                                  CustomTheme.primaryColorDark,
                                              size: 32.0,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Text(
                                                    'Kontostand',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: CustomTheme
                                                          .primaryColorDark,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              StreamBuilder<
                                                  VendorNextPayoutResponse>(
                                                stream: vendorNextPayoutBloc
                                                    .vendorNextPayoutStream, // async work
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            VendorNextPayoutResponse>
                                                        snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 8.0),
                                                          child: Text(
                                                            //"Nächste Auszahlung ${DateFormat('dd.MM.y').format(DateTime.now())}",
                                                            "Nächste Auszahlung",
                                                            style: TextStyle(
                                                                color: CustomTheme
                                                                    .lightGrey),
                                                          ),
                                                        ),
                                                      );
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Container(
                                                          child: Text(''),
                                                        );
                                                      } else {
                                                        return Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              //"Nächste Auszahlung ${DateFormat('dd.MM.y').format(DateTime.now())}",
                                                              "Nächste Auszahlung ${DateFormat('dd.MM.y').format(snapshot.data.data.payoutDate)}",
                                                              style: TextStyle(
                                                                  color: CustomTheme
                                                                      .lightGrey),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        StreamBuilder<VendorNextPayoutResponse>(
                                          stream: vendorNextPayoutBloc
                                              .vendorNextPayoutStream, // async work
                                          builder: (BuildContext context,
                                              AsyncSnapshot<
                                                      VendorNextPayoutResponse>
                                                  snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return Container();
                                              default:
                                                if (snapshot.hasError) {
                                                  return Container();
                                                } else {
                                                  return Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                        top: 25,
                                                        bottom: 25,
                                                      ),
                                                      child: Text(
                                                        '${formatPriceDouble(snapshot?.data?.data?.net ?? 0)}€',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: CustomTheme
                                                              .primaryColorDark,
                                                          fontSize: 22.0,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    color: CustomTheme.backgroundColor,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 10.0,
                                              top: 15.0,
                                              bottom: 4.0,
                                            ),
                                            child: Text(
                                              'Datum',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.primaryColor,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 15.0,
                                              bottom: 4.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Anz.',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      CustomTheme.primaryColor,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 15.0,
                                              bottom: 4.0,
                                            ),
                                            child: Text(
                                              'Kunde',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.primaryColor,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              right: 10.0,
                                              top: 15.0,
                                              bottom: 4.0,
                                            ),
                                            child: Text(
                                              'Betrag(€)',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.primaryColor,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ), // Lücke zwischen den zwei Containern
                                  Expanded(
                                    child: Flex(
                                      direction: Axis.vertical,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: CustomTheme.accentColor2,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    const Radius.circular(16),
                                                bottomRight:
                                                    const Radius.circular(16),
                                              ),
                                            ),
                                            /*ListView **/
                                            child: ListView.builder(
                                              physics: ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0),
                                              itemCount:
                                                  transactionDataList.length,
                                              itemBuilder: (context, index) {
                                                TransactionModel
                                                    transactionModelObject =
                                                    transactionDataList[index];

                                                //Skip bookings/tickets which have not been used yet
                                                if (transactionModelObject
                                                            .bookingState !=
                                                        'SUCCESS' &&
                                                    transactionModelObject
                                                            .bookingState !=
                                                        'REQUEST_ACCEPTED')
                                                  return Container();

                                                transactionModelObject.tickets =
                                                    transactionModelObject
                                                        .tickets
                                                        .where((element) =>
                                                            element.state ==
                                                            'USED')
                                                        .toList();

                                                if (transactionModelObject
                                                            .tickets ==
                                                        null ||
                                                    transactionModelObject
                                                            .tickets.length ==
                                                        0) return Container();

                                                TransactionModel prev;
                                                TransactionModel next;
                                                bool isNextPayoutObject = false;
                                                bool isPrevPayoutObject = false;
                                                if (index + 1 <
                                                    transactionDataList
                                                        .length) {
                                                  next = transactionDataList[
                                                      index + 1];
                                                  isNextPayoutObject =
                                                      next.isPayoutObject;
                                                }
                                                if (index - 1 > -1) {
                                                  prev = transactionDataList[
                                                      index - 1];
                                                  isPrevPayoutObject =
                                                      prev.isPayoutObject;
                                                }
                                                if (transactionModelObject
                                                    .isPayoutObject) {
                                                  return Container(
                                                    height: 45.0,
                                                    color: Colors.transparent,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 4,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10.0),
                                                                  child: Text(
                                                                    _getDateWithFormat(
                                                                        transactionDataList,
                                                                        index),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 7,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10.0),
                                                                  child: Text(
                                                                    'Letzte Auszahlung',
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 5,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0),
                                                                  child: Text(
                                                                    '+ ${formatPriceDouble(transactionModelObject.payoutData.net == null ? 0 : transactionModelObject.payoutData.net)}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    height: 45.0,
                                                    decoration: !isNextPayoutObject &&
                                                            !isPrevPayoutObject
                                                        ? BoxDecoration(
                                                            color: CustomTheme
                                                                .backgroundColor,
                                                          )
                                                        : isNextPayoutObject
                                                            ? BoxDecoration(
                                                                color: CustomTheme
                                                                    .backgroundColor,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            15.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            15.0)),
                                                              )
                                                            : isPrevPayoutObject
                                                                ? BoxDecoration(
                                                                    color: CustomTheme
                                                                        .backgroundColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              15.0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              15.0),
                                                                    ),
                                                                  )
                                                                : BoxDecoration(
                                                                    color: CustomTheme
                                                                        .backgroundColor,
                                                                  ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              //Datum
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10.0),
                                                                  child: Text(
                                                                    '${_getDateWithFormat(transactionDataList, index)}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: CustomTheme
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              //Anz.
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10.0),
                                                                  child: Text(
                                                                    '${_getAmountTickets(transactionDataList, index)}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: CustomTheme
                                                                          .primaryColor,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ),
                                                              //Kunde
                                                              Expanded(
                                                                flex: 3,
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                    '${_getCustomer(transactionDataList, index)}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: CustomTheme
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              //Betrag(€)
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    right: 10.0,
                                                                  ),
                                                                  child: Text(
                                                                    '${formatPriceDouble(_getAmountMoneyDouble(transactionDataList, index))}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        TextStyle(
                                                                      color: CustomTheme
                                                                          .primaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Divider(
                                                            height: 9.0,
                                                            thickness: 1.0,
                                                            indent: 12.0,
                                                            endIndent: 10.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.85,
                              margin: EdgeInsets.all(16.0),
                              color: CustomTheme.backgroundColor,
                              child: Center(
                                child: Text(
                                  'Kontoübersicht nicht verfügbar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomTheme.primaryColorDark,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            //LoadingSpinner
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    }
                }
              },
            );
          } else if (snapshot.hasError) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              margin: EdgeInsets.all(16.0),
              color: CustomTheme.backgroundColor,
              child: Center(
                child: Text(
                  'Kontoübersicht nicht verfügbar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.primaryColorDark,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            //LoadingSpinner
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget showPlaceholder() {
    return ImageUtil.showPlaceholderView(onUpdateBtnClicked: () async {
      if (!this.network.offline) {
        vendorPayoutsBloc.eventSink.add(VendorPayoutAction.FetchPayoutData);
      }
    });
  }

  // String _getSumOfAmountMoney(List<TransactionModel> transactionList) {
  //   //Sorts the List by Date in ascending order
  //   transactionList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  //   //Calculates the sum of a number-Array
  //   num sum = 0;
  //   var numberformat = NumberFormat("#.00", "en_US");
  //   transactionList.forEach((TransactionModel transactionModel) {
  //     sum += transactionModel.totalPrice;
  //   });
  //   return numberformat.format(sum);
  // }

  // String _getDate(List<TransactionModel> transactionList, num index) {
  //   var date = transactionList[index].dateTime;
  //   //formats Date: DD.MM.YYYY
  //   return DateFormat('d.M.y').format(date);
  // }

  String _getDateWithFormat(List<TransactionModel> transactionList, num index) {
    var date = transactionList[index].dateTime;
    //formats Date: DD.MM.YYYY
    return DateFormat('dd.MM.yyyy', "de-DE").format(date);
  }

  //DateFormat('MMMM yyyy', "de-DE").format(widget.booking.dateTime)
  String _getAmountTickets(List<TransactionModel> transactionList, num index) {
    if (transactionList[index].isPayoutObject) {
      return "isPayoutObject";
    } else {
      var amountTickets = transactionList[index].tickets.length;
      return amountTickets.toString();
    }
  }

  String _getCustomer(List<TransactionModel> transactionList, num index) {
    if (transactionList[index].isPayoutObject) {
      return "isPayoutObject";
    } else {
      var customer = transactionList[index].buyer;
      return customer;
    }
  }

  // String _getAmountMoney(List<TransactionModel> transactionList, num index) {
  //   var amountMoney = transactionList[index].totalPrice;
  //   return amountMoney.toString();
  // }

  double _getAmountMoneyDouble(
      List<TransactionModel> transactionList, num index) {
    var totalValue = 0.0;

    transactionList[index].tickets.forEach((element) {
      if (element.state != 'USED') return;

      totalValue += element.price;
    });

    return totalValue;
  }

  /*void _getTransactionsData() {
    _transactionsFuture = BookingService.getTransactionsForDateRange();
  }*/
}
