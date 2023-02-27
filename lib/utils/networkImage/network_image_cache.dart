import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:validators/validators.dart';

/// checks if the requested Image is already in the cache.
/// If not, the file will be downloaded from the remote server.
Future<Uint8List> getImageData(String url) async {
  if (isURL(url)) {
    var file =
        await DefaultCacheManager().getSingleFile(url, key: "awsImage_$url");
    return file.readAsBytes();
  }
  return Future.error("Invalid URL");
}
