import 'package:flutter/material.dart';

class VendorBookingLoadingIndicator extends StatelessWidget {
  VendorBookingLoadingIndicator();
  @override
  Widget build(BuildContext context) {
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: displayWidth * 0.03, vertical: 0.2 * displayHeight),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
