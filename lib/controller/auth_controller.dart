import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/app_config.dart';
import 'package:userapp/view/auth/login.dart';

class AuthController{
  //login
  static Future<http.Response> singUp({required String fname, required String lname, required String email, required String password, required String deviceToken, })async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print("device_token ${deviceToken}");
    var res = await http.post(Uri.parse(AppConfig.registration),
      body: {
        "fname" : fname,
        "lname" : lname,
        "email" : email,
        "password" : password,
        "device_token" : deviceToken.toString()
      }
    );
    print("res === ${res.body}");
  if(res.statusCode == 200){
    _prefs.setString("token", jsonDecode(res.body)["token"]);
    _prefs.setString("full_name", "${jsonDecode(res.body)["user"]["fname"]} ${jsonDecode(res.body)["user"]["lname"]}");
    _prefs.setString("email", jsonDecode(res.body)["user"]["email"]);
    _prefs.setString("user_id", jsonDecode(res.body)["user"]["id"].toString());
    _prefs.setString("device_token", jsonDecode(res.body)["user"]["device_token"]);
  }
    return res;
  }

  static Future<http.Response> login({required String email, required String password, required String device_token})async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(AppConfig.login),
      body: {
        "email" :email,
        "password" : password,
        "device_token" : device_token
      }
    );

    print("res === ${res.body}");
   if(res.statusCode == 200){
     _prefs.setString("token", jsonDecode(res.body)["token"]);
     _prefs.setString("full_name", "${jsonDecode(res.body)["user"]["fname"]} ${jsonDecode(res.body)["user"]["lname"]}");
     _prefs.setString("email", jsonDecode(res.body)["user"]["email"]);
     _prefs.setString("user_id", jsonDecode(res.body)["user"]["id"].toString());

   }
    return res;
  }


  //logout
  static Future logout()async{
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove("token");
    _pref.remove("full_name");
    _pref.remove("user_id");
    _pref.remove("email");
    _pref.remove("device_token");
    Get.offAll(Login());
  }

}