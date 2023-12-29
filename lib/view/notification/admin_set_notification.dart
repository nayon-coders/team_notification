import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:userapp/app_config.dart';
import 'package:userapp/controller/notification_controller/notification_controller.dart';
import 'package:userapp/controller/user_controller/userController.dart';
import 'package:userapp/local_notification/fcm_notification.dart';
import 'package:userapp/model/user_model/user_model.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/view/bottom_navigation/bottom_navigation.dart';
import 'package:userapp/widget/app_input.dart';
import 'package:userapp/widget/app_network_image.dart';
class AdminSetNotificaion extends StatefulWidget {
  const AdminSetNotificaion({
    super.key,
  });

  @override
  State<AdminSetNotificaion> createState() => _AdminSetNotificaionState();
}

class _AdminSetNotificaionState extends State<AdminSetNotificaion> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final msg = TextEditingController();
  final title = TextEditingController();

  var outputDateFormat = DateFormat('yyyy-MM-dd');
  // var outputTimeFormat =  TimeOfDay('hh-mm-ss', hour: null, minute: null);


  //user
  List<User> user = [];
  bool isLoading = false;
  void _getUserList()async{
    setState(() => isLoading = true);
    var res = await UserController.getUserList();
    for(var i in res.user!){
      setState(() {
        user.add(i);
      });
    }
    setState(() => isLoading = false);
  }
  List<String> _getUserToken = [];
  List selectedUserList = [];
  List token =  [
    "cuzoAtRXSS2kNOKKv-VJfq:APA91bFv8fw75pMBl73mLQOHiCiOYvR45mzjJwMVKMqFq7XBq2Tx1WWSGuVV2hMufSqc1dFnG6QP74v9Y651-HEY1Zl4pgKa3hQkMHrI-qrF93mUXXEKStE723vRMo8nywDJCNnIETAo",
    "fikMQ7ElSVu-ctGrPteDF_:APA91bFmf48qFU8rJHTYhkwIk_MwZo5eLTI_R9q8ps3i5iMSuKjtBFR965pkq0N1SsK_JxSmm3emLakcIGwgDkq-pSPyLQo6HwY4W-iZydlwIN65_w5uN_9Fk531bwUguPxNPvKzYQkK"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserList();
    //_scheduleNotification();
    //NotificationHelper.scheduleNotification();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: Text("Setup New Notification"),
        ),
        body: SingleChildScrollView(
          child: Container (
            width: double.infinity,
            //height: 480,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: ()=>_selectDate(context),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.grey.shade200)
                    ),
                    child: ListTile(
                      title: Text("Select Date",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: selectedDate != null ? Text("Selected Date: ${selectedDate}") : Text("Select notfication send date."),
                      trailing: Icon(Icons.calendar_month,),
                    ),
                  ),
                ),
                errorDate != null ? ErrorTextBuilder(errorTeam: errorDate) : Center(),
                SizedBox(height: 15,),
                InkWell(
                  onTap: ()=>_selectTime(context),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.grey.shade200)
                    ),
                    child: ListTile(
                      title: Text("Select Time",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle:selectedTime != null ? Text("Selected Time: ${selectedTime}") : Text("Select notification send time."),
                      trailing: Icon(Icons.watch_later_outlined,),
                    ),
                  ),
                ),
                errorTime != null ? ErrorTextBuilder(errorTeam: errorTime) : Center(),
                SizedBox(height: 15,),
                AppInput(
                  title: "Title",
                  hintText: "Enter your notification title",
                  controller: title,
                  maxLine: 1,
                ),
                errorTitle != null ? ErrorTextBuilder(errorTeam: errorTitle) : Center(),
                SizedBox(height: 15,),
                AppInput(
                  title: "Messages",
                  hintText: "Type your messages",
                  controller: msg,
                  maxLine: 5,
                ),
                errorMsg != null ? ErrorTextBuilder(errorTeam: errorMsg) : Center(),

                SizedBox(height: 15,),
                InkWell(
                  onTap: ()=>_chooseImage(),
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera_back, color: AppColor.white,),
                        SizedBox(width: 10,),
                        Text(" ${_image != null ? "Change Image" : "Choose Image"}",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                errorImage != null ? ErrorTextBuilder(errorTeam: errorImage) : Center(),
                _image != null ? Column(
                  children: [
                    SizedBox(height: 10,),
                    Image.file(_image!, height: 100, width: 100,),
                  ],
                ) : Center(),
                SizedBox(height: 15,),
                InkWell(
                  onTap: ()=> _selectTeamMember(),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.grey.shade200)
                    ),
                    child: ListTile(
                      title: Text("Select Team Members",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(" Total selected Team: ${_getUserToken.length}"),
                      trailing:  Icon(Icons.supervised_user_circle,),
                    ),
                  ),
                ),
                errorTeam != null ? ErrorTextBuilder(errorTeam: errorTeam) : Center(),
                SizedBox(height: 30,),

              ],
            ),
          ),
        ),
        bottomNavigationBar:   InkWell(
          //onTap: ()=> NotificationController.sendFCMNotification(registration_ids: selectedUserList, title: title.text, message: msg.text, image: "https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg"),
            onTap: ()=> addNewNotification(),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 80,
            decoration: BoxDecoration(
                color: AppColor.mainColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
              child: isNotification ? CircularProgressIndicator(color: Colors.white,)  : Text("Add New Notification",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  fontSize: 20
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //select date
  DateTime initDate = DateTime.now();
  var selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = outputDateFormat.format(picked);
      });
    }
  }

  //select time
  TimeOfDay initTime = TimeOfDay.now();

  var selectedTime, uploadTimeToServer;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = _formatTime(picked);
        uploadTimeToServer = _formatTimeToUpload(picked);

        print("sdafds == ${uploadTimeToServer}");
      });
    }

  //select team member
}
//////////






