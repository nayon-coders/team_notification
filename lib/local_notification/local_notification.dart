
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:userapp/view/bottom_navigation/bottom_navigation.dart';
import 'package:userapp/view/notification/view_notification.dart';

class LocalNotificationService{


  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        print("onSelectNotification");
        if (id!.isNotEmpty) {
          print("Router Value1234 $id");

          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DemoScreen(
          //       id: id,
          //     ),
          //   ),
          // );


        }
      },
    );
  }


  static void createanddisplaynotification(RemoteMessage message, DateTime dateTime) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      var scheduledDate = DateTime.now().add(Duration(seconds: 20));

      print("scheduledDate === ${scheduledDate}");
      print("scheduledDate === ${dateTime}");

      // initializationSettings  for Android
      const InitializationSettings initializationSettings =
      InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: IOSInitializationSettings(),
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );


      _notificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (String? id) async {
          print("onSelectNotification");
          if (id!.isNotEmpty) {
            print("Router Value1234 $id");
            if(id.isNotEmpty){
              Get.to(ViewNotification(notificationId: id.toString()));
            }else{
              Get.to(AppBottomNavigation());
            }

            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DemoScreen(
            //       id: id,
            //     ),
            //   ),
            // );


          }
        },
      );


      await _notificationsPlugin.schedule(
        id,
        "${message.notification!.title}",
        "${message.notification!.title}",
        dateTime,
        notificationDetails,
          payload: "${message.data[id]}",
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}