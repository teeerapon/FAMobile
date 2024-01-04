// To parse this JSON data, do
//
//     final assetsResponseModel = assetsResponseModelFromJson(jsonString);

import 'dart:convert';

AssetsResponseModel assetsResponseModelFromJson(String str) =>
    AssetsResponseModel.fromJson(json.decode(str));

String assetsResponseModelToJson(AssetsResponseModel data) =>
    json.encode(data.toJson());

class AssetsResponseModel {
  AssetsResponseModel({
    required this.message,
    required this.data,
    required this.token,
    required this.status,
    required this.date,
  });

  String message;
  List<Datum> data;
  String token;
  int status;
  DateTime date;

  factory AssetsResponseModel.fromJson(Map<String, dynamic> json) =>
      AssetsResponseModel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        token: json["token"],
        status: json["status"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "token": token,
        "status": status,
        "date": date.toIso8601String(),
      };
}

class Datum {
  Datum({
    required this.assetId,
    required this.name,
    required this.code,
    required this.branchId,
  });

  String assetId;
  String name;
  String code;
  int branchId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        assetId: json["AssetID"],
        name: json["Name"],
        code: json["Code"],
        branchId: json["BranchID"],
      );

  Map<String, dynamic> toJson() => {
        "AssetID": assetId,
        "Name": name,
        "Code": code,
        "BranchID": branchId,
      };
}
