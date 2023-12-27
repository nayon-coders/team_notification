// To parse this JSON data, do
//
//     final singleNotificationModel = singleNotificationModelFromJson(jsonString);

import 'dart:convert';

SingleNotificationModel singleNotificationModelFromJson(String str) => SingleNotificationModel.fromJson(json.decode(str));

String singleNotificationModelToJson(SingleNotificationModel data) => json.encode(data.toJson());

class SingleNotificationModel {
  final int? responseStatus;
  final int? id;
  final DateTime? date;
  final String? time;
  final String? title;
  final String? image;
  final String? message;
  final List<UserList>? userList;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? status;

  SingleNotificationModel({
    this.responseStatus,
    this.id,
    this.date,
    this.time,
    this.title,
    this.image,
    this.message,
    this.userList,
    this.updatedAt,
    this.createdAt,
    this.status,
  });

  factory SingleNotificationModel.fromJson(Map<String, dynamic> json) => SingleNotificationModel(
    responseStatus: json["response_status"],
    id: json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    title: json["title"],
    image: json["image"],
    message: json["message"],
    userList: json["user_list"] == null ? [] : List<UserList>.from(json["user_list"]!.map((x) => UserList.fromJson(x))),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "response_status": responseStatus,
    "id": id,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "title": title,
    "image": image,
    "message": message,
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
