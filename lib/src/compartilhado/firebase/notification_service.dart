import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:provadelaco/src/modulos/propaganda/ui/paginas/pagina_propaganda.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/ui/paginas/pagina_provas.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CustomNotification {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final RemoteMessage? remoteMessage;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.remoteMessage,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;
  late DarwinNotificationDetails iosDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupAndroidDetails();
    _setupNotifications();
  }

  _setupAndroidDetails() {
    androidDetails = const AndroidNotificationDetails(
      'notificacao',
      'Notificações',
      channelDescription: 'Este canal é para notificações!',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      // actions: [
      //   AndroidNotificationAction('id_1', 'Inscrições'),
      //   AndroidNotificationAction(
      //     'id_2',
      //     'OK',
      //     cancelNotification: true,
      //   ),
      // ],
    );

    iosDetails = const DarwinNotificationDetails(
      presentSound: true,
    );
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    // const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // notificationCategories: [
      //   DarwinNotificationCategory(
      //     'demo',
      //     actions: [

      //     ]
      //   )
      // ]
    );

    // Fazer: macOs, iOS, Linux...
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
        iOS: ios,
      ),
      onDidReceiveNotificationResponse: (details) {
        _onDidReceiveNotificationResponse(details.payload);
      },
      // onDidReceiveBackgroundNotificationResponse: Utils.notificationTapBackground,
    );
  }

  _onDidReceiveNotificationResponse(String? payload) {
    if (payload!.isNotEmpty && AppRotas.navigatorKey!.currentContext != null) {
      var message = jsonDecode(payload);
      String rotaApp = message['rota'] ?? '';

      if (rotaApp != AppRotas.compras && rotaApp != AppRotas.ordemDeEntrada && rotaApp != AppRotas.perfil && rotaApp != AppRotas.home) {
        if (rotaApp == AppRotas.finalizarCompra) {
          AppRotas.navigatorKey?.currentState?.pushNamed(
            rotaApp,
            arguments: PaginaFinalizarCompraArgumentos(
              idEvento: message['idEvento'],
              provas: List<ProvaModelo>.from(jsonDecode(message['provas']).map((elemento) {
                return ProvaModelo.fromMap(elemento);
              })),
            ),
          );
        } else if (rotaApp == AppRotas.provas) {
          AppRotas.navigatorKey?.currentState?.pushNamed(
            rotaApp,
            arguments: PaginaProvasArgumentos(
              idEvento: message['idEvento'],
            ),
          );
        } else if (rotaApp == AppRotas.propaganda) {
          AppRotas.navigatorKey?.currentState?.pushNamed(
            rotaApp,
            arguments: PaginaPropagandaArgumentos(
              idPropaganda: message['idPropaganda'],
            ),
          );
        } else {
          AppRotas.navigatorKey?.currentState?.pushNamed(rotaApp);
        }
      }
    }
  }

  showNotificationScheduled(CustomNotification notification, Duration duration) {
    final date = DateTime.now().add(duration);

    localNotificationsPlugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(date, tz.local),
      payload: notification.payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  showLocalNotification(CustomNotification notification) {
    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      payload: notification.payload,
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onDidReceiveNotificationResponse(details.notificationResponse!.payload);
    }
  }
}
