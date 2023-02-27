import 'package:flutter/material.dart';
import 'package:yucatan/utils/banner/device_info_dialog.dart';

class FlavorBanner extends StatelessWidget {
  final Widget? child;
  BannerConfig? bannerConfig;
  FlavorBanner({@required this.child});

  @override
  Widget build(BuildContext context) {
    // if (FlavorConfig.isProduction()) return child!;
    // bannerConfig ??= _getDefaultBanner();
    return Stack(
      children: <Widget>[child!, _buildBanner(context)],
    );
  }

  // BannerConfig _getDefaultBanner() {
  //   return BannerConfig(
  //     bannerName: FlavorConfig.instance.name,
  //   );
}

Widget _buildBanner(BuildContext context) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    child: Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
          message: 'How are you!!!',
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
        ),
      ),
    ),
    onLongPress: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeviceInfoDialog();
          });
    },
  );
}

class BannerConfig {
  final String? bannerName;
  BannerConfig({@required this.bannerName});
}
