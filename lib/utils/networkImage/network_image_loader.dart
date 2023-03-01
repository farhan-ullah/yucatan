import 'package:yucatan/utils/networkImage/network_image_widget.dart';
import 'package:flutter/material.dart';

Widget loadCachedNetworkImage(String url,
    {bool showError = true,
    String? errorMessage,
    BoxFit? fit,
    Alignment alignment = Alignment.center,
    double? height,
    double? width}) {
  return NetworkImageCustom(
      url: url,
      showError: showError,
      errorMessage: errorMessage!,
      fit: fit!,
      alignment: alignment,
      height: height!,
      width: width!);
}