/////////

  String _formatTimeToUpload(TimeOfDay time) {
    return '${_formatHour(time.hour)}:${_formatMinute(time.minute)}:${_formatSecond(0)}';
  }

  String _formatHour(int hour) {
    return hour < 10 ? '0$hour' : '$hour';
  }

  String _formatMinute(int minute) {
    return minute < 10 ? '0$minute' : '$minute';
  }

  String _formatSecond(int second) {
    return second < 10 ? '0$second' : '$second';
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }


  //select team member for notification
  _selectTeamMember() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
      return SizedBox(
        width: double.infinity,
        height: 500,
        child: AlertDialog(
          title:Center(),
          content: isLoading ? Center(child: CircularProgressIndicator(color: AppColor.mainColor,),) : StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 300,
                child: user!.isEmpty ? Center(child: Text("No user found."),) : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select User'),
                        TextButton(
                          onPressed: (){
                            setState(() {
                              if(_getUserToken.length >= user.length){
                                _getUserToken.clear();
                                selectedUserList.clear();
                              }else{
                                for(var i in user){
                                  selectedUserList.add(i.id.toString());
                                  _getUserToken.add(i!.deviceToken!);
                                }
                              }
                            });
                            setState((){});
                            print("object === ${_getUserToken}");
                            print("object === ${_getUserToken.length}");
                          },
                          child: Text("${_getUserToken.length >= user.length ? "Clear All" : "Select All"} "),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                      child: ListView.builder(
                        //shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: user!.length,
                        itemBuilder: (_, index){
                          return Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200
                            ),
                            child: ListTile(
                              onTap: (){
                                setState((){
                                  if(user![index]!.deviceToken != null){
                                    if(_getUserToken.contains("${user![index]!.deviceToken}")){
                                      _getUserToken.remove("${user![index]!.deviceToken}");
                                      selectedUserList.remove(user![index]!.id.toString());
                                    }else{
                                      selectedUserList.add(user![index]!.id.toString());
                                      _getUserToken.add("${user![index]!.deviceToken}");
                                    }
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("You can not send him the notification. He/She doesn't have device token."),
                                      backgroundColor: Colors.red,
                                      duration: Duration(milliseconds: 3000),
                                    ));
                                  }
                                });
                              },
                              leading: Container(
                                padding: EdgeInsets.all(4),
                                width: 50,
                                height: 50,
                                child: user![index]!.image != null ? AppNetworkImage(src: user![index]!.image!) : Icon(Icons.person, size: 30,)
                              ),
                              title: Text("${user![index]!.fname}"),
                              trailing: _getUserToken.isNotEmpty && _getUserToken.contains(user![index]!.deviceToken) ? Icon(Icons.check_circle, color: AppColor.mainColor,) : SizedBox(width: 10,),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                });
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    },
    );
  }


  //choose image
  File? _image;
  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }



  /////////////////////////////
  //////// Upload notification ////
  /////////////////////////////
  var errorDate, errorTime, errorTitle, errorMsg, errorImage, errorTeam, errorText;
  bool isNotification = false;
  void addNewNotification() async{
    setState(() => isNotification = true);

    print("selectedUserList === ${selectedUserList}");

    if(selectedDate == null){
      setState(() => errorDate = "Select Date");
    }else{
      setState(() => errorDate = null);
    }
    if(selectedTime == null){
      setState(() => errorTime = "Select Time");
    }else{
      setState(() => errorTime = null);
    }
    if(_image == null){
      setState(() => errorImage = "Choose Image");
    }else{
      setState(() => errorImage = null);
    }
    if(msg.text.isEmpty){
      setState(() => errorMsg = "Message must not be empty.");
    }else{
      setState(() => errorMsg = null);
    }
    if(title.text.isEmpty){
      setState(() => errorTitle = "Title must not be empty.");
    }else{
      setState(() => errorTitle = null);
    }
    if(selectedUserList.isEmpty){
      setState(() => errorTeam = "Select Team Members.");
    }else{
      setState(() => errorTeam = null);
    }

    if(title.text.isNotEmpty && msg.text.isNotEmpty && selectedUserList.isNotEmpty && _image != null && selectedDate !=null && selectedTime != null){
      var res = await NotificationController.createNotification(
          title: title.text,
          msg: msg.text,
          selectedTime: uploadTimeToServer,
          seletedDate: selectedDate!,
          userList: selectedUserList,
          image: _image!
      );
      if(res.statusCode == 200){
        var data = json.decode(utf8.decode(await res.stream.toBytes()));

        print("data === ${data["image"]}");
        errorTime = null;
        errorDate = null;
        errorTitle = null;
        errorMsg = null;
        errorImage = null;
        errorTeam = null;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("New Notification is create success."),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 3000),
        ));
        NotificationController.sendFCMNotification(registration_ids: _getUserToken, title: title.text, message: msg.text, image: data["image"], id: data["id"].toString(), dateTime: DateTime.parse("${data["date"]} ${data["time"]}") );
        Get.to(AppBottomNavigation());
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something went wrong."),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 3000),
        ));
      }
    }

    setState(() => isNotification = false);
  }





}















class ErrorTextBuilder extends StatelessWidget {
  ErrorTextBuilder({
    super.key,
    required this.errorTeam,
  });

  final errorTeam;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5,),
        Text("${errorTeam}",
          style: TextStyle(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            color: Colors.red
          ),
        )
      ],
    );
  }


}
