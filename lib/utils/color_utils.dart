import 'package:flutter/material.dart';

extension HexColor on Color {
  String toHex({bool includeAlphaValue = false}) {
    if(includeAlphaValue){
      return '#' + this.value.toRadixString(16).padLeft(8, '0');
    } else {
      return '#' + (this.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    }
  }
}