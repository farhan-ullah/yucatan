import 'package:yucatan/services/booking_service.dart';
import 'package:yucatan/services/response/product_demand_response.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../vendor_demand_screen.dart';

enum VendorDemandBlocAction { FetchVendorDemandData }

class VendorDemandBloc {
  //This StreamController is used to update the state of widgets
  PublishSubject<ProductDemandResponse> _stateStreamController =
      new PublishSubject();
  StreamSink<ProductDemandResponse> get _vendorDemandSink =>
      _stateStreamController.sink;
  Stream<ProductDemandResponse> get vendorDemandStream =>
      _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<VendorDemandBlocAction> _eventStreamController =
      new PublishSubject();
  StreamSink<VendorDemandBlocAction> get eventSink =>
      _eventStreamController.sink;
  Stream<VendorDemandBlocAction> get _eventStream =>
      _eventStreamController.stream;

  ProductDemandResponse? productsResponse;
  DateParameters? dateParameters;

  VendorDemandBloc() {
    _eventStream.listen((event) async {
      if (event == VendorDemandBlocAction.FetchVendorDemandData) {
        // _vendorDemandSink.add(); // just to show loader

        productsResponse =
            (await BookingService.getDemandForDateRange(dateParameters!))!;

        List<ProductDemand> productsList =
            await groupingElementsbyTitle(productsResponse!);
        productsResponse!.productsList = productsList;

        _vendorDemandSink.add(productsResponse!);
      }
    });
  }

  Future<List<ProductDemand>> groupingElementsbyTitle(
      ProductDemandResponse productsResponse) async {
    List<ProductDemand> productsList = [];
    productsResponse.data!.forEach((productDemandDataElement) async {
      productDemandDataElement.products!.forEach((productDemandElement) async {
        ///TODO this needs to be changed
        ///Right now it is grouping the elements based on the title because the acutal product id is missing in the API response
        ///The API needs to be changed so that it returns the product id and then the app should group the quantity by that
        ProductDemand existingProductDemand = productsList.firstWhere(
          (productsListElement) {
            return productsListElement.title == productDemandElement.title;
          },
          // orElse: () => null,
        );

        if (existingProductDemand == null)
          productsList.add(productDemandElement);
        else {
          existingProductDemand.quantity! + productDemandElement.quantity!;
        }
      });
    });
    return productsList;
  }

  updateDateParams(DateParameters dateParameters) {
    this.dateParameters = dateParameters;
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
