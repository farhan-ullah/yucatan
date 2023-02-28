// ignore_for_file: avoid_shadowing_type_parameters

import 'package:flutter/material.dart';

import '../services/connection/NetworkObserver.dart';
import '../services/service_locator.dart';
import '../utils/common_widgets.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final NetworkObserver network = getIt.get<NetworkObserver>();

  Widget futureBuild<T>(
      {Future<T>? future,
      Widget Function(BuildContext, T)? builder,
      Widget? placeholder,
      bool? showSpinner}) {
    var decoratedBuilder = (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          //var error = snapshot.error;
          //throw error;
          return builder!(context, snapshot);
        } else {
          return builder!(context, snapshot.data);
        }
      } else {
        return showSpinner == true
            ? CommonWidget.showSpinner()
            : placeholder != null
                ? placeholder
                : Container(color: Colors.white);
      }
    };
    /*var decoratedBuilder = (context, snapshot){
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return CommonWidget.showSpinner();
        default:
          if (snapshot.hasError){
            //return Center(child: Text('${snapshot.error}'));
            return builder(context, snapshot);
          } else {
            return builder(context, snapshot.data);
            //return Text('${snapshot.data}');
          }

      }
    };*/
    return FutureBuilder(future: future, builder: decoratedBuilder);
  }
}
