import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/app_config.dart';
import 'package:userapp/controller/notification_controller/notification_controller.dart';
import 'package:userapp/controller/user_controller/userController.dart';
import 'package:userapp/model/notification_model/notification_model.dart';
import 'package:userapp/model/user_model/user_model.dart';
import 'package:userapp/utilitys/app_color.dart';
import 'package:userapp/view/notification/view_notification.dart';
import 'package:intl/intl.dart';
import '../notification/admin_set_notification.dart';
import '../notification/edit_notification.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  Future<UserListModel>? getUserModel;
  Future<NotificationListModel>? _getNotificationModel;

  var outputDateFormat = DateFormat('MMM dd,\n yyyy');

  var email, full_name, user_id;
  List<NotificationDetum> _allNotification = [];
  bool isLoading = false;
  getLoginUserInfo()async{
    setState(() => isLoading = true);
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      email = _pref.getString("email");
      full_name = _pref.getString("full_name");

      user_id = _pref.getString("user_id");
    });
      var res = await NotificationController.getNotificationList();
      for(var i in res.notification!){
        if(email == AppConfig.ADMIN_MIAL){
          setState(() {
            _allNotification.add(i);
          });
        }else{
          //now check user notification
          for(var j in i.userList!){
            if(j.id.toString() == user_id.toString()){
              _allNotification.add(i);
            }
          }
        }
      }
    setState(() => isLoading = false);

  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginUserInfo();
    _getNotificationModel = NotificationController.getNotificationList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: isLoading ? Center(child: CircularProgressIndicator(color: AppColor.mainColor,),) : SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Hey, $full_name",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 25
              ),
            ),

            email != null && email == AppConfig.ADMIN_MIAL ?  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text("Admin Dashboard",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 30
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: ()=>Get.to( AdminSetNotificaion(),),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            spreadRadius: 2,
                            blurRadius: 3,
                          )
                        ]
                    ),
                    child: ListTile(
                      title: Text("Set a new notification",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17
                        ),
                      ),
                      trailing: Icon(Icons.double_arrow),
                    ),
                  ),
                ),
              ],
            ) : Center(),

            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(email != null && email == AppConfig.ADMIN_MIAL ? "All Notification" : "My Notification",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 20
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(left: 20, right: 20),
                //   decoration: BoxDecoration(
                //     color: Colors.blue.shade100,
                //     borderRadius: BorderRadius.circular(10)
                //   ),
                //   child: TextButton(
                //     onPressed: (){},
                //     child: Text("View All"),
                //   ),
                // )
              ],
            ),


            _allNotification !=null && _allNotification!.isNotEmpty
                ? SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _allNotification!.length,
                itemBuilder: (_, index){
                  var data = _allNotification![index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 3,
                              spreadRadius: 2
                          )
                        ]
                    ),
                    child: ListTile(
                      leading: Text("${outputDateFormat.format(data!.date!)}"),
                      title: Text("${data.title}",),
                      subtitle: Text("${data!.message}"),
                      trailing: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: ()=>Get.to(EditNotification(notification: data,)),
                              child: Icon(Icons.edit, size: 20, color: Colors.amber,),
                            ),
                            InkWell(
                              onTap: ()=>Get.to(ViewNotification(notificationId: data.id.toString(),)),
                              child: Icon(Icons.remove_red_eye, size: 20, color: Colors.green,),
                            ),
                            InkWell(
                              onTap: ()=> showDeletePoup(data!.id.toString()),
                              child: Icon(Icons.delete, size: 20, color: Colors.red,),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : SizedBox(height: 600, child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/nodata.jpeg", height: 200, width: 200,),
                    Text("You don't have any notification."),
                  ],
                ),),)

          ],
        ),
      ),
    );
  }


  //show alert for delete notification
   showDeletePoup(id) async{
     return showDialog<void>(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Delete Notification.'),
           content: SingleChildScrollView(
             child: ListBody(
               children: <Widget>[
                 Text('Any you sure? Do you want to delete this notification?'),
               ],
             ),
           ),
           actions: <Widget>[
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: Text('No'),
             ),
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
                 _deleteNotification(id);
               },
               child: Text('Yes'),
             ),
           ],
         );
       },
     );
   }


   //delete notification
  bool isDelete = false;
  void _deleteNotification(id) async{
    setState(() =>isDelete=true);
    deleteLoading();
    var res = await NotificationController.deleteNotification(id: id);
    if(res.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Notification Delete Success."),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 3000),
      ));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong."),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 3000),
      ));
    }
    _getNotificationModel = NotificationController.getNotificationList();
    Navigator.pop(context);
    setState(() =>isDelete=false);
  }

  deleteLoading() async{
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deleting...'),
          content: SizedBox(height: 140, child: Center(child: CircularProgressIndicator(color: AppColor.mainColor,),)),
        );
      },
    );
  }

}

