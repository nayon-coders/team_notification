// To parse this JSON data, do
//
//     final singleUserInfo = singleUserInfoFromJson(jsonString);

import 'dart:convert';

SingleUserInfo singleUserInfoFromJson(String str) => SingleUserInfo.fromJson(json.decode(str));

String singleUserInfoToJson(SingleUserInfo data) => json.encode(data.toJson());

class SingleUserInfo {
  final User? user;

  SingleUserInfo({
    this.user,
  });

  factory SingleUserInfo.fromJson(Map<String, dynamic> json) => SingleUserInfo(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class User {
  final int? id;
  final String? fname;
  final String? lname;
  final String? deviceToken;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
