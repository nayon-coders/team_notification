import 'dart:convert';
import 'dart:io';

import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/app_config.dart';
import 'package:userapp/model/notification_model/notification_model.dart';
import 'package:userapp/model/notification_model/single_notification_model.dart';

class NotificationController{

  //ccreate notification
  static Future createNotification({required String title, required String msg,required String selectedTime, required String seletedDate,required List userList, required File image,     })async{
    bool isSuccess = false;
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    try {
      var request = http.MultipartRequest('POST', Uri.parse(AppConfig.NOTIFICATION_LIST));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.fields['date'] = seletedDate;
      request.fields['time'] = selectedTime;
      request.fields['title'] = title;
      request.fields['message'] = msg;
      request.fields['user_list'] = userList.toString();

      var response = await request.send();
      if (response.statusCode == 200) {
        isSuccess = true;
        print('Image uploaded successfully');
        print('Failed to upload image. Status code: ${response.stream.toString()}');
      } else {
        isSuccess = false;
        print('Failed to upload image. Status code: ${response.stream.toString()}');
      }
      return response;
    } catch (error) {
      isSuccess = true;
      print('Error uploading image: $error');
    }


  }


  //static
  static Future<NotificationListModel> getNotificationList()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var res = await http.get(Uri.parse(AppConfig.NOTIFICATION_LIST),
      headers: {
        "Authorization" : "Bearer $token"
      }
    );
    return NotificationListModel.fromJson(jsonDecode(res.body));
  }

  static Future<SingleNotificationModel> getSingleNotification({required String id})async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = await SharedPreferences.getInstance();
    var res = await http.get(Uri.parse(AppConfig.NOTIFICATION_LIST+"/$id"),
      headers: {
        "Authorization" : "Bearer $token"
      }
    );
    return SingleNotificationModel.fromJson(jsonDecode(res.body));
  }


  //static
  static Future<http.Response> deleteNotification({required String id})async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    print("id == $id");
    var res = await http.delete(Uri.parse(AppConfig.NOTIFICATION_LIST+"/$id"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    print("res ==  ${res.statusCode}");
    print("res ==  ${res.body}");
    return res;
  }


  static Future<void> sendFCMNotification({required String id, required List registration_ids, required String title, required String message, required String image, required DateTime dateTime}) async {


    // Use the intl package to get the timezone
    DateTime now = DateTime.now();
    String timezone = DateFormat('z').format(now);

    print("App ==== ${title}");
    print("App ==== ${message}");
    print("App ==== ${image}");
    print("App ==== ${dateTime}");
    // Implement the logic to send FCM notifications to the specified tokens.
    // Use a backend server, Firebase Cloud Functions, or another service for sending FCM messages.
    // The actual implementation depends on your server setup.
    var data = {
      // "registration_ids": [
      //   "cuzoAtRXSS2kNOKKv-VJfq:APA91bFv8fw75pMBl73mLQOHiCiOYvR45mzjJwMVKMqFq7XBq2Tx1WWSGuVV2hMufSqc1dFnG6QP74v9Y651-HEY1Zl4pgKa3hQkMHrI-qrF93mUXXEKStE723vRMo8nywDJCNnIETAo",
      //   "fikMQ7ElSVu-ctGrPteDF_:APA91bFmf48qFU8rJHTYhkwIk_MwZo5eLTI_R9q8ps3i5iMSuKjtBFR965pkq0N1SsK_JxSmm3emLakcIGwgDkq-pSPyLQo6HwY4W-iZydlwIN65_w5uN_9Fk531bwUguPxNPvKzYQkK"
      // ],
     "registration_ids" : registration_ids,
      "notification": {
        "body": message.toString(),
        "title": title.toString(),
        "android_channel_id": "pushnotificationapp",
        "sound": true,
        "image" : image
      },
      "data" : {
        "id" : "$id",
        "time" : "${dateTime}"
      }

    };
    var res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
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