import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';

enum Category {
  REQUESTED,
  USABLE,
  USED,
  REFUNDED,
}

final Color anfrageColor = Color(0xFF0071B8);
final Color offenColor = CustomTheme.accentColor2;
final Color storniertColor = CustomTheme.accentColor1;
final Color eingelostColor = Color(0xFF8B8B8B);

getCurrentColor(Category category) {
  switch (category) {
    case Category.REQUESTED:
      return anfrageColor;
    case Category.USABLE:
      return offenColor;
    case Category.USED:
      return eingelostColor;
    case Category.REFUNDED:
      return storniertColor;
  }
  return anfrageColor;
}
