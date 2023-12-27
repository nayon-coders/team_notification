import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/app_config.dart';
import 'package:userapp/model/user_model/single_user_info.dart';
import 'package:userapp/model/user_model/user_model.dart';

class UserController{

  //user list
  static Future<UserListModel> getUserList()async{
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.getString("token");
      var res = await http.get(Uri.parse(AppConfig.USERS_LIST),
        headers: {
          "Authorization" : "Bearer $token"
        }
      );
      print("test ==== ${res.body}");
      print("test ==== ${res.statusCode}");
      return UserListModel.fromJson(jsonDecode(res.body));
   }

  //single user
  static Future<SingleUserInfo> getSingleUser()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("user_id");
    var res = await http.get(Uri.parse(AppConfig.SINGLE_USER+"$userId"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    print("user data === ${res.body}");
    return SingleUserInfo.fromJson(jsonDecode(res.body));
  }

  static Future uploadProfile({required File image})async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("user_id");
    try {
      var request = http.MultipartRequest('POST', Uri.parse(AppConfig.UPDATE_PROFILE_IMAGE+"$userId"));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll({
        "Authorization" : "Bearer $token"
      });

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        print('Failed to upload image. Status code: ${response.stream.toString()}');
      } else {
        print('Failed to upload image. Status code: ${response.stream.toString()}');
      }
      return response;
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  //edit info
  static Future<http.Response> editUserInfo({required String fname, required String lname})async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("user_id");
    var res = await http.post(Uri.parse(AppConfig.USERS_UPDATE+"$userId"),
        body: {
        "fname" : fname,
          "lname" : lname
        },
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    return res;
  }

  //edit info
  static Future<http.Response> deleteUser()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("user_id");
    var res = await http.delete(Uri.parse(AppConfig.USERS+"/$userId"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    return res;
  }

  //change password
  static Future<http.Response> changePassword({required String oldPass, required String newPass, required String confirmNewPass})async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.getString("token");
    var userId = _pref.getString("token");
    var res = await http.post(Uri.parse(AppConfig.CHANGE_PASSWORD+"$userId"),
        body: {
          "current_password" : oldPass,
          "new_password" : newPass,
          "confirm_password" : confirmNewPass
        },
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    print("user === ${res.statusCode}");
    print("user === ${res.body}");
    return res;
  }



  // edit profile image



}