import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provadelaco/src/core/firebase/notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _onMessage();
  }

  Future<String?> getDeviceFirebaseToken() async {
    if (Platform.isIOS) {
      final token = await FirebaseMessaging.instance.getToken();
      return token;
    } else {
      final token = await FirebaseMessaging.instance.getToken();
      return token;
    }
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: jsonEncode(message.data),
            remoteMessage: message,
          ),
        );
      }
    });
  }
}
