import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:userapp/local_notification/local_notification.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/view/about_us/about_us.dart';
import 'package:userapp/view/home/home.dart';
import 'package:userapp/view/profile/profile.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({Key? key}) : super(key: key);

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {

  List<Widget> _page = [
      Home(),
      AboutUs(),
      Profile()
  ];
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          print("message id == ${message.data["id"]}");
          print("message time == ${message.data["time"]}");
          print("message.data ===== ${message.sentTime}");
          LocalNotificationService.createanddisplaynotification(message, DateTime.parse("${message.data["time"]}"));
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.apple);
          print(message.notification!.title);
          print(message.notification!.body);
          print("message id == ${message.data["id"]}");
          print("message time == ${message.data["time"]}");
          LocalNotificationService.createanddisplaynotification(message, DateTime.parse("${message.data["time"]}"));
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message id == ${message.data["id"]}");
          print("message time == ${message.data["time"]}");
          LocalNotificationService.createanddisplaynotification(message, DateTime.parse("${message.data["time"]}"));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.mainColor,
        currentIndex: _currentPage,
        onTap: (index){
          setState(() {
            _currentPage = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'ABOUT US',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
