import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:userapp/controller/notification_controller/notification_controller.dart';
import 'package:userapp/model/notification_model/notification_model.dart';
import 'package:userapp/model/notification_model/single_notification_model.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/widget/rich_text.dart';

class ViewNotification extends StatefulWidget {
  final String notificationId;
  const ViewNotification({Key? key, required this.notificationId}) : super(key: key);

  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  var outputDateFormat = DateFormat('MMM dd, yyyy');

  Future<SingleNotificationModel>? getNotification;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification = NotificationController.getSingleNotification(id: widget.notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text("View Notification"),
      ),
      body: FutureBuilder<SingleNotificationModel>(
        future: getNotification,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: AppColor.mainColor,),);
          }else if(snapshot.hasData){
            var data = snapshot.data!;
            return SingleChildScrollView(

              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AppRichText(
                    leftText: "Date: ",
                    rightText: "${outputDateFormat.format(data.date!)}",
                  ),
                  SizedBox(height: 10,),
                  AppRichText(
                    leftText: "Time: ",
                    rightText: "${data.time}",
                  ),
                  SizedBox(height: 20,),
                  Text("Title: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 7,),
                  Text("${data.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Messages: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 7,),
                  Text("${data.message}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Image: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Image.network("${data.image}",
                    width: 250,
                    height: 150,
                  ),
                  SizedBox(height: 20,),
                  Text("Team Members: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 7,),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        mainAxisExtent: 30
                    ),
                    itemCount: data.userList!.length,
                    itemBuilder: (context, index) {
                      var singleUser =  data.userList![index];
                      return Container(
                        height: 20,
                        color: Colors.blue.shade200,
                        child: Center(child: Text("${singleUser.fname} ${singleUser.lname}",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )),
                      );
                    },
                  )

                ],
              ),
            );
          }else{
            return Center(child: Text("Something went wrong."),);
          }
        }
      ),
    ); 
  }
}

