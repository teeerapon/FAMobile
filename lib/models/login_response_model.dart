// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString)

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  LoginResponseModel({
    required this.message,
    required this.data,
    required this.token,
  });

  String message;
  List<Datum> data;
  String token;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "token": token,
      };
}

class Datum {
  Datum({
    required this.userid,
    required this.name,
    required this.userCode,
    required this.ad,
    required this.dep,
    required this.depid,
    required this.branchid,
    required this.secid,
    required this.positionId,
    required this.areaid,
    required this.password,
    required this.changepassword,
  });

  String userid;
  String name;
  String userCode;
  String? ad;
  String? dep;
  int? depid;
  int branchid;
  int? secid;
  int? positionId;
  int? areaid;
  int password;
  bool changepassword;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userid: json["userid"],
        name: json["name"],
        userCode: json["UserCode"],
        ad: json["ad"],
        dep: json["dep"],
        depid: json["depid"],
        branchid: json["branchid"],
        secid: json["secid"],
        positionId: json["PositionID"],
        areaid: json["areaid"],
        password: json["password"],
        changepassword: json["changepassword"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "name": name,
        "UserCode": userCode,
        "ad": ad,
        "dep": dep,
        "depid": depid,
        "branchid": branchid,
        "secid": secid,
        "PositionID": positionId,
        "areaid": areaid,
        "password": password,
        "changepassword": changepassword,
      };
}


// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);
