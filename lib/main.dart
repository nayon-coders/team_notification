import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/local_notification/fcm_notification.dart';
import 'package:userapp/local_notification/local_notification.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/view/auth/login.dart';
import 'package:userapp/view/bottom_navigation/bottom_navigation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
void main() async{
  setStatusBarColor();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  // NotificationHelper.initializeNotifications();
  //  tz.initializeTimeZones();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  runApp(const MyApp());
}

//make notification permission
Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;

  if (status.isDenied) {
    // The user hasn't granted permission yet, request it
    var result = await Permission.notification.request();

    if (result.isGranted) {
      // Permission granted, you can now handle notifications
      print('Notification permission granted');
    } else {
      // Permission denied
      print('Notification permission denied');
    }
  } else {
    // Permission already granted
    print('Notification permission already granted');
  }
}



//Now write some code in main.dart to start firebase background services
// 	1. add this method after import statement in main.dart
Future<void> backgroundHandler(RemoteMessage message) async {
  print("background ${message.data.toString()}");
  print(message.notification!.title);
}

void setStatusBarColor() {
  // Set the status bar color for Android
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor:AppColor.mainColor, // Change this color as needed
  ));

  // Set the status bar color for iOS
  // Note: For iOS, the status bar color is set using the 'backgroundColor' property
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: AppColor.mainColor, // Change this color as needed
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  var token;
  getToken()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      token = _pref.getString("token");
    });
    print("token === ${token}");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token != null ? AppBottomNavigation() : Login()
    );
  }
}
