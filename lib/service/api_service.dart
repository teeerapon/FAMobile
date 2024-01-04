import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_flutter_test/config.dart';
import 'package:new_flutter_test/models/login_request_model.dart';
import 'package:new_flutter_test/models/login_response_model.dart';
import 'package:new_flutter_test/service/shared_service.dart';
import '../models/asset_reponse_model.dart';
import '../models/asset_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  static var client = http.Client();
  //login#1
  static Future<bool> login(LoginRequstModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };

    var url = Uri.http(Config.apiURL, Config.loginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      //SHARED
      await SharedService.setLoginDetails(
          loginResponseModelFromJson(response.body));
      final body = jsonDecode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("UserCode", body['data'][0]['UserCode']);
      await pref.setString("UserID", body['data'][0]['userid']);
      await pref.setInt("BranchID", body['data'][0]['branchid']);
      await pref.setString("Date_Login", body['date']);
      return true;
    } else {
      return false;
    }
  }

  // static pageRoute(body) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   await pref.setString("UserCode", body['data'][0]['UserCode']);
  //   await pref.setString("UserID", body['data'][0]['userid']);
  //   await pref.setInt("BranchID", body['data'][0]['branchid']);
  //   await pref.setString("Date_Login", body['date']);
  // }

  //login#2
  static Future<String> getUserProfile() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'Basic ${loginDetails!.token}'
    };

    var url = Uri.http(Config.apiURL, Config.profileAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }

  //Assets#1
  static Future<bool> assets(AssetsRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=utf-8',
    };

    var url = Uri.http(Config.apiURL, Config.assetsAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      //SHARED
      // final itemsResponse = jsonDecode(response.body);
      await SharedService.setAssetsDetails(
          assetsResponseModelFromJson(response.body));
      return true;
    } else {
      return false;
    }
  }
}
