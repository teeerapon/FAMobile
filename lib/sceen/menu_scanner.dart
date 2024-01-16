// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:fa_mobile_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'menu.dart';

class TestAsset extends StatefulWidget {
  final int branchPermission;
  final String dateTimeNow;
  const TestAsset({
    Key? key,
    required this.branchPermission,
    required this.dateTimeNow,
  }) : super(key: key);

  @override
  _TestAssetState createState() => _TestAssetState();
}

class _TestAssetState extends State<TestAsset> {
  GlobalKey<FormState> codeFormkey = GlobalKey<FormState>();
  bool isAPIcallProcessAssets = false;
  var codeController = TextEditingController();
  var nameController = TextEditingController();
  var branchController = TextEditingController();
  var dateTimeController = TextEditingController();
  int statusController = 1;
  var assetIDController = TextEditingController();
  var referenceController = TextEditingController();
  String referenceSetState1 = "สภาพดี";
  String referenceSetState2 = "ชำรุดรอซ่อม";
  String referenceSetState3 = "รอตัดชำรุด";
  String referenceSetState4 = "รอตัดขาย";
  String referenceSetState5 = "อื่น ๆ";
  bool checkBox1 = false;
  bool checkBox2 = false;
  bool checkBox3 = false;
  bool checkBox4 = false;
  bool checkBox5 = false;
  String? moneyController;
  var imagePath = TextEditingController();
  var imagePath_2 = TextEditingController();
  String? userID;
  int? userBranch;
  String? userCode;
  int userBranchID = 0;
  bool _visible = false;
  dynamic itemOfName = [];
  var round_id = TextEditingController();
  var now = DateTime.now();

