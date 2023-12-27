import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:userapp/controller/auth_controller.dart';
import 'package:userapp/routing/routing.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/view/auth/signup.dart';
import 'package:userapp/view/bottom_navigation/bottom_navigation.dart';
import 'package:userapp/widget/app_button.dart';
import 'package:userapp/widget/app_input.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();

  //get fcm device token
  var deviceTokenToSendPushNotification;
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = false;
    getDeviceTokenToSendNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [

                Image.asset("assets/images/logo.png", height: 150,),

                const Text("Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30
                  ),
                ),
                SizedBox(height: 10,),
                const Text("Login into your account",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 50,),
                AppInput(
                  title: "Email",
                  hintText: "Enter your email",
                  controller: email,
                ),
                SizedBox(height: 20,),
                AppInput(
                  title: "Password",
                  hintText: "Password",
                  controller: password,
                  obscureText: _passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColor.mainColor,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: AppColor.mainColor
                      ),
                    ),

                  ),
                ),
                SizedBox(height: 30,),
                AppButton(
                  text: "Login",
                  isLoading: isLoading,
                  onClick: ()=>_login(),
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: ()=>AppRouting.navigatorToLoginScreen(context, SignUp()),
                    child: Text(
                      "I don't have account. Signup.",
                      style: TextStyle(
                          color: AppColor.mainColor
                      ),
                    ),

                  ),
                ),
                SizedBox(height: 20,),
                // Center(
                //   child: Text("Social Signin",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.w500
                //     ),
                //   ),
                // ),
                // SizedBox(height: 15,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       child:Image.asset("assets/images/google.png", height: 40, width: 40,)
                //     ),
                //     SizedBox(width: 20,),
                //     Container(
                //         child:Image.asset("assets/images/apple.png", height: 40, width: 40,)
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false; 
  void _login() async{
    setState(() => isLoading = true);
    var res = await AuthController.login(email: email.text, password: password.text, device_token: deviceTokenToSendPushNotification);
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login Success."),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 3000),
      ));
      Get.offAll(AppBottomNavigation());
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${jsonDecode(res.body)["message"]}"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }
    setState(() => isLoading = false);
  }
}

