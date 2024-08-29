// ignore_for_file: deprecated_member_use, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:fa_mobile_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

import 'menu.dart';

class TestAsset extends StatefulWidget {
  final int branchPermission;
  final String dateTimeNow;
  const TestAsset({
    super.key,
    required this.branchPermission,
    required this.dateTimeNow,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TestAssetState createState() => _TestAssetState();
}

class _TestAssetState extends State<TestAsset> {
  GlobalKey<FormState> codeFormkey = GlobalKey<FormState>();
  bool isAPIcallProcessAssets = false;
  int statusController = 1;
  String? codeController;
  String? nameController;
  String? branchController;
  DateTime? dateTimeController = DateTime.now();
  String? assetIDController;
  String? referenceController;
  String? moneyController;
  String? imagePath;
  String? imagePath_2;
  String? userID;
  int? userBranch;
  String? userCode;
  String? round_id;
  int userBranchID = 0;
  bool _visible = false;
  dynamic itemOfName = [];
  String selectedValue = 'ไม่ได้ระบุสถานะ';
  var now = DateTime.now();

  final ImagePicker _picker = ImagePicker();
  List<XFile?> _imageFiles = []; // List to store images
  List<String> listImage = ['', ''];

  @override
  dynamic initState() {
    super.initState();
    getUser();
    // Initialize the list with null values
    _imageFiles = List<XFile?>.filled(listImage.length, null);
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
          inAsyncCall: isAPIcallProcessAssets,
          opacity: 0,
          key: UniqueKey(),
          child: Form(
            key: codeFormkey,
            child: _scanner(context),
          ),
        ),
      ),
    );
  }

  Widget _scanner(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> listImage = [imagePath, imagePath_2];
    List<dynamic> radioListOptions = [
      'ไม่ได้ระบุสถานะ',
      'สภาพดี',
      'ชำรุดรอซ่อม',
      'รอตัดขาย',
      'รอตัดชำรุด',
      'อื่น ๆ'
    ];

    String assetDate = '';

    if (dateTimeController is DateTime) {
      // If dateTimeController is already a DateTime object
      final DateFormat formatter = DateFormat('yyyy/MM/dd');
      assetDate = formatter.format(dateTimeController!);
    } else if (dateTimeController is String) {
      // If dateTimeController is a String, parse it to a DateTime first
      try {
        DateTime date = DateTime.parse(dateTimeController as String);
        final DateFormat formatter = DateFormat('yyyy/MM/dd');
        assetDate = formatter.format(date);
      } catch (e) {
        // Handle the parsing error
        log('Error parsing date: $e');
      }
    }

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
              children: <Widget>[
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 16),
                child: Text(
                  'กดที่ สแกน QR CODE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 16),
                child: Text(
                  'เพื่อทำการเปิดกล้อง',
                  style: TextStyle(
                      color: const Color(0xffa29aac),
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // ScanCarema
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
                    setState(() {
                      listImage = ['', ''];
                    });
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
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'สแกนนับทรัพย์สินและการทำบันทึก',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "สแกน QR CODE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.06,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
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
          ),
          Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // จำนวนคอลัมน์ในแต่ละแถว
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio:
                              1.0, // อัตราส่วนระหว่างความกว้างกับความสูงของแต่ละรูปภาพ
                        ),
                        itemCount: listImage.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () => _takePicture(index), // pass the index
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // มุมโค้งของรูปภาพ
                              child: _imageFiles[index] == null
                                  ? Image.network(
                                      (listImage[index]?.isNotEmpty ?? false)
                                          ? listImage[index]
                                          : 'assets/images/ATT_220300020.png',
                                      fit: BoxFit.cover,
                                      // ปรับขนาดรูปภาพให้เต็มพื้นที่ที่กำหนด
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[
                                              200], // แสดงพื้นหลังสีเทาในกรณีที่โหลดรูปภาพไม่สำเร็จ
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.broken_image,
                                                color: Colors.grey[400],
                                              ),
                                              Text(
                                                'No Image',
                                                style: TextStyle(
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Image.file(
                                      File(_imageFiles[index]!.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              nameController ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                  fontSize: screenWidth * 0.043,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "รหัสทรัพย์สิน: ${codeController ?? ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                  fontSize: screenWidth * 0.043,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "สาขา: ${branchController ?? ''}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                  fontSize: screenWidth * 0.043,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "วันที่บันทึก: $assetDate",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                  fontSize: screenWidth * 0.043,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'สถานะครั้งนี้ :  $selectedValue',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                  fontSize: screenWidth * 0.043,
                                  color: Colors.black),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _visible,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: radioListOptions.map((option) {
                            return RadioListTile<String>(
                              title: Text(
                                option,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    //fontStyle: FontStyle.italic,
                                    fontSize: screenWidth * 0.043,
                                    color: Colors.black),
                              ),
                              value: option,
                              groupValue: selectedValue,
                              onChanged: editDetail,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  _takePicture
  Future<void> _takePicture(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFiles[index] = image; // Update specific index
      });
      await _uploadImage(image, index); // อัปโหลดรูปภาพหลังจากถ่ายเสร็จ
    }
  }

  Future<void> _uploadImage(XFile image, index) async {
    // check_files_NewNAC
    // สร้าง MultipartRequest
    var uri = Uri.http(Config.apiURL,
        '/api/check_files_NewNAC'); // แทนที่ด้วย API endpoint ที่ถูกต้องของคุณ
    var request = http.MultipartRequest('POST', uri);

    // เพิ่มไฟล์รูปภาพใน request
    var file = await http.MultipartFile.fromPath('file', image.path);
    request.files.add(file);

    // ส่งคำขอไปยัง API
    var response = await request.send();

    // ตรวจสอบผลลัพธ์
    if (response.statusCode == 200) {
      log('Image uploaded successfully!');
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      log('Response data: $jsonData');

      // ดึงค่าของ ATT
      if (jsonData['attach'] != null && jsonData['attach'].isNotEmpty) {
        String attValue = jsonData['attach'][0]['ATT'];
        String extension = jsonData['extension'];
        SharedPreferences roundid = await SharedPreferences.getInstance();
        var client = http.Client();
        var url = Uri.http(Config.apiURL, '/api/FA_Mobile_UploadImage');
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json; charset=utf-8',
        };
        var responseImg = await client.post(
          url,
          headers: requestHeaders,
          body: jsonEncode({
            "Code": codeController,
            "RoundID": roundid.getString("RoundID")!,
            "index": index,
            "url":
                "http://vpnptec.dyndns.org:33080/NEW_NAC/$attValue.$extension",
          }),
        );
        if (responseImg.statusCode == 200) {
          FormHelper.showSimpleAlertDialog(
              context, Config.appName, 'บันทึกรูปภาพสำเร็จ', "ยอมรับ", () {
            Navigator.pop(context);
          });
        }
      }
    } else {
      log('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  // editDetail
  Future<void> editDetail(String? value) async {
    if (value == null) return;
    SharedPreferences roundid = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json;charset=utf-8',
    };
    var client = http.Client();
    var url = Uri.http(Config.apiURL, Config.updateReference);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "Code": codeController,
        "RoundID": roundid.getString("RoundID")!,
        "Reference": value,
        "UserID": userID,
        "BranchID": widget.branchPermission,
        "Date": now.toString(),
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        selectedValue = value;
      });
    }
  }

  //Scan
  Future<void> startScan() async {
    setState(() {
      _visible = false;
      selectedValue = 'ไม่ได้ระบุสถานะ';
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences roundid = await SharedPreferences.getInstance();
    try {
      var openCamera = await Permission.camera.status;
      if (openCamera.isGranted) {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          codeController = cameraScanResult!;
        });

        if (codeController!.isNotEmpty) {
          Map<String, String> requestHeaders = {
            'Content-Type': 'application/json; charset=utf-8',
          };
          var client = http.Client();
          var url = Uri.http(Config.apiURL, Config.assetsAPI);
          var response = await client.post(
            url,
            headers: requestHeaders,
            body: jsonEncode({
              "Code": codeController,
              "UserBranch": widget.branchPermission,
              "RoundID": roundid.getString("RoundID")!,
            }),
          );
          dynamic itemsResponse = jsonDecode(response.body);
          if (response.statusCode != 200) {
            FormHelper.showSimpleAlertDialog(
                context, Config.appName, itemsResponse, "ยอมรับ", () {
              Navigator.pop(context);
              setState(() {
                assetIDController = null;
                codeController = null;
                nameController = null;
                branchController = null;
                dateTimeController = null;
                imagePath = null;
                imagePath_2 = null;
              });
            });
          } else if (response.statusCode == 200) {
            setState(() {
              listImage = [
                itemsResponse['data'][0]['ImagePath'].toString(),
                itemsResponse['data'][0]['ImagePath_2'].toString()
              ];
              imagePath = itemsResponse['data'][0]['ImagePath'].toString();
              imagePath_2 = itemsResponse['data'][0]['ImagePath_2'].toString();
              nameController = itemsResponse['data'][0]['Name'];
              dateTimeController = DateTime.now();
              branchController =
                  itemsResponse['data'][0]['BranchID'].toString();
              assetIDController =
                  itemsResponse['data'][0]['AssetID'].toString();
              userID = pref.getString("UserID")!;
              userBranchID = pref.getInt("BranchID")!;
              round_id = roundid.getString("RoundID")!;
              referenceController = "ไม่ได้ระบุสถานะ";
            });
            if (codeController!.isNotEmpty &&
                nameController!.isNotEmpty &&
                assetIDController!.isNotEmpty &&
                userID.toString().isNotEmpty) {
              var client = http.Client();
              var url = Uri.http(Config.apiURL, Config.addAssetsAPI);
              var response = await client.post(
                url,
                headers: requestHeaders,
                body: jsonEncode({
                  "Name": nameController,
                  "Code": codeController,
                  "BranchID": branchController,
                  "Date": dateTimeController.toString(),
                  "Status": statusController,
                  "UserID": userID,
                  "UserBranch": widget.branchPermission,
                  "RoundID": round_id,
                  "Reference": referenceController,
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
                    assetIDController = null;
                    codeController = null;
                    nameController = null;
                    branchController = null;
                    dateTimeController = null;
                    imagePath = null;
                    imagePath_2 = null;
                  });
                });
              }
            }
          }
        } else {
          FormHelper.showSimpleAlertDialog(
              context, Config.appName, "กรุณาใส่ข้อมูล", "ยอมรับ", () {
            Navigator.pop(context);
          });
        }
      } else if (openCamera.isDenied) {
        if (await Permission.camera.request().isGranted) {
          String? cameraScanResult = await scanner.scan();
          setState(() {
            codeController = cameraScanResult!;
          });

          if (codeController!.isNotEmpty) {
            Map<String, String> requestHeaders = {
              'Content-Type': 'application/json; charset=utf-8',
            };
            var client = http.Client();
            var url = Uri.http(Config.apiURL, Config.assetsAPI);

            var response = await client.post(
              url,
              headers: requestHeaders,
              body: jsonEncode({
                "Code": codeController,
                "UserBranch": widget.branchPermission,
                "RoundID": roundid.getString("RoundID")!,
              }),
            );
            if (response.statusCode == 200) {
              dynamic itemsResponse = jsonDecode(response.body);
              setState(() {
                nameController = itemsResponse['data'][0]['Name'];
                dateTimeController = DateTime.now();
                branchController =
                    itemsResponse['data'][0]['BranchID'].toString();
                assetIDController =
                    itemsResponse['data'][0]['AssetID'].toString();
                userID = pref.getString("UserID")!;
                userBranchID = pref.getInt("BranchID")!;
                round_id = roundid.getString("RoundID")!;
                referenceController = "ไม่ได้ระบุสถานะ";
              });
              if (codeController!.isNotEmpty &&
                  nameController!.isNotEmpty &&
                  assetIDController!.isNotEmpty &&
                  userID.toString().isNotEmpty) {
                var client = http.Client();
                var url = Uri.http(Config.apiURL, Config.addAssetsAPI);
                var response = await client.post(
                  url,
                  headers: requestHeaders,
                  body: jsonEncode({
                    "Name": nameController,
                    "Code": codeController,
                    "BranchID": branchController,
                    "Date": dateTimeController.toString(),
                    "Status": statusController,
                    "UserID": userID,
                    "UserBranch": widget.branchPermission,
                    "RoundID": round_id,
                    "Reference": referenceController,
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
                      assetIDController = null;
                      codeController = null;
                      nameController = null;
                      branchController = null;
                      dateTimeController = null;
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
      codeController = "Failed to get platfrom version.";
    }
  }
}
