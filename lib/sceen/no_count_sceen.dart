import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'menu_reported.dart';

// ignore: must_be_immutable
class NoCountedSceen extends StatefulWidget {
  final String assetID;
  final oCcy = NumberFormat("#,##0.00", "th");
  final String titleName;
  final String codeAssets;
  final int brachID;
  final String roundID;
  final String? detail;
  late String imagePath;
  late String imagePath_2;
  NoCountedSceen({
    Key? key,
    required this.titleName,
    required this.codeAssets,
    required this.brachID,
    required this.assetID,
    required this.detail,
    required this.roundID,
    required this.imagePath,
    required this.imagePath_2,
  }) : super(key: key);
  @override
  _NoCountedSceenState createState() => _NoCountedSceenState();
}

class _NoCountedSceenState extends State<NoCountedSceen> {
  bool checkBox1 = false;
  bool checkBox2 = false;
  bool checkBox3 = false;
  var referenceController = TextEditingController();
  String referenceSetState1 = 'QR Code ไม่สมบูรณ์ (สภาพดี)';
  String referenceSetState2 = 'QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)';
  String referenceSetState3 = 'QR Code ไม่สมบูรณ์ (รอตัดชำรุด)';
  final now = DateTime.now();
  final int status = 1;
  var titleName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: Row(children: <Widget>[
          const SizedBox(
            width: 5.0,
          ),
          IconButton(
            color: Colors.black,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: HexColor('#283B71'),
      body: assetsReported(),
    );
  }

  Widget assetsReported() {
    setState(() {
      titleName.text = widget.titleName;
    });
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 35),
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, top: 30, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.codeAssets,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        //fontStyle: FontStyle.italic,
                        fontSize: 28,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.titleName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        //fontStyle: FontStyle.italic,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'สาขาที่อยู่ของทรัพย์สิน :  ' + widget.brachID.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        //fontStyle: FontStyle.italic,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.detail.toString() == 'null'
                          ? 'สถานะล่าสุด :  '
                          : 'สถานะล่าสุด :  ' + widget.detail.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          //fontStyle: FontStyle.italic,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 20,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    items: [
                      Image.network(
                        widget.imagePath, // this image doesn't exist
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/images/ATT_220300020.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Image.network(
                        widget.imagePath_2, // this image doesn't exist
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            "assets/images/ATT_220300020.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ].map((i) {
                      return i;
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 25),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              value: checkBox1,
                              activeColor: Colors.orangeAccent,
                              splashRadius: 30,
                              onChanged: (value) {
                                setState(() {
                                  checkBox1 = value!;
                                  if (checkBox1 == false) {
                                    referenceController.clear();
                                    _createupdate();
                                  } else {
                                    checkBox2 = false;
                                    checkBox3 = false;
                                    referenceController.text =
                                        referenceSetState1.toString();
                                    _createupdate();
                                  }
                                });
                              },
                            ),
                            const Text('QR Code ไม่สมบูรณ์ (สภาพดี)',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              value: checkBox2,
                              activeColor: Colors.orangeAccent,
                              splashRadius: 30,
                              onChanged: (value) {
                                setState(() {
                                  checkBox2 = value!;
                                  if (checkBox2 == false) {
                                    referenceController.clear();
                                    _createupdate();
                                  } else {
                                    checkBox1 = false;
                                    checkBox3 = false;
                                    referenceController.text =
                                        referenceSetState2.toString();
                                    _createupdate();
                                  }
                                });
                              },
                            ),
                            const Text(
                              'QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              value: checkBox3,
                              activeColor: Colors.orangeAccent,
                              splashRadius: 30,
                              onChanged: (value) {
                                setState(() {
                                  checkBox3 = value!;
                                  if (checkBox3 == false) {
                                    referenceController.clear();
                                    _createupdate();
                                  } else {
                                    checkBox1 = false;
                                    checkBox2 = false;
                                    referenceController.text =
                                        referenceSetState3.toString();
                                    _createupdate();
                                  }
                                });
                              },
                            ),
                            const Text('QR Code ไม่สมบูรณ์ (รอตัดชำรุด)',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }

  Future<void> _createupdate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences roundid = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    var client = http.Client();
    var url = Uri.http(Config.apiURL, Config.periodLogin);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "BeginDate": now.toString(),
        "EndDate": now.toString(),
        "BranchID": widget.brachID.toInt(),
      }),
    );
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body)['PeriodRound'];
      if (items != widget.roundID) {
        setState(() {
          FormHelper.showSimpleAlertDialog(
              context,
              Config.appName,
              "ไม่สามารถบันทึกข้อมูลได้เนื่องจากรอบบันทึกไม่ถูกต้อง",
              "ยอมรับ", () {
            Navigator.pop(context);
          });
          checkBox2 = false;
        });
      } else {
        var client = http.Client();
        var url = Uri.http(Config.apiURL, Config.addAssetsAPI);
        var response = await client.post(
          url,
          headers: requestHeaders,
          body: jsonEncode({
            "Name": widget.titleName,
            "Code": widget.codeAssets,
            "BranchID": widget.brachID.toInt(),
            "Date": '$now',
            "Status": status,
            "UserID": pref.getString("UserID")!,
            "UserBranch": widget.brachID,
            "RoundID": roundid.getString("RoundID")!,
            "Reference": referenceController.text,
          }),
        );
        if (response.statusCode == 200) {
          final items = jsonDecode(response.body);
          setState(() {
            FormHelper.showSimpleAlertDialog(
                context, Config.appName, items['message'], "ยอมรับ", () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewDetails(
                    period_round: roundid.getString("RoundID")!,
                    beginDate: now.toString(),
                    endDate: now.toString(),
                    branchPermission: widget.brachID,
                  ),
                ),
              );
            });
          });
        } else {
          setState(() {
            FormHelper.showSimpleAlertDialog(
                context,
                Config.appName,
                'มีการบันทึกทรัพย์สินนี้ ในรอบที่ ' +
                    roundid.getString("RoundID").toString() +
                    ' ไปแล้ว',
                "ยอมรับ", () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewDetails(
                    period_round: roundid.getString("RoundID")!,
                    beginDate: now.toString(),
                    endDate: now.toString(),
                    branchPermission: widget.brachID,
                  ),
                ),
              );
            });
          });
        }
      }
    } else {
      setState(() {
        var items = jsonDecode(response.body)['data'];
        FormHelper.showSimpleAlertDialog(context, Config.appName,
            "ไม่สามารถบันทึกข้อมูลได้เนื่องจาก $items", "ยอมรับ", () {
          Navigator.pop(context);
        });
      });
    }
  }
}
