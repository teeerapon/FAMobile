// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:fa_mobile_app/models/login_response_model.dart';

import '../models/asset_reponse_model.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    var isKeyExit = await APICacheManager().isAPICacheKeyExist("login_details");

    return isKeyExit;
  }

  static Future<LoginResponseModel?> loginDetails() async {
    var isKeyExit = await APICacheManager().isAPICacheKeyExist("login_details");

    if (isKeyExit) {
      var cacheData = await APICacheManager().getCacheData("login_details");
      return loginResponseModelFromJson(cacheData.syncData);
    }
    return null;
  }

  static Future<void> setLoginDetails(
    LoginResponseModel model,
  ) async {
    APICacheDBModel cacheDBModel = APICacheDBModel(
      key: "login_details",
      syncData: jsonEncode(model.toJson()),
    );

    await APICacheManager().addCacheData(cacheDBModel);
  }

  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login_details");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  //Assets
  static Future<bool> isAssets() async {
    var assetsIsKeyExit =
        await APICacheManager().isAPICacheKeyExist("assets_details");
    return assetsIsKeyExit;
  }

  static Future<AssetsResponseModel?> assetsDetails() async {
    var assetsIsKeyExit =
        await APICacheManager().isAPICacheKeyExist("assets_details");

    if (assetsIsKeyExit) {
      var cacheAssets = await APICacheManager().getCacheData("assets_details");

      return assetsResponseModelFromJson(cacheAssets.syncData);
    }
    return null;
  }

  static Future<void> setAssetsDetails(
    AssetsResponseModel model,
  ) async {
    APICacheDBModel cacheAssetsDBModel = APICacheDBModel(
      key: "assets_details",
      syncData: jsonEncode(model.toJson()),
    );

    await APICacheManager().addCacheData(cacheAssetsDBModel);
  }

  static Future<void> assetOut(BuildContext context) async {
    await APICacheManager().deleteCache("assets_details");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/scanner/scanner_and_details',
      (route) => false,
    );
  }
}
