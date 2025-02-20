import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class Utils {
  static final coverterEmReal = NumberFormat.currency(locale: 'pt_BR', symbol: "R\$");

  static trocarFormatacaoData(String data, {String pattern = '/', String to = '-', bool trocarOrdem = false}) {
    var dataSplit = data.split(pattern);

    if (trocarOrdem) {
      return "${dataSplit[0]}$to${dataSplit[1]}$to${dataSplit[2]}";
    }

    return "${dataSplit[2]}$to${dataSplit[1]}$to${dataSplit[0]}";
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
    debugPrint(notificationResponse.payload);
  }
}
