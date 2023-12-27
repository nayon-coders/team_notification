import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:userapp/controller/auth_controller.dart';
import 'package:userapp/routing/routing.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/view/auth/login.dart';
import 'package:userapp/view/bottom_navigation/bottom_navigation.dart';
import 'package:userapp/widget/app_button.dart';
import 'package:userapp/widget/app_input.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpKey = GlobalKey<FormState>();
  final fname = TextEditingController();
  final lname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final Cpassword = TextEditingController();



  //get fcm device token
  var deviceTokenToSendPushNotification;
  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
   setState(() {
     deviceTokenToSendPushNotification = token.toString();
   });
    print("Token Value $deviceTokenToSendPushNotification");
  }

  late bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible = true;
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
            child: Form(
              key: _signUpKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text("Create account.",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Text("Create a new account.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: 50,),
                  AppInput(
                    title: "First Name",
                    hintText: "Enter your first name",
                    controller: fname,
                    validator: (v){
                      if(v!.isEmpty){
                        return "First name is required.";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  AppInput(
                    title: "Last Name",
                    hintText: "Enter your last name",
                    controller: lname,
                    validator: (v){
                      if(v!.isEmpty){
                        return "Last name is required.";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  AppInput(
                    title: "Email",
                    hintText: "Enter your email",
                    controller: email,
                    validator: (v){
                      if(v!.isEmpty){
                        return "Email name is required.";
                      }else{
                        return null;
                      }
                    },
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
                    validator: (v){
                      if(v!.isEmpty){
                        return "Password name is required.";
                      }else if(v!.length > 9){
                        return "Password must be 8 character.";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 20,),
                  AppInput(
                    title: "Confirm Password",
                    hintText: "Confirm",
                    controller: Cpassword,
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

                    validator: (v){
                      if(v! != password.text){
                        return "Confirm Password don't match.";
                      }else{
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 30,),
                  AppButton(
                    isLoading: isLoading,
                    text: "Signup",
                    onClick: ()=>_signUp(),
                  ),
                  SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: ()=>Get.to(Login()),
                      child: const Text(
                        "I don't have account. Signup.",
                        style: TextStyle(
                            color: AppColor.mainColor
                        ),
                      ),

                    ),
                  ),
                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  void _signUp() async{
    setState(() =>isLoading = true);
    if(_signUpKey.currentState!.validate()){
      var res = await AuthController.singUp(fname: fname.text, lname: lname.text, email: email.text, password: password.text, deviceToken: deviceTokenToSendPushNotification);
      if(res.statusCode == 200){
        Get.to(AppBottomNavigation());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration success."),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 300),
        ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong."),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 300),
        ));
      }
    }

    setState(() =>isLoading = false);
  }



}

