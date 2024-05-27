import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class Utils {
  static final coverterEmReal = NumberFormat.currency(locale: 'pt_BR', symbol: "R\$");

  static trocarFormatacaoData(String data) {
    var dataSplit = data.split('/');
    return "${dataSplit[2]}-${dataSplit[1]}-${dataSplit[0]}";
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
    debugPrint(notificationResponse.payload);
  }
}
