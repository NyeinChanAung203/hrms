import 'dart:developer';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzd;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initializeNotification({bool initSceduled = false}) async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSettings = DarwinInitializationSettings();
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationPlugin.initialize(
      initializationSettings,
    );
  }

  /* send regular notification */
  static Future<void> sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'channnl description',
            importance: Importance.max,
            priority: Priority.high);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails());
    await _flutterLocalNotificationPlugin.show(
        0, title, body, notificationDetails);
  }

  /* schedule [minutely, daily, weekly, monthly] notification */
  static void scheduleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationPlugin.periodicallyShow(
        0, 'Title', 'body', RepeatInterval.everyMinute, notificationDetails);
  }

  /* noti send on schedule time that we defined */
  static void showDefinedScheduleNotification(
      DateTime time, String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    final specificTime = time.subtract(const Duration(minutes: 5));
    print(specificTime);
    if (DateTime.now().isBefore(specificTime)) {
      tzd.initializeTimeZones();

      await _flutterLocalNotificationPlugin.zonedSchedule(0, title, body,
          tz.TZDateTime.from(specificTime, tz.local), notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  /* stop all notifications */
  static void stopNotification() async {
    _flutterLocalNotificationPlugin.cancelAll();
  }
}
