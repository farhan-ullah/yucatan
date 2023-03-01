import 'package:flutter/material.dart';

import 'round_indicator.dart';

class RoundIndicatorList extends StatelessWidget {
  final int currentPage;
  final int? numberOfPages;
  RoundIndicatorList({required this.currentPage, this.numberOfPages});

  Widget _getIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < numberOfPages!; i++) {
      i == currentPage
          ? indicatorList.add(RoundIndicator(active: true))
          : indicatorList.add(RoundIndicator(active: false));
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
