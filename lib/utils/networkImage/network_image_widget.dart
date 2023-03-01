import 'dart:typed_data';

import 'package:yucatan/utils/networkImage/network_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../StringUtils.dart';

class NetworkImageCustom extends StatefulWidget {
  final String? url;
  final String? errorMessage;
  final bool showError;
  final BoxFit? fit;
  final Alignment? alignment;
  final double? height;
  final double? width;

  const NetworkImageCustom(
      {Key? key,
      this.url,
      this.errorMessage,
      this.showError = true,
      this.fit,
      this.alignment = Alignment.center,
      this.height,
      this.width})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetworkImageCustomState(
      url: url!,
      showError: showError,
      errorMessage: errorMessage!,
      fit: fit!,
      alignment: alignment!,
      height: height!,
      width: width!);
}

class _NetworkImageCustomState extends State<NetworkImageCustom> {
  final String? url;
  final String? errorMessage;
  final bool? showError;
  final BoxFit? fit;
  final Alignment? alignment;
  final double? height;
  final double? width;
  late Widget _child;

  final int maxRetries = 2;

  _NetworkImageCustomState(
      {this.url,
      this.errorMessage,
      this.showError = true,
      this.fit,
      this.alignment = Alignment.center,
      this.height,
      this.width}) {
    if (isURL(url ?? '')) {
      this._child = _loadingWidget();
      _load(0);
    } else {
      this._child = _errorWidget(
          showError: showError ?? true, errorMessage: errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _child,
    );
  }

  //---------------------------------------------

  _load(int currentRetry) async {
    try {
      var futureData = await getImageData(url ?? '');
      if (futureData.isNotEmpty) {
        _updateState(
            _imageWidget(futureData, fit: fit!, alignment: alignment!));
      } else {
        _updateState(
            _errorWidget(showError: showError!, errorMessage: errorMessage!));
      }
    } catch (e) {
      if (currentRetry >= 2) {
        _updateState(
            _errorWidget(showError: showError!, errorMessage: errorMessage!));
      } else {
        _load(currentRetry++);
      }
    }
  }

  _updateState(Widget child) {
    if (this.mounted) {
      setState(() {
        _child = child;
      });
    }
  }

  //---------------------------------------------

  Widget _loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _errorWidget({bool showError = true, String? errorMessage}) {
    if (isNotNullOrEmpty(errorMessage!) && showError) {
      return Container(
        child: Row(
          children: [Icon(Icons.error), Text((errorMessage))],
        ),
      );
    }
    return Container(child: (showError) ? Icon(Icons.error) : null);
  }

  Widget _imageWidget(Uint8List data,
      {BoxFit? fit, Alignment alignment = Alignment.center}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: MemoryImage(data), fit: fit, alignment: alignment),
      ),
    );
  }
}
