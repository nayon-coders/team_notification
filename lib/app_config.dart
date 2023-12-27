import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AppConfig{

  //app name
  static const String AppName = "Car Rent";
  static const String ADMIN_MIAL = "admin@gmail.com";
  static const String ONESIGNA_API = "ed227ee2-b0a5-4b0b-83b8-ba9dc3dd6a36";


  //api connection
  static const String domain = "http://teamnotification.alloneautos.com";
  static const String Baseurl = "http://teamnotification.alloneautos.com/api";



  //API lists
  static const String registration = "$Baseurl/register";
  static const String login = "$Baseurl/login";
  static const String USERS = "$Baseurl/user";
  static const String USERS_UPDATE = "$Baseurl/user/update/";
  static const String USERS_LIST = "$Baseurl/user-list";
  static const String SINGLE_USER = "$Baseurl/user/show/";
  static const String NOTIFICATION_LIST = "$Baseurl/notification";
  static const String UPDATE_PROFILE_IMAGE = "$Baseurl/profile-image/upload/";
  static const String CHANGE_PASSWORD = "$Baseurl/change-password/";




  static String getCurrentTimezone() {
    // Use the intl package to get the timezone
    DateTime now = DateTime.now();
    String timezone = DateFormat('z').format(now);
    return timezone;
  }


}