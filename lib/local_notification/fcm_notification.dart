import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleNotification() async {
    // This is where you would send FCM messages to the specified tokens.
    // Implement the server-side logic to send FCM messages to multiple devices.
    // You may use a backend server or Cloud Functions to handle this.

    // Example: Send FCM messages using Firebase Cloud Functions or your backend server.
    // The actual implementation depends on your server setup.
    // Here, we use a placeholder function named sendFCMNotification.
    //await sendFCMNotification(fcmTokens);
    await sendFCMNotification();

    // Schedule local notification (optional)
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'pushnotificationapp',
      'pushnotificationappchannel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    final DateTime scheduledDate = DateTime.now().add(Duration(seconds: 20));

    print("scheduledDate ==== ${scheduledDate}");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification Title',
      'Scheduled Notification Body',
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> sendFCMNotification() async {
    print("DateTime.now().toUtc().toIso8601String() ---- ${DateTime.now().toUtc().toIso8601String()}");
    // Implement the logic to send FCM notifications to the specified tokens.
    // Use a backend server, Firebase Cloud Functions, or another service for sending FCM messages.
    // The actual implementation depends on your server setup.
    final Map<String, dynamic> data = {
      'registration_ids': [
    "cuzoAtRXSS2kNOKKv-VJfq:APA91bFv8fw75pMBl73mLQOHiCiOYvR45mzjJwMVKMqFq7XBq2Tx1WWSGuVV2hMufSqc1dFnG6QP74v9Y651-HEY1Zl4pgKa3hQkMHrI-qrF93mUXXEKStE723vRMo8nywDJCNnIETAo",
    "fikMQ7ElSVu-ctGrPteDF_:APA91bFmf48qFU8rJHTYhkwIk_MwZo5eLTI_R9q8ps3i5iMSuKjtBFR965pkq0N1SsK_JxSmm3emLakcIGwgDkq-pSPyLQo6HwY4W-iZydlwIN65_w5uN_9Fk531bwUguPxNPvKzYQkK"
    ],
      'notification': {
        'title': 'Hello',
        'body': 'This is a test notification 2023-12-25T05:59:24.506982Z',
        'scheduleTime': "2023-12-25T05:59:24.506982Z"
      },

    };
    // var data = {
    //   "registration_ids": [
    //     "cuzoAtRXSS2kNOKKv-VJfq:APA91bFv8fw75pMBl73mLQOHiCiOYvR45mzjJwMVKMqFq7XBq2Tx1WWSGuVV2hMufSqc1dFnG6QP74v9Y651-HEY1Zl4pgKa3hQkMHrI-qrF93mUXXEKStE723vRMo8nywDJCNnIETAo",
    //     "fikMQ7ElSVu-ctGrPteDF_:APA91bFmf48qFU8rJHTYhkwIk_MwZo5eLTI_R9q8ps3i5iMSuKjtBFR965pkq0N1SsK_JxSmm3emLakcIGwgDkq-pSPyLQo6HwY4W-iZydlwIN65_w5uN_9Fk531bwUguPxNPvKzYQkK"
    //   ],
    //   "notification": {
    //     "body": "New scheduleTime notification FCM",
    //     "title": "FCM scheduleTime Notification",
    //     "android_channel_id": "pushnotificationapp",
    //     "sound": false,
    //   }
    // }.toString();
    var res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          'Content-Type': 'application/json',
          "Authorization" : "key=AAAAuxVpEe4:APA91bES_nnM0jeQQUGE2UblyHJmSwGPGT2JG-m1j-UQToaWw5cWpqaKKm9i00rnS4O08_SR5tdv9NPGyMJLTRLKyIdD4MJWAUTeNf7rCyFLIUkbNSyBzTlasSG6oEO412pduZIDz6JM"
        },
        body: jsonEncode(data)
    );
    print("notification res == ${res.request}");
    print("notification res == ${res.statusCode}");
    print("notification res == ${res.body}");
    // Example: Use a hypothetical sendFCMNotification function.
    // This is just a placeholder; replace it with your actual FCM sending logic.
  }



}
