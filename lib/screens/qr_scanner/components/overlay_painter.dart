import 'package:yucatan/utils/widget_dimensions.dart';
import 'package:flutter/material.dart';

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final left = size.width * 0.125;
    final top = size.height * 0.25;
    final rectWidth = (size.width - 2 * left).round().toDouble();
    final rectHeight = (size.height - 0.675 * size.height).round().toDouble();

    canvas.drawPath(
        Path.combine(
            PathOperation.difference,
            Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
            Path()
              ..addRRect(RRect.fromRectAndRadius(
                  Rect.fromLTWH(left, top, rectWidth, rectHeight),
                  Radius.circular(Dimensions.getScaledSize(24.0))))
              ..close()),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
