import 'package:flutter/material.dart';

import 'indicator.dart';

class IndicatorList extends StatelessWidget {
  final int currentPage;
  final int? numberOfPages;
  IndicatorList({required this.currentPage, this.numberOfPages});

  Widget _getIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < numberOfPages!; i++) {
      i == currentPage
          ? indicatorList.add(Indicator(active: true))
          : indicatorList.add(Indicator(active: false));
    }
    return Row(
      children: indicatorList,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getIndicators();
  }
}
