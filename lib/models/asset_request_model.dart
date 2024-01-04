// To parse this JSON data, do
//
//     final assetsRequestModel = assetsRequestModelFromJson(jsonString);
import 'dart:convert';

AssetsRequestModel assetsRequestModelFromJson(String str) =>
    AssetsRequestModel.fromJson(json.decode(str));

String assetsRequestModelToJson(AssetsRequestModel data) =>
    json.encode(data.toJson());

class AssetsRequestModel {
  AssetsRequestModel({
    required this.code,
  });

  String code;

  factory AssetsRequestModel.fromJson(Map<String, dynamic> json) =>
      AssetsRequestModel(
        code: json["Code"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
      };
}
