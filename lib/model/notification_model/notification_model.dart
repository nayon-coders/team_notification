// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationListModel {
  final List<NotificationDetum>? notification;

  NotificationListModel({
    this.notification,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    notification: json["Notification"] == null ? [] : List<NotificationDetum>.from(json["Notification"]!.map((x) => NotificationDetum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Notification": notification == null ? [] : List<dynamic>.from(notification!.map((x) => x.toJson())),
  };
}

class NotificationDetum {
  final int? id;
  final DateTime? date;
  final String? time;
  final String? title;
  final String? message;
  final String? image;
  final List<UserList>? userList;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? status;

  NotificationDetum({
    this.id,
    this.date,
    this.time,
    this.title,
    this.message,
    this.image,
    this.userList,
    this.updatedAt,
    this.createdAt,
    this.status,
  });

  factory NotificationDetum.fromJson(Map<String, dynamic> json) => NotificationDetum(
    id: json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    title: json["title"],
    message: json["message"],
    image: json["image"],
    userList: json["user_list"] == null ? [] : List<UserList>.from(json["user_list"]!.map((x) => UserList.fromJson(x))),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "title": title,
    "message": message,
    "image": image,
    "user_list": userList == null ? [] : List<dynamic>.from(userList!.map((x) => x.toJson())),
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "status": status,
  };
}

class UserList {
  final int? id;
  final String? fname;
  final String? lname;
  final String? deviceToken;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserList({
    this.id,
    this.fname,
    this.lname,
    this.deviceToken,
    this.email,
    this.emailVerifiedAt,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
    id: json["id"],
    fname: json["fname"],
    lname: json["lname"],
    deviceToken: json["device_token"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fname": fname,
    "lname": lname,
    "device_token": deviceToken,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