  @override
  dynamic initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userBranch = pref.getInt("BranchID")!;
      userCode = pref.getString("UserCode")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Row(children: <Widget>[
            const SizedBox(
              width: 5.0,
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(40, 59, 113, 1),
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scanner(
                      brachID: widget.branchPermission,
                      dateTimeNow: now.toString(),
                    ),
                  ),
                );
              },
            ),
          ]),
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: codeFormkey,
            child: _scanner(context),
          ),
          inAsyncCall: isAPIcallProcessAssets,
          opacity: 0,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _scanner(BuildContext context) {
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
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 35, right: 16),
                child: Text(
                  'กดที่ สแกน QR CODE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 16),
                child: Text(
                  'เพื่อทำการเปิดกล้อง',
                  style: TextStyle(
                      color: Color(0xffa29aac),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      controller: codeController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Code",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.subtitles_rounded,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      controller: nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "ชื่อ",
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.subtitles_rounded,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: TextField(
                            readOnly: true,
                            textAlign: TextAlign.center,
                            controller: branchController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: "สาขา",
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.subtitles_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextField(
                            readOnly: true,
                            textAlign: TextAlign.center,
                            controller: dateTimeController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1))),
                                labelText: "วันที่และเวลา",
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.subtitles_rounded,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 250.0,
                        viewportFraction: 1,
                        autoPlay: true,
                      ),
                      items: [
                        Image.network(
                          imagePath.text, // this image doesn't exist
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
                          imagePath_2.text, // this image doesn't exist
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
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _visible,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.white),
                          child: Row(
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
                                      _update();
                                    } else {
                                      checkBox2 = false;
                                      checkBox3 = false;
                                      checkBox4 = false;
                                      checkBox5 = false;
                                      referenceController.text =
                                          referenceSetState1.toString();
                                      _update();
                                    }
                                  });
                                },
                              ),
                              const Text('สภาพดี',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.white),
                          child: Row(
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
                                      _update();
                                    } else {
                                      checkBox1 = false;
                                      checkBox3 = false;
                                      checkBox4 = false;
                                      checkBox5 = false;
                                      referenceController.text =
                                          referenceSetState2.toString();
                                      _update();
                                    }
                                  });
                                },
                              ),
                              const Text('ชำรุดรอซ่อม',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.white),
                          child: Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                value: checkBox4,
                                activeColor: Colors.orangeAccent,
                                splashRadius: 30,
                                onChanged: (value) {
                                  setState(() {
                                    checkBox4 = value!;
                                    if (checkBox4 == false) {
                                      referenceController.clear();
                                      _update();
                                    } else {
                                      checkBox1 = false;
                                      checkBox2 = false;
                                      checkBox3 = false;
                                      checkBox5 = false;
                                      referenceController.text =
                                          referenceSetState4.toString();
                                      _update();
                                    }
                                  });
                                },
                              ),
                              const Text(
                                'รอตัดขาย',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.white),
                          child: Row(
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
                                      _update();
                                    } else {
                                      checkBox1 = false;
                                      checkBox2 = false;
                                      checkBox4 = false;
                                      checkBox5 = false;
                                      referenceController.text =
                                          referenceSetState3.toString();
                                      _update();
                                    }
                                  });
                                },
                              ),
                              const Text(
                                'รอตัดชำรุด',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        // Theme(
                        //   data: Theme.of(context)
                        //       .copyWith(unselectedWidgetColor: Colors.white),
                        //   child: Row(
                        //     children: [
                        //       Checkbox(
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         value: checkBox5,
                        //         activeColor: Colors.orangeAccent,
                        //         splashRadius: 30,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             checkBox5 = value!;
                        //             if (checkBox5 == false) {
                        //               referenceController.clear();
                        //               _update();
                        //             } else {
                        //               checkBox1 = false;
                        //               checkBox3 = false;
                        //               checkBox2 = false;
                        //               checkBox4 = false;
                        //               referenceController.text =
                        //                   referenceSetState5.toString();
                        //               _update();
                        //               _visible_comment = true;
                        //             }
                        //           });
                        //         },
                        //       ),
                        //       const Text(
                        //         'อื่น ๆ',
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.w500),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                elevation: 4.0,
                child: InkWell(
                  focusColor: const Color.fromRGBO(40, 59, 113, 1),
                  hoverColor: const Color.fromRGBO(40, 59, 113, 1),
                  onTap: () {
                    startScan();
                  },
                  splashColor: const Color.fromRGBO(45, 69, 135, 1),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            color: Color.fromRGBO(40, 59, 113, 1),
                            size: 40.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: const [
                                    Text(
                                      'สแกนนับทรัพย์สินและการทำบันทึก',
                                      style: TextStyle(color: Colors.black38),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "สแกน QR CODE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(40, 59, 113, 1),
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
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //Scan
  Future<void> startScan() async {
    setState(() {
      checkBox1 = false;
      checkBox2 = false;
      checkBox3 = false;
      _visible = false;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences roundid = await SharedPreferences.getInstance();
    try {
      var open_camera = await Permission.camera.status;
      if (open_camera.isGranted) {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          codeController.text = cameraScanResult!;
        });

        if (codeController.text.isNotEmpty) {
          Map<String, String> requestHeaders = {
            'Content-Type': 'application/json; charset=utf-8',
          };
          var client = http.Client();
          var url = Uri.http(Config.apiURL, Config.assetsAPI);

          var response = await client.post(
            url,
            headers: requestHeaders,
            body: jsonEncode({
              "Code": codeController.text,
              "UserBranch": widget.branchPermission,
              "RoundID": roundid.getString("RoundID")!,
            }),
          );
          if (response.statusCode == 200) {
            dynamic itemsResponse = jsonDecode(response.body);
            setState(() {
              imagePath.text = itemsResponse['data'][0]['ImagePath'].toString();
              imagePath_2.text =
                  itemsResponse['data'][0]['ImagePath_2'].toString();
              nameController.text = itemsResponse['data'][0]['Name'];
              dateTimeController.text = '$now';
              branchController.text =
                  itemsResponse['data'][0]['BranchID'].toString();
              assetIDController.text =
                  itemsResponse['data'][0]['AssetID'].toString();
              userID = pref.getString("UserID")!;
              userBranchID = pref.getInt("BranchID")!;
              round_id.text = roundid.getString("RoundID")!;
              referenceController.text = "ไม่ได้ระบุสถานะ";
            });
            if (codeController.text.isNotEmpty &&
                nameController.text.isNotEmpty &&
                branchController.text.isNotEmpty &&
                dateTimeController.text.isNotEmpty &&
                assetIDController.text.isNotEmpty &&
                userID.toString().isNotEmpty) {
              var client = http.Client();
              var url = Uri.http(Config.apiURL, Config.addAssetsAPI);
              var response = await client.post(
                url,
                headers: requestHeaders,
                body: jsonEncode({
                  "Name": nameController.text,
                  "Code": codeController.text,
                  "BranchID": branchController.text,
                  "Date": dateTimeController.text,
                  "Status": statusController,
                  "UserID": userID,
                  "UserBranch": widget.branchPermission,
                  "RoundID": round_id.text,
                  "Reference": referenceController.text,
                }),
              );
              if (response.statusCode == 200) {
                setState(() {
                  _visible = true;
                });
              } else {
                _visible = false;
                dynamic itemsResponse = jsonDecode(response.body);
                FormHelper.showSimpleAlertDialog(
                    context, Config.appName, itemsResponse['message'], "ยอมรับ",
                    () {
                  Navigator.pop(context);
                  setState(() {
                    assetIDController.clear();
                    codeController.clear();
                    nameController.clear();
                    branchController.clear();
                    dateTimeController.clear();
                    imagePath.clear();
                    imagePath_2.clear();
                  });
                });
              }
            }
          } else {
            dynamic itemsResponse = jsonDecode(response.body);
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
          FormHelper.showSimpleAlertDialog(
              context, Config.appName, "กรุณาใส่ข้อมูล", "ยอมรับ", () {
            Navigator.pop(context);
          });
        }
      } else if (open_camera.isDenied) {
        if (await Permission.camera.request().isGranted) {
          String? cameraScanResult = await scanner.scan();
          setState(() {
            codeController.text = cameraScanResult!;
          });

          if (codeController.text.isNotEmpty) {
            Map<String, String> requestHeaders = {
              'Content-Type': 'application/json; charset=utf-8',
            };
            var client = http.Client();
            var url = Uri.http(Config.apiURL, Config.assetsAPI);

            var response = await client.post(
              url,
              headers: requestHeaders,
              body: jsonEncode({
                "Code": codeController.text,
                "UserBranch": widget.branchPermission,
                "RoundID": roundid.getString("RoundID")!,
              }),
            );
            if (response.statusCode == 200) {
              dynamic itemsResponse = jsonDecode(response.body);
              setState(() {
                nameController.text = itemsResponse['data'][0]['Name'];
                dateTimeController.text = '$now';
                branchController.text =
                    itemsResponse['data'][0]['BranchID'].toString();
                assetIDController.text =
                    itemsResponse['data'][0]['AssetID'].toString();
                userID = pref.getString("UserID")!;
                userBranchID = pref.getInt("BranchID")!;
                round_id.text = roundid.getString("RoundID")!;
                referenceController.text = "ไม่ได้ระบุสถานะ";
              });
              if (codeController.text.isNotEmpty &&
                  nameController.text.isNotEmpty &&
                  branchController.text.isNotEmpty &&
                  dateTimeController.text.isNotEmpty &&
                  assetIDController.text.isNotEmpty &&
                  userID.toString().isNotEmpty) {
                var client = http.Client();
                var url = Uri.http(Config.apiURL, Config.addAssetsAPI);
                var response = await client.post(
                  url,
                  headers: requestHeaders,
                  body: jsonEncode({
                    "Name": nameController.text,
                    "Code": codeController.text,
                    "BranchID": branchController.text,
                    "Date": dateTimeController.text,
                    "Status": statusController,
                    "UserID": userID,
                    "UserBranch": widget.branchPermission,
                    "RoundID": round_id.text,
                    "Reference": referenceController.text,
                  }),
                );
                if (response.statusCode == 200) {
                  setState(() {
                    _visible = true;
                  });
                } else {
                  _visible = false;
                  dynamic itemsResponse = jsonDecode(response.body);
                  FormHelper.showSimpleAlertDialog(context, Config.appName,
                      itemsResponse['message'], "ยอมรับ", () {
                    Navigator.pop(context);
                    setState(() {
                      assetIDController.clear();
                      codeController.clear();
                      nameController.clear();
                      branchController.clear();
                      dateTimeController.clear();
                    });
                  });
                }
              }
            } else {
              dynamic itemsResponse = jsonDecode(response.body);
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
            FormHelper.showSimpleAlertDialog(
                context, Config.appName, "กรุณาใส่ข้อมูล", "ยอมรับ", () {
              Navigator.pop(context);
            });
          }
        }
      }
    } on PlatformException {
      codeController.text = "Failed to get platfrom version.";
    }
  }

  Future<void> _update() async {
    SharedPreferences roundid = await SharedPreferences.getInstance();
    setState(() {
      round_id.text = roundid.getString("RoundID")!;
    });
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=utf-8',
    };
    var client = http.Client();
    var url = Uri.http(Config.apiURL, Config.updateReference);
    await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "Code": codeController.text,
        "RoundID": round_id.text,
        "Reference": referenceController.text,
        "UserID": userID,
        "BranchID": widget.branchPermission,
        "Date": now.toString(),
      }),
    );
  }
}
