// ignore_for_file: file_names, unnecessary_new, unused_field, non_constant_identifier_names, unused_import
import 'dart:convert';
import 'package:fa_mobile_app/sceen/listAllassets.dart';
import 'package:flutter/material.dart';
import 'package:fa_mobile_app/sceen/check_code.dart';
import 'package:fa_mobile_app/service/shared_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

import '../config.dart';
import 'menu.dart';

class PermissionBranch extends StatefulWidget {
  const PermissionBranch({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PermissionBranchState createState() => _PermissionBranchState();
}

class _PermissionBranchState extends State<PermissionBranch> {
  int? _mySelection;
  String? res_Detail;
  String? date_login;
  List permission_branch = [];
  String? userCode;
  int? userBranch;
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globaAssetsFormkey = GlobalKey<FormState>();
  String? resultScan;
  bool _visibleRead = false;
  final now = DateTime.now();
  String? round;

  @override
  dynamic initState() {
    super.initState();
    getperMissionBranch();
    getround();
  }

  void getperMissionBranch() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userCode = pref.getString("UserCode")!;
      userBranch = pref.getInt("BranchID")!;
    });
    if (date_login.toString().isNotEmpty) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.permissionBranch);
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "userCode": userCode,
        }),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body)['data'];
        if (body[0]['result'] != 'non') {
          setState(() {
            permission_branch = body;
            _visibleRead = true;
          });
        }
      }
    }
  }

  void getround() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    if (date_login.toString().isNotEmpty) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.periodLogin);
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "BranchID": userBranch,
          "BeginDate": now.toString(),
          "EndDate": now.toString(),
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          round = jsonDecode(response.body)['PeriodRound'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Initial: $userCode (${userBranch == 901 ? "HO" : userBranch})",
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(40, 59, 113, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                FormHelper.showSimpleAlertDialog(
                    context, Config.appName, "คุณออกจากระบบแล้ว", "ยอมรับ", () {
                  SharedService.logout(context);
                });
              },
              icon: const Icon(Icons.logout),
              color: const Color.fromRGBO(40, 59, 113, 1),
              iconSize: 28,
            )
          ],
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          inAsyncCall: isAPIcallProcess,
          opacity: 0,
          key: UniqueKey(),
          child: Form(
            key: globaAssetsFormkey,
            child: _detail(),
          ),
        ),
      ),
    );
  }

  Widget _detail() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 35),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/purethai.png",
                      // width: 250,
                      // height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 35, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "ยินดีต้อนรับสู่ แอปพลิเคชัน",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "กรุณาเลือกเมนู ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xffa29aac)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  userBranch == 901
                      ? Visibility(
                          visible: _visibleRead,
                          child: Card(
                            color: HexColor('#EAC435'),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: HexColor('#EAC435'),
                                  borderRadius: BorderRadius.circular(22.0)),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    child: const Icon(
                                      Icons.menu,
                                      color: Color.fromRGBO(40, 59, 113, 1),
                                      size: 30.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [
                                              const Text(
                                                'เลือกสาขาเพื่อระบุสาขาของเมนูถัดไป',
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              DropdownButton(
                                                dropdownColor:
                                                    HexColor('#EAC435'),
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 36.0,
                                                underline: const SizedBox(),
                                                hint: const Text(
                                                  'นับทรัพย์สิน',
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        40, 59, 113, 1),
                                                  ),
                                                ),
                                                items: permission_branch
                                                    .map((item) {
                                                  return DropdownMenuItem(
                                                    value: item['BranchID'],
                                                    child: Text(
                                                      'สาขาที่ ${item['BranchID'] == 901 ? 'HO' : item['BranchID']}',
                                                      style: const TextStyle(
                                                        fontSize: 25.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromRGBO(
                                                            40, 59, 113, 1),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                focusColor:
                                                    const Color.fromRGBO(
                                                        40, 59, 113, 1),
                                                iconEnabledColor:
                                                    const Color.fromRGBO(
                                                        40, 59, 113, 1),
                                                onChanged: (newVal) {
                                                  setState(() {
                                                    _mySelection =
                                                        newVal as int;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => Scanner(
                                                          brachID:
                                                              _mySelection!,
                                                          dateTimeNow:
                                                              now.toString(),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                                value: _mySelection,
                                              ),
                                              const SizedBox(height: 6),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Visibility(
                          visible: _visibleRead,
                          child: Card(
                            color: HexColor('#EAC435'),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            elevation: 4.0,
                            child: InkWell(
                              focusColor: const Color.fromRGBO(40, 59, 113, 1),
                              hoverColor: const Color.fromRGBO(40, 59, 113, 1),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Scanner(
                                      brachID: userBranch!,
                                      dateTimeNow: now.toString(),
                                    ),
                                  ),
                                );
                              },
                              splashColor: const Color.fromRGBO(40, 59, 113, 1),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15.0),
                                decoration: BoxDecoration(
                                    color: HexColor('#EAC435'),
                                    borderRadius: BorderRadius.circular(22.0)),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      child: const Icon(
                                        Icons.skip_next,
                                        color: Color.fromRGBO(40, 59, 113, 1),
                                        size: 32.0,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'สแกนเพื่อตรวจสอบข้อมูลทรัพย์สิน',
                                                  style: TextStyle(
                                                    color: Colors.black38,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  "นับทรัพย์สิน",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        40, 59, 113, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      elevation: 4.0,
                      child: InkWell(
                        focusColor: const Color.fromRGBO(40, 59, 113, 1),
                        hoverColor: const Color.fromRGBO(40, 59, 113, 1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListAllAssets(
                                branchPermission: userBranch ?? 0,
                              ),
                            ),
                          );
                        },
                        splashColor: const Color.fromRGBO(40, 59, 113, 1),
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.0)),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: const Icon(
                                  Icons.list_alt_outlined,
                                  color: Color.fromRGBO(40, 59, 113, 1),
                                  size: 32.0,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            'เมนูสำหรับดูรายการทรัพย์สินของ $userCode',
                                            style: const TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "ทรัพย์สินทั้งหมดของ $userCode",
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  40, 59, 113, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      elevation: 4.0,
                      child: InkWell(
                        focusColor: const Color.fromRGBO(40, 59, 113, 1),
                        hoverColor: const Color.fromRGBO(40, 59, 113, 1),
                        onTap: () {
                          checkQR();
                        },
                        splashColor: const Color.fromRGBO(40, 59, 113, 1),
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.0)),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: const Icon(
                                  Icons.document_scanner,
                                  color: Color.fromRGBO(40, 59, 113, 1),
                                  size: 32.0,
                                ),
                              ),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          Text(
                                            'สแกนเพื่อตรวจสอบข้อมูลทรัพย์สิน',
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "ตรวจสอบ QR Code",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  40, 59, 113, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Future<void> checkQR() async {
    var open_camera = await Permission.camera.status;
    if (open_camera.isGranted) {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        resultScan = cameraScanResult!;
      });
      if (resultScan.toString().isNotEmpty) {
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json; charset=utf-8',
        };
        var client = http.Client();
        var url = Uri.http(Config.apiURL, Config.checkCodeResult);

        var response = await client.post(
          url,
          headers: requestHeaders,
          body: jsonEncode({
            "Code": resultScan,
            "RoundID": round,
          }),
        );
        if (response.statusCode == 200) {
          setState(() {
            dynamic itemsResponse = jsonDecode(response.body)['data'][0];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckCode(
                  titleName: itemsResponse['Name'],
                  codeAssets: itemsResponse['Code'],
                  detail: itemsResponse['detail'] ?? 'ยังไม่ได้ระบุสถานะ',
                  ownerCode: itemsResponse['ownerCode'],
                  brachID: itemsResponse['BranchID'],
                  brachName: itemsResponse['BranchName'],
                  images: itemsResponse['ImagePath'].toString(),
                  imagePath_2: itemsResponse['ImagePath_2'].toString(),
                ),
              ),
            );
          });
        } else {
          dynamic itemsResponse = jsonDecode(response.body);
          // ignore: use_build_context_synchronously
          FormHelper.showSimpleAlertDialog(
              context,
              Config.appName,
              itemsResponse['message'].toString() +
                  itemsResponse['data'].toString(),
              "ยอมรับ", () {
            Navigator.pop(context);
          });
        }
      } else {
        // ignore: use_build_context_synchronously
        FormHelper.showSimpleAlertDialog(
            context, Config.appName, 'กรุณาสแกน Code บ้างอย่าง', "OK", () {
          Navigator.pop(context);
        });
      }
    } else if (open_camera.isDenied) {
      if (await Permission.camera.request().isGranted) {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          resultScan = cameraScanResult!;
        });
        if (resultScan.toString().isNotEmpty) {
          Map<String, String> requestHeaders = {
            'Content-Type': 'application/json; charset=utf-8',
          };
          var client = http.Client();
          var url = Uri.http(Config.apiURL, Config.checkCodeResult);

          var response = await client.post(
            url,
            headers: requestHeaders,
            body: jsonEncode({
              "Code": resultScan,
              "RoundID": round,
            }),
          );
          if (response.statusCode == 200) {
            setState(() {
              dynamic itemsResponse = jsonDecode(response.body)['data'][0];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckCode(
                    titleName: itemsResponse['Name'],
                    codeAssets: itemsResponse['Code'],
                    detail: itemsResponse['detail'] ?? 'ยังไม่ได้ระบุสถานะ',
                    ownerCode: itemsResponse['ownerCode'],
                    brachID: itemsResponse['BranchID'],
                    brachName: itemsResponse['BranchName'],
                    images: itemsResponse['ImagePath'].toString(),
                    imagePath_2: itemsResponse['ImagePath_2'].toString(),
                  ),
                ),
              );
            });
          } else {
            dynamic itemsResponse = jsonDecode(response.body);
            // ignore: use_build_context_synchronously
            FormHelper.showSimpleAlertDialog(
                context,
                Config.appName,
                itemsResponse['message'].toString() +
                    itemsResponse['data'].toString(),
                "ยอมรับ", () {
              Navigator.pop(context);
            });
          }
        } else {
          // ignore: use_build_context_synchronously
          FormHelper.showSimpleAlertDialog(
              context, Config.appName, 'กรุณาสแกน Code บ้างอย่าง', "OK", () {
            Navigator.pop(context);
          });
        }
      }
    }
  }
}
