import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../vendor_demand_screen.dart';

enum DateOptionsAction{SelectedDate}

class DateOptionsBloc{

  //This StreamController is used to update the state of widgets
  PublishSubject<SelectedDate> _stateStreamController = new PublishSubject();
  StreamSink<SelectedDate> get _dateOptionSink => _stateStreamController.sink;
  Stream<SelectedDate> get dateOptionStream => _stateStreamController.stream;

  //user input event StreamController
  PublishSubject<DateOptionsAction> _eventStreamController = new PublishSubject();
  StreamSink<DateOptionsAction> get eventSink => _eventStreamController.sink;
  Stream<DateOptionsAction> get _eventStream => _eventStreamController.stream;

  DateOptionsBloc(){
    _eventStream.listen((event) async {
      if (event == DateOptionsAction.SelectedDate){
        _dateOptionSink.add(selectedDate!);
      }
    });
  }
  SelectedDate? selectedDate;
  updateSelectedDate(SelectedDate selectedDate){
    this.selectedDate = selectedDate;
  }

  void dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }

}