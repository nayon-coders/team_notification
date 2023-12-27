import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/controller/auth_controller.dart';
import 'package:userapp/controller/user_controller/userController.dart';
import 'package:userapp/model/user_model/single_user_info.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/view/auth/login.dart';
import 'package:userapp/widget/app_button.dart';
import 'package:userapp/widget/app_input.dart';
import 'package:userapp/widget/app_network_image.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final fName = TextEditingController();
  final lname = TextEditingController();
  final email = TextEditingController();
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmNewPass = TextEditingController();



  late bool _passwordVisible;
  
  Future<SingleUserInfo>? _getSingleUserInfo;

  bool isLoading = false;
  var userId;
  File? profile;

  getUserInfoAndStore()async{
    setState(() => isLoading = false);
    var res = await UserController.getSingleUser();
    setState(() {
      fName.text = res.user!.fname!;
      lname.text = res.user!.lname!;
      email.text = res.user!.email!;
    });
    setState(() => isLoading = false);
  }

  
  @override
  void initState() {
    _passwordVisible = true;
    getUserInfoAndStore();
    _getSingleUserInfo = UserController.getSingleUser();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<SingleUserInfo>(
            future: _getSingleUserInfo,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: AppColor.mainColor,),);
              }else if(snapshot.hasData){
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Text("My Profile",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 30,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: snapshot.data!.user!.image != null
                                      ? profile != null
                                      ? Image.file(profile!,
                                        height: 100, width: 100,
                                      )
                                      : AppNetworkImage(src: "${snapshot.data!.user!.image}",)
                                      : AppNetworkImage(src: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkdPUrvq_PqcJ6xThm45NFBRnGYPElU28gAw&usqp=CAU",)
                              ),
                              Positioned(
                                right: 0, bottom: 0,
                                child:   InkWell(
                                  onTap: ()=>_chooseImage(),
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: AppColor.mainColor,
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: Icon(Icons.edit, color: AppColor.white,),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          AppInput(
                            title: "First Name",
                            hintText: "Enter First Name",
                            controller: fName,
                          ),
                          SizedBox(height: 20,),
                          AppInput(
                            title: "Last Name",
                            hintText: "Enter your last name",
                            controller: lname,
                          ),
                          SizedBox(height: 20,),
                          AppInput(
                            title: "Email",
                            hintText: "Enter your email",
                            controller: email,
                            redOnly:  true,
                          ),

                          SizedBox(height: 30,),
                          InkWell(
                            onTap:()=>_changeInfo(),
                            child: Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColor.mainColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: Text("Change", style: TextStyle(color: AppColor.white),),),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text("Change Password",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 30,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppInput(
                            title: "Old Password",
                            hintText: "Old Password",
                            controller: oldPass,
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
                          SizedBox(height: 20,),
                          AppInput(
                            title: "New Password",
                            hintText: "New Password",
                            controller: newPass,
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
                          SizedBox(height: 20,),
                          AppInput(
                            title: "Confirm Password",
                            hintText: "Confirm",
                            controller: confirmNewPass,
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
                          SizedBox(height: 30,),
                          InkWell(
                            onTap: ()=>_changePassword(),
                            child: Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColor.mainColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(child: Text("Change", style: TextStyle(color: AppColor.white),),),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Divider(height: 1, color: Colors.grey,),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          InkWell(
                            onTap: ()=>Get.to(Login()),
                            child: Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColor.mainColor,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(child: Text("Logout", style: TextStyle(color: AppColor.white),),),
                            ),
                          ),
                          SizedBox(width: 30,),
                          InkWell(
                            onTap:(){
                              Get.defaultDialog(
                                title: "Delete account",
                                content: Text("Are you sure? Do you want to delete account?"),
                                cancel: TextButton(onPressed: ()=>Get.back(), child: Text("No")),
                                confirm: TextButton(onPressed: ()=>_deletingAccount(), child: Text("Yes")),
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(child: Text("Delete Account", style: TextStyle(color: AppColor.white),),),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),

                );
              }else{
                return Center(child: Text("Something went wrong"),);
              }
            }
          ),
          isLoading
              ? Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3)
            ),
            child: Center(child: CircularProgressIndicator(color: Colors.white,),),
          )
              :Center()
        ],
      ),
    );
  }

  //change info
  bool isChangeInfo = false;
  void _changeInfo() async{
    setState(() =>isLoading = true);
    var res = await UserController.editUserInfo(fname: fName.text, lname: lname.text);
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Profile Info Update Success."),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 3000),
      ));
      getUserInfoAndStore();
      setState(() {

      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong."),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }
    setState(() =>isLoading = true);
  }
  void _deletingAccount() async{
    setState(() =>isLoading = true);
    var res = await UserController.deleteUser();
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Your account permanently deleted."),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 3000),
      ));
      AuthController.logout();
      setState(() {
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong."),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }
    setState(() =>isLoading = true);
  }

  _chooseImage() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () {
                  _takenImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _takenImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),

            ],
          );
        });
  }


  //take image
  Future<void> _takenImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        profile = File(pickedFile.path);
      });
      _uploadProfileImageToServer();
    }
  }

  //upload profile in to server
   void _uploadProfileImageToServer()async{
      setState(() =>isLoading = true);
      var res = await UserController.uploadProfile(image: profile!);
      if(res.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profile picture is uploaded success."),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 300),
        ));
        getUserInfoAndStore();
        setState(() {

        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong.. Try again."),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 300),
        ));
      }
      setState(() =>isLoading = false);
   }

   //change password
  void _changePassword() async{
    setState(() =>isLoading = true);
    print(" ====== ${oldPass.text}");
    print(" ====== ${newPass.text}");
    print(" ====== ${confirmNewPass.text}");

    var res = await UserController.changePassword(oldPass: oldPass.text, newPass: newPass.text, confirmNewPass: confirmNewPass.text);
    print(" ====== ${jsonDecode(res.body)}");
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password changed success."),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 3000),
      ));
      AuthController.logout();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${jsonDecode(res.body)["message"]}"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }
    setState(() =>isLoading = false);
  }

}
