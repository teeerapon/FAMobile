// ignore_for_file: unused_field, prefer_final_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fa_mobile_app/sceen/menu_reported.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import '../config.dart';

// ignore: must_be_immutable
class DetailsReported extends StatefulWidget {
  final oCcy = NumberFormat("#,##0.00", "th");
  final String titleName;
  final String codeAssets;
  final int brachID;
  final String date;
  final String? reference;
  final String round;
  final String userCode;
  final String userBranch;
  final int backBranch;
  final String? detail;
  late String imagePath;
  late String imagePath_2;
  DetailsReported({
    Key? key,
    required this.titleName,
    required this.codeAssets,
    required this.brachID,
    required this.date,
    required this.reference,
    required this.detail,
    required this.round,
    required this.userCode,
    required this.userBranch,
    required this.backBranch,
    required this.imagePath,
    required this.imagePath_2,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _DetailsReportedState createState() => _DetailsReportedState();
}

class _DetailsReportedState extends State<DetailsReported> {
  bool checkBox = false;
  bool checkBox2 = false;
  bool checkBox3 = false;
  bool checkBox4 = false;
  bool checkBox5 = false;
  bool checkBox6 = false;
  bool checkBox7 = false;
  bool checkBox8 = false;
  bool checkBox9 = false;
  var referenceController = TextEditingController();
  String referenceSetState1 = 'สภาพดี';
  String referenceSetState2 = 'ชำรุดรอซ่อม';
  String referenceSetState3 = 'รอตัดชำรุด';
  String referenceSetState4 = 'QR Code ไม่สมบูรณ์ (สภาพดี)';
  String referenceSetState5 = 'QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)';
  String referenceSetState6 = 'QR Code ไม่สมบูรณ์ (รอตัดชำรุด)';
  String referenceSetState7 = 'รอตัดขาย';
  String referenceSetState8 = 'QR Code ไม่สมบูรณ์ (รอตัดขาย)';
  String referenceSetState9 = 'อื่น ๆ';
  bool _visible = false;
  // ignore: non_constant_identifier_names
  bool _visible_comment = false;
  var titleName = TextEditingController();
  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    setState(() {
      titleName.text = widget.titleName;
    });
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
                  'สาขาที่อยู่ของทรัพย์สิน :  ${widget.brachID}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      //fontStyle: FontStyle.italic,
                      fontSize: 18,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'บันทึกโดย :  ${widget.userCode}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          //fontStyle: FontStyle.italic,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _visible = true;
                        });
                      },
                      icon: const Icon(Icons.mode_edit),
                      color: Colors.white,
                      iconSize: 18.0,
                    ),
                  ],
                ),
                Text(
                  'สาขาที่ทำการบันทึก :  ${widget.userBranch}',
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
                  'วันที่บันทึก :  ${widget.date}',
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
                        : 'สถานะล่าสุด :  ${widget.detail}',
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    'สถานะครั้งนี้ :  ${widget.reference}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        //fontStyle: FontStyle.italic,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                const Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1,
                      height: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
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
                Visibility(
                  visible: _visible,
                  child: const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                        height: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: widget.reference == ("QR Code ไม่สมบูรณ์ (สภาพดี)") ||
                      widget.reference ==
                          ("QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)") ||
                      widget.reference == ("QR Code ไม่สมบูรณ์ (รอตัดชำรุด)") ||
                      widget.reference == ("QR Code ไม่สมบูรณ์ (รอตัดขาย)") ||
                      widget.reference == ("อื่น ๆ")
                  ? Column(
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
                                      checkBox5 = false;
                                      checkBox6 = false;
                                      checkBox8 = false;
                                      checkBox9 = false;
                                      referenceController.text =
                                          referenceSetState4.toString();
                                      _update();
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
                                value: checkBox5,
                                activeColor: Colors.orangeAccent,
                                splashRadius: 30,
                                onChanged: (value) {
                                  setState(() {
                                    checkBox5 = value!;
                                    if (checkBox5 == false) {
                                      referenceController.clear();
                                      _update();
                                    } else {
                                      checkBox4 = false;
                                      checkBox6 = false;
                                      checkBox8 = false;
                                      checkBox9 = false;
                                      referenceController.text =
                                          referenceSetState5.toString();
                                      _update();
                                    }
                                  });
                                },
                              ),
                              const Text('QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)',
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
                                value: checkBox8,
                                activeColor: Colors.orangeAccent,
                                splashRadius: 30,
                                onChanged: (value) {
                                  setState(() {
                                    checkBox8 = value!;
                                    if (checkBox8 == false) {
                                      referenceController.clear();
                                      _update();
                                    } else {
                                      checkBox4 = false;
                                      checkBox5 = false;
                                      checkBox6 = false;
                                      checkBox9 = false;
                                      referenceController.text =
                                          referenceSetState8.toString();
                                      _update();
                                    }
                                  });
                                },
                              ),
                              const Text(
                                'QR Code ไม่สมบูรณ์ (รอตัดขาย)',
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
                                value: checkBox6,
                                activeColor: Colors.orangeAccent,
                                splashRadius: 30,
                                onChanged: (value) {
                                  setState(() {
                                    checkBox6 = value!;
                                    if (checkBox6 == false) {
                                      referenceController.clear();
                                      _update();
                                    } else {
                                      checkBox4 = false;
                                      checkBox5 = false;
                                      checkBox8 = false;
                                      checkBox9 = false;
                                      referenceController.text =
                                          referenceSetState6.toString();
                                      _update();
                                    }
                                  });
                                },
                              ),
                              const Text(
                                'QR Code ไม่สมบูรณ์ (รอตัดชำรุด)',
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
                        //         value: checkBox9,
                        //         activeColor: Colors.orangeAccent,
                        //         splashRadius: 30,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             checkBox9 = value!;
                        //             if (checkBox9 == false) {
                        //               referenceController.clear();
                        //               _update();
                        //             } else {
                        //               checkBox4 = false;
                        //               checkBox5 = false;
                        //               checkBox6 = false;
                        //               checkBox8 = false;
                        //               referenceController.text =
                        //                   referenceSetState9.toString();
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
                    )
                  : Column(
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
                                value: checkBox,
                                activeColor: Colors.orangeAccent,
                                splashRadius: 30,
                                onChanged: (value) {
                                  setState(() {
                                    checkBox = value!;
                                    if (checkBox == false) {
                                      referenceController.clear();
                                      _update();
                                    } else {
                                      checkBox2 = false;
                                      checkBox3 = false;
                                      checkBox7 = false;
                                      checkBox9 = false;
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
                                      checkBox = false;
                                      checkBox3 = false;
                                      checkBox7 = false;
                                      checkBox9 = false;
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
                                value: checkBox7,
                                activeColor: Colors.orangeAccent,
                                splashRadius: 30,
                                onChanged: (value) {
                                  setState(() {
                                    checkBox7 = value!;
                                    if (checkBox7 == false) {
                                      referenceController.clear();
                                      _update();
                                    } else {
                                      checkBox = false;
                                      checkBox2 = false;
                                      checkBox3 = false;
                                      checkBox9 = false;
                                      referenceController.text =
                                          referenceSetState7.toString();
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
                                      checkBox = false;
                                      checkBox2 = false;
                                      checkBox7 = false;
                                      checkBox9 = false;
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
                        //         value: checkBox9,
                        //         activeColor: Colors.orangeAccent,
                        //         splashRadius: 30,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             checkBox9 = value!;
                        //             if (checkBox9 == false) {
                        //               referenceController.clear();
                        //               _update();
                        //             } else {
                        //               checkBox = false;
                        //               checkBox2 = false;
                        //               checkBox3 = false;
                        //               checkBox7 = false;
                        //               referenceController.text =
                        //                   referenceSetState9.toString();
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
          ),
        ],
      ),
    );
  }

  Future<void> _update() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=utf-8',
    };
    var client = http.Client();
    var url = Uri.http(Config.apiURL, Config.updateReference);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "Reference": referenceController.text,
        "Code": widget.codeAssets,
        "RoundID": widget.round,
        "UserID": pref.getString("UserID")!,
        "BranchID": widget.brachID,
        "Date": now.toString(),
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
                period_round: widget.round,
                beginDate: widget.date,
                endDate: widget.date,
                branchPermission: widget.backBranch,
              ),
            ),
          );
        });
      });
    } else {
      final items = jsonDecode(response.body);
      setState(() {
        FormHelper.showSimpleAlertDialog(
            context, Config.appName, items['message'], "ยอมรับ", () {
          // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewDetails(
                period_round: widget.round,
                beginDate: widget.date,
                endDate: widget.date,
                branchPermission: widget.backBranch,
              ),
            ),
          );
        });
      });
    }
  }
}
