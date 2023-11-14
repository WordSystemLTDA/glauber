import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:glauber/src/compartilhado/firebase/notification_service.dart';

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
    getDeviceFirebaseToken();
  }

  Future<String?> getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    debugPrint('=======================');
    debugPrint('TOKEN: $token');
    debugPrint('=======================');

    return token;
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          CustomNotification(id: android.hashCode, title: notification.title!, body: notification.body!, payload: message.data['route'] ?? ''),
        );
      }
    });
  }
}
