import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeViewer extends StatelessWidget {
  final String? content;
  final double size;

  const QrCodeViewer({Key? key, this.content, this.size = 200.0})
      : super(key: key);

  /// EmbeddedImage does not work.
  /// The image covers the code and does not leave blank space.
  /// This may result in the QR-Code being unreadable!
  /// Author claims this is how it's supposed to work...and closed the bug report
  @override
  Widget build(BuildContext context) {
    return Container(
      child: QrImage(
        data: content!,
        size: size,
        version: QrVersions.auto,
      ),
    );
  }
}
