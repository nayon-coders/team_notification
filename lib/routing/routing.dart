import 'package:flutter/material.dart';

class AppRouting{
  //flash screen to login routing
  static Future navigatorToLoginScreen(BuildContext context, Widget widget){
    var result = Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));
    return result;
  }

}