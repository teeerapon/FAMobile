// /AssetsAll_Control

// ignore_for_file: unused_local_variable, override_on_non_overriding_member, library_private_types_in_public_api, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:fa_mobile_app/sceen/permission_branch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/hex_color.dart';
import '../config.dart';

class ListAllAssets extends StatefulWidget {
  final int branchPermission;
  const ListAllAssets({
    Key? key,
    required this.branchPermission,
  }) : super(key: key);

  @override
  _ListAllAssetsState createState() => _ListAllAssetsState();
}

class _ListAllAssetsState extends State<ListAllAssets> {
  @override
  final oCcy = NumberFormat("#,##0.00", "th");
  int? userBranch;
  List<dynamic> assets = [];
  bool isLoading = false;
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  List<dynamic> lostAssets = [];
  GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();
  String? userCode;
  String? userID;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  final ImagePicker _picker = ImagePicker();
  List<String> listImage = ['', ''];

  @override
  void initState() {
    super.initState();
    fetchAsset();
  }

  Future<void> fetchAsset() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (userBranch.toString().isNotEmpty) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, "/api/AssetsAll_Control");
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "BranchID": pref.getInt("BranchID")!,
          "usercode": pref.getInt("BranchID")! == 901
              ? pref.getString("UserCode")!
              : null,
        }),
      );
      if (response.statusCode == 200) {
        // แปลง JSON สตริงเป็น Map ของ Dart
        var decodedResponse = jsonDecode(response.body);
        if (decodedResponse.containsKey('data')) {
          var data = decodedResponse['data'];
          // ตรวจสอบว่า data เป็น List ก่อนที่จะใช้งาน
          if (data is List) {
            setState(() {
              assets = data;
              userID = pref.getString("UserID")!;
              userCode = pref.getString("UserCode")!;
              userBranch = pref.getInt("BranchID")!;
            });
          } else {
            log('Data is not a list');
          } // พิมพ์ข้อมูลใน 'data'
        } else {
          log('Key "data" not found in the response');
        }
      } else {
        assets = [];
      }
    } else {
      assets = [];
    }
  }

  List<dynamic> _filterAssets(List<dynamic> assetsList) {
    if (searchQuery.isEmpty) {
      return assetsList;
    }
    return assetsList.where((asset) {
      return asset['Name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          asset['Code'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          asset['BranchID'].toString().contains(searchQuery) ||
          asset['BranchName'].toString().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var count1 = _filterAssets(assets).toList().length;
    int count2 = (assets).toList().length;
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ทรัพย์สินของ ${userCode ?? 'Loading...'} ($count2)',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: Row(
            children: <Widget>[
              const SizedBox(
                width: 5.0,
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/permission_branch', (route) => false);
                },
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color.fromRGBO(40, 59, 113, 1),
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(100.0), // Height of the TextField
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'ค้นหาทรัพย์สิน...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: _fixassets3(context),
        ),
      ),
    );
  }

  Widget _fixassets3(BuildContext context) {
    List<dynamic> filteredAssets = _filterAssets(assets);
    String selectedValue = '';

    if (filteredAssets.isEmpty) {
      // ขณะกำลังรอข้อมูลจะแสดง loading indicator
      return Center(
        child: CircularProgressIndicator(
          color: HexColor("#283B71"), // เปลี่ยนสีตามที่ต้องการ
        ),
      );
    } else {
      return ListView.builder(
        itemCount: filteredAssets.length,
        itemBuilder: (context, index) {
          List<dynamic> listImage = [
            filteredAssets[index]['ImagePath'],
            filteredAssets[index]['ImagePath_2']
          ];
          return Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Card(
              elevation: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              color: const Color.fromRGBO(40, 59, 113, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // เพิ่มรูปภาพใน Card
                    SizedBox(
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
                            onTap: () => _takePicture(
                                filteredAssets[index]['Code'], index),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // มุมโค้งของรูปภาพ
                              child: (listImage[index]?.isNotEmpty ?? false)
                                  ? Image.network(
                                      listImage[index],
                                      fit: BoxFit.cover,
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
                                            children: [
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
                                  : Image.asset(
                                      'assets/images/ATT_220300020.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: Text(
                        filteredAssets[index]['Code'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            //fontStyle: FontStyle.italic,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                        height: 10,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        // แสดง AlertDialog เมื่อกดที่ Card
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context)
                                          .size
                                          .height *
                                      0.5, // กำหนดความสูงสูงสุดให้ AlertDialog
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredAssets[index]['Code'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: 28,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        filteredAssets[index]['Name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'สาขาที่อยู่ของทรัพย์สิน :  ${filteredAssets[index]['BranchName']} (${filteredAssets[index]['BranchID']})',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                        height: 20,
                                      ),
                                      Text(
                                        'บันทึกโดย :  $userID',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'สาขาที่ทำการบันทึก :  ${filteredAssets[index]['UserBranch']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          'สถานะปัจจุบัน :  ${filteredAssets[index]['Details'] ?? ''}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // ปิด AlertDialog
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'ปิด',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        //fontStyle: FontStyle.italic,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 280,
                              child: Text(filteredAssets[index]['Name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(13, 209, 13, 1))),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                'รหัสทรัพย์สิน : ${filteredAssets[index]['Code']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: HexColor('#EAC435'))),
                            const SizedBox(height: 8),
                            Text(
                                'สาขา : ${filteredAssets[index]['BranchName']} (${filteredAssets[index]['BranchID']})',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 280,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  'สถานะปัจจุบัน :  ${filteredAssets[index]['Details'] ?? ''}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      //fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      color: filteredAssets[index]
                                                  ['Reference'] ==
                                              'ไม่ได้ระบุสถานะ'
                                          ? Colors.red
                                          : Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  //  _takePicture
  Future<void> _takePicture(String code, int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _uploadImage(image, code, index); // อัปโหลดรูปภาพหลังจากถ่ายเสร็จ
    }
  }

  Future<void> _uploadImage(XFile image, String code, int index) async {
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

        await client.post(
          url,
          headers: requestHeaders,
          body: jsonEncode({
            "Code": code,
            "RoundID": 0,
            "index": index,
            "url":
                "http://vpnptec.dyndns.org:33080/NEW_NAC/$attValue.$extension",
          }),
        );
      }
    } else {
      log('Failed to upload image. Status code: ${response.statusCode}');
    }
  }
}
