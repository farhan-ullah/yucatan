import 'dart:io';

import 'package:yucatan/services/base_service.dart';

class StatusService extends BaseService {
  StatusService._() : super('https://api.myappventure.de/status');

  static getStatus() {
    return StatusService._().get('');
  }

  static Future<bool> isConnected() async {
    bool connected = true;
    try {
      var status = await getStatus();
      if (status == null) throw SocketException("Network error");
    } on SocketException catch (_) {
      connected = false;
    } on OSError catch (_) {
      connected = false;
    } on Exception catch (_) {
      connected = false;
    }
    return connected;
  }
}
