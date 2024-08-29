// ignore_for_file: unused_local_variable, override_on_non_overriding_member, library_private_types_in_public_api, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/hex_color.dart';
import '../config.dart';
import 'period_round.dart';

class ViewDetails extends StatefulWidget {
  final String period_round;
  final String beginDate;
  final String endDate;
  final int branchPermission;
  const ViewDetails({
    Key? key,
    required this.period_round,
    required this.beginDate,
    required this.endDate,
    required this.branchPermission,
  }) : super(key: key);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  final oCcy = NumberFormat("#,##0.00", "th");
  int? userBranch;
  List<dynamic> assets = [];
  List<dynamic> assets2 = [];
  List<dynamic> assets3 = [];
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
    fetchAsset2();
    fetchAsset3();
  }

  Future<void> fetchAsset() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    userID = pref.getString("UserID")!;
    userCode = pref.getString("UserCode")!;
    userBranch = pref.getInt("BranchID")!;
    if (userBranch.toString().isNotEmpty) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.assetsAPIByUserID);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "UserBranch": widget.branchPermission,
          "BranchID": widget.branchPermission,
          "RoundID": widget.period_round,
        }),
      );
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          assets = items as List;
        });
      } else {
        assets = [];
      }
    } else {
      assets = [];
    }
  }

  Future<void> fetchAsset2() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    userID = pref.getString("UserID")!;
    userCode = pref.getString("UserCode")!;
    userBranch = pref.getInt("BranchID")!;
    if (userBranch.toString().isNotEmpty) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.assetsAPIget2);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "BranchID": widget.branchPermission,
          "RoundID": widget.period_round,
        }),
      );
      if (response.statusCode == 200) {
        var items2 = jsonDecode(response.body)['data'];
        setState(() {
          assets2 = items2 as List;
        });
      } else {
        assets2 = [];
      }
    } else {
      assets = [];
    }
  }

  Future<void> fetchAsset3() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    SharedPreferences pref = await SharedPreferences.getInstance();
    userID = pref.getString("UserID")!;
    userCode = pref.getString("UserCode")!;
    userBranch = pref.getInt("BranchID")!;
    if (userBranch.toString().isNotEmpty) {
      var client = http.Client();
      var url = Uri.http(Config.apiURL, Config.wrongBranch);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "UserBranch": widget.branchPermission,
          "BranchID": widget.branchPermission,
          "RoundID": widget.period_round,
        }),
      );
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body);
        setState(() {
          assets3 = items as List;
        });
      } else {
        assets3 = [];
      }
    } else {
      assets3 = [];
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

  Widget _fixassets(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> filteredAssets = _filterAssets(assets);
    List<dynamic> radioListOptions = [
      'สภาพดี',
      'ชำรุดรอซ่อม',
      'รอตัดขาย',
      'รอตัดชำรุด',
      'อื่น ๆ'
    ];
    List<dynamic> radioListOptionsII = [
      'QR Code ไม่สมบูรณ์ (สภาพดี)',
      'QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)',
      'QR Code ไม่สมบูรณ์ (รอตัดขาย)',
      'QR Code ไม่สมบูรณ์ (รอตัดชำรุด)',
    ];
    String selectedValue = '';

    return ListView.builder(
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        List<dynamic> listImage = [
          filteredAssets[index]['ImagePath'],
          filteredAssets[index]['ImagePath_2']
        ];

        DateTime date = DateTime.parse(filteredAssets[index]['Date']);
        final DateFormat formatter = DateFormat('yyyy/MM/dd');
        final String assetDate = formatter.format(date);

        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            color: const Color.fromRGBO(40, 59, 113, 1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                            borderRadius:
                                BorderRadius.circular(10.0), // มุมโค้งของรูปภาพ
                            child: (listImage[index]?.isNotEmpty ?? false)
                                ? Image.network(
                                    listImage[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        // Widget ที่ชิดซ้าย
                        Text(
                          filteredAssets[index]['Code'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              //fontStyle: FontStyle.italic,
                              fontSize: screenWidth * 0.05,
                              color: Colors.white),
                        ),
                        // Spacer เพื่อเพิ่มช่องว่าง
                        const Spacer(),
                        // Widget ที่ชิดขวา
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String selectedOption = filteredAssets[index]
                                    ['Reference']; // ตัวเลือกที่เลือกไว้
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            radioListOptions.map((option) {
                                          return RadioListTile<String>(
                                            title: Text(option),
                                            value: option,
                                            groupValue: selectedOption,
                                            onChanged: (value) async {
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              Map<String, String>
                                                  requestHeaders = {
                                                'Content-Type':
                                                    'application/json;charset=utf-8',
                                              };

                                              var client = http.Client();
                                              var url = Uri.http(Config.apiURL,
                                                  Config.updateReference);
                                              var response = await client.put(
                                                url,
                                                headers: requestHeaders,
                                                body: jsonEncode({
                                                  "Reference": value,
                                                  "Code": filteredAssets[index]
                                                      ['Code'],
                                                  "RoundID":
                                                      filteredAssets[index]
                                                          ['RoundID'],
                                                  "UserID":
                                                      pref.getString("UserID")!,
                                                  "BranchID":
                                                      filteredAssets[index]
                                                          ['BranchID'],
                                                  "Date":
                                                      DateTime.now().toString(),
                                                }),
                                              );
                                              if (response.statusCode == 200) {
                                                setState(() {
                                                  fetchAsset();
                                                  fetchAsset2();
                                                  fetchAsset3();
                                                  selectedOption = value!;
                                                });
                                              }
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              filteredAssets[index]
                                                      ['Reference'] =
                                                  selectedOption; // เปลี่ยนข้อความการ์ดตามที่เลือก
                                            });
                                            Navigator.of(context)
                                                .pop(); // ปิด Dialog
                                          },
                                          child: const Text('บันทึก'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // ปิด Dialog โดยไม่เปลี่ยนแปลง
                                          },
                                          child: const Text('ยกเลิก'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
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
                                maxHeight: MediaQuery.of(context).size.height *
                                    0.5, // กำหนดความสูงสูงสุดให้ AlertDialog
                              ),
                              child: SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredAssets[index]['Code'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.05,
                                            color: Colors.black),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'สาขาที่อยู่ของทรัพย์สิน :  ${filteredAssets[index]['BranchName']} (${filteredAssets[index]['BranchID']})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'ผู้ถือครองทรัพย์สิน :  ${filteredAssets[index]['OwnerID']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
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
                                        'ผู้บันทึก :  ${filteredAssets[index]['UserID']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'สาขาที่ทำการบันทึก :  ${filteredAssets[index]['UserBranch']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'วันที่บันทึก :  ${assetDate.toString()}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
                                            color: Colors.black),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          'สถานะล่าสุด :  ${filteredAssets[index]['detail'] ?? ''}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                              fontSize: screenWidth * 0.043,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          'สถานะครั้งนี้ :  ${filteredAssets[index]['Reference']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              //fontStyle: FontStyle.italic,
                                              fontSize: screenWidth * 0.043,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
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
                          Text(filteredAssets[index]['Name'],
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(13, 209, 13, 1))),
                          const SizedBox(height: 8),
                          Text(
                              'รหัสทรัพย์สิน : ${filteredAssets[index]['Code']}',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor('#EAC435'))),
                          const SizedBox(height: 8),
                          Text(
                            'ผู้บันทึก :  ${filteredAssets[index]['UserID']} [${filteredAssets[index]['BranchName']} (${filteredAssets[index]['BranchID']})]',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                //fontStyle: FontStyle.italic,
                                fontSize: screenWidth * 0.043,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text('วันที่บันทึก : $assetDate',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 280,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'สถานะครั้งนี้ :  ${filteredAssets[index]['Reference']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    //fontStyle: FontStyle.italic,
                                    fontSize: screenWidth * 0.043,
                                    color: filteredAssets[index]['Reference'] ==
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

  @override
  Widget build(BuildContext context) {
    var count1 = _filterAssets(assets).toList().length;
    var count2 = _filterAssets(assets2).toList().length;
    var count3 = _filterAssets(assets3).toList().length;
    var count4 = _filterAssets(lostAssets).toList().length;
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(150.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
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
                  const SizedBox(
                    height: 16,
                  ),
                  TabBar(
                    indicatorColor:
                        HexColor('#EAC435'), // สีของ Indicator เมื่อ Active
                    labelColor: HexColor('#EAC435'), // สีของ Text เมื่อ Active
                    unselectedLabelColor:
                        Colors.white, // สีของ Text เมื่อไม่ได้ Active
                    tabs: [
                      Tab(text: 'นับแล้ว ($count1)'),
                      Tab(text: 'ต่างสาขา ($count3)'),
                      Tab(text: 'คงเหลือ ($count2)'),
                    ],
                  ),
                ],
              ),
            ),
            title: Text(
              'ทรัพย์สิน สาขาที่ : ${widget.branchPermission == 901 ? 'HO' : widget.branchPermission}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: Row(children: <Widget>[
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PeriodRound(
                          branchPermission: widget.branchPermission,
                        ),
                      ),
                    );
                  }),
            ]),
            centerTitle: true,
            elevation: 0,
            backgroundColor: const Color.fromRGBO(40, 59, 113, 1),
          ),
          body: TabBarView(
            children: [
              Center(child: _fixassets(context)),
              Center(child: _fixassets3(context)),
              Center(child: _fixassets2(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fixassets3(BuildContext context) {
    // asset3
    double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> filteredAssets = _filterAssets(assets3);
    List<dynamic> radioListOptions = [
      'สภาพดี',
      'ชำรุดรอซ่อม',
      'รอตัดขาย',
      'รอตัดชำรุด',
      'อื่น ๆ'
    ];
    List<dynamic> radioListOptionsII = [
      'QR Code ไม่สมบูรณ์ (สภาพดี)',
      'QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)',
      'QR Code ไม่สมบูรณ์ (รอตัดขาย)',
      'QR Code ไม่สมบูรณ์ (รอตัดชำรุด)',
    ];
    String selectedValue = '';

    return ListView.builder(
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        List<dynamic> listImage = [
          filteredAssets[index]['ImagePath'],
          filteredAssets[index]['ImagePath_2']
        ];

        DateTime date = DateTime.parse(filteredAssets[index]['Date']);
        final DateFormat formatter = DateFormat('yyyy/MM/dd');
        final String assetDate = formatter.format(date);

        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            color: const Color.fromRGBO(40, 59, 113, 1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                            borderRadius:
                                BorderRadius.circular(10.0), // มุมโค้งของรูปภาพ
                            child: (listImage[index]?.isNotEmpty ?? false)
                                ? Image.network(
                                    listImage[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        // Widget ที่ชิดซ้าย
                        Text(
                          filteredAssets[index]['Code'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              //fontStyle: FontStyle.italic,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        // Spacer เพื่อเพิ่มช่องว่าง
                        const Spacer(),
                        // Widget ที่ชิดขวา
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String selectedOption = filteredAssets[index]
                                    ['Reference']; // ตัวเลือกที่เลือกไว้
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            radioListOptions.map((option) {
                                          return RadioListTile<String>(
                                            title: Text(option),
                                            value: option,
                                            groupValue: selectedOption,
                                            onChanged: (value) async {
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              Map<String, String>
                                                  requestHeaders = {
                                                'Content-Type':
                                                    'application/json;charset=utf-8',
                                              };

                                              var client = http.Client();
                                              var url = Uri.http(Config.apiURL,
                                                  Config.updateReference);
                                              var response = await client.put(
                                                url,
                                                headers: requestHeaders,
                                                body: jsonEncode({
                                                  "Reference": value,
                                                  "Code": filteredAssets[index]
                                                      ['Code'],
                                                  "RoundID":
                                                      filteredAssets[index]
                                                          ['RoundID'],
                                                  "UserID":
                                                      pref.getString("UserID")!,
                                                  "BranchID":
                                                      filteredAssets[index]
                                                          ['BranchID'],
                                                  "Date":
                                                      DateTime.now().toString(),
                                                }),
                                              );
                                              if (response.statusCode == 200) {
                                                setState(() {
                                                  fetchAsset();
                                                  fetchAsset2();
                                                  fetchAsset3();
                                                  selectedOption = value!;
                                                });
                                              }
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              filteredAssets[index]
                                                      ['Reference'] =
                                                  selectedOption; // เปลี่ยนข้อความการ์ดตามที่เลือก
                                            });
                                            Navigator.of(context)
                                                .pop(); // ปิด Dialog
                                          },
                                          child: const Text('บันทึก'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // ปิด Dialog โดยไม่เปลี่ยนแปลง
                                          },
                                          child: const Text('ยกเลิก'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
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
                                maxHeight: MediaQuery.of(context).size.height *
                                    0.5, // กำหนดความสูงสูงสุดให้ AlertDialog
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredAssets[index]['Code'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.05,
                                          color: Colors.black),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.043,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'สาขาที่อยู่ของทรัพย์สิน :  ${filteredAssets[index]['BranchName']} (${filteredAssets[index]['BranchID']})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.043,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'ผู้ถือครองทรัพย์สิน :  ${filteredAssets[index]['OwnerID']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.043,
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
                                      'ผู้บันทึก :  ${filteredAssets[index]['UserID']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.043,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'สาขาที่ทำการบันทึก :  ${filteredAssets[index]['UserBranch']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.043,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'วันที่บันทึก :  ${assetDate.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.043,
                                          color: Colors.black),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        'สถานะล่าสุด :  ${filteredAssets[index]['detail'] ?? ''}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
                                            color: Colors.black),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        'สถานะครั้งนี้ :  ${filteredAssets[index]['Reference']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
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
                          Text(filteredAssets[index]['Name'],
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(13, 209, 13, 1))),
                          const SizedBox(height: 8),
                          Text(
                              'รหัสทรัพย์สิน : ${filteredAssets[index]['Code']}',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor('#EAC435'))),
                          const SizedBox(height: 8),
                          Text(
                            'ผู้บันทึก :  ${filteredAssets[index]['UserID']} [${filteredAssets[index]['BranchName']} (${filteredAssets[index]['BranchID']})]',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                //fontStyle: FontStyle.italic,
                                fontSize: screenWidth * 0.043,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text('วันที่บันทึก : $assetDate',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 280,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'สถานะครั้งนี้ :  ${filteredAssets[index]['Reference']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    //fontStyle: FontStyle.italic,
                                    fontSize: screenWidth * 0.043,
                                    color: filteredAssets[index]['Reference'] ==
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

  Widget _fixassets2(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> filteredAssets = _filterAssets(assets2);
    List<dynamic> radioListOptions = [
      'สภาพดี',
      'ชำรุดรอซ่อม',
      'รอตัดขาย',
      'รอตัดชำรุด',
      'อื่น ๆ'
    ];
    List<dynamic> radioListOptionsII = [
      'QR Code ไม่สมบูรณ์ (สภาพดี)',
      'QR Code ไม่สมบูรณ์ (ชำรุดรอซ่อม)',
      'QR Code ไม่สมบูรณ์ (รอตัดขาย)',
      'QR Code ไม่สมบูรณ์ (รอตัดชำรุด)',
    ];
    String selectedValue = '';

    return ListView.builder(
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        List<dynamic> listImage = [
          filteredAssets[index]['ImagePath'],
          filteredAssets[index]['ImagePath_2']
        ];

        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            color: const Color.fromRGBO(40, 59, 113, 1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                            borderRadius:
                                BorderRadius.circular(10.0), // มุมโค้งของรูปภาพ
                            child: (listImage[index]?.isNotEmpty ?? false)
                                ? Image.network(
                                    listImage[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        // Widget ที่ชิดซ้าย
                        Text(
                          filteredAssets[index]['Code'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              //fontStyle: FontStyle.italic,
                              fontSize: screenWidth * 0.05,
                              color: Colors.white),
                        ),
                        // Spacer เพื่อเพิ่มช่องว่าง
                        const Spacer(),
                        // Widget ที่ชิดขวา
                        IconButton(
                          icon: const Icon(Icons.add_outlined,
                              color: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String selectedOption =
                                    ""; // ตัวเลือกที่เลือกไว้
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            radioListOptionsII.map((option) {
                                          return RadioListTile<String>(
                                            title: Text(option),
                                            value: option,
                                            groupValue: selectedOption,
                                            onChanged: (value) async {
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              SharedPreferences roundid =
                                                  await SharedPreferences
                                                      .getInstance();
                                              Map<String, String>
                                                  requestHeaders = {
                                                'Content-Type':
                                                    'application/json; charset=utf-8',
                                              };

                                              var client = http.Client();
                                              var url = Uri.http(Config.apiURL,
                                                  Config.periodLogin);
                                              var response = await client.post(
                                                url,
                                                headers: requestHeaders,
                                                body: jsonEncode({
                                                  "BeginDate":
                                                      DateTime.now().toString(),
                                                  "EndDate":
                                                      DateTime.now().toString(),
                                                  "BranchID":
                                                      filteredAssets[index]
                                                          ['BranchID'],
                                                }),
                                              );
                                              if (response.statusCode == 200) {
                                                var items =
                                                    jsonDecode(response.body)[
                                                        'PeriodRound'];
                                                if (items !=
                                                    filteredAssets[index]
                                                        ['RoundID']) {
                                                  setState(() {
                                                    Navigator.of(context)
                                                        .pop(); // ปิด Dialog หลัก

                                                    // แสดง Dialog ยืนยันการเปลี่ยนแปลงข้อมูล
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: const Text(
                                                              'ไม่สามารถบันทึกได้เนื่องจากเวลาไม่อยู่ในรอบการตรวจนับ'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // ปิด Dialog รอง
                                                              },
                                                              child: const Text(
                                                                  'รับทราบ'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  });
                                                } else {
                                                  var client = http.Client();
                                                  var url = Uri.http(
                                                      Config.apiURL,
                                                      Config.addAssetsAPI);
                                                  var responseAddAsset =
                                                      await client.post(
                                                    url,
                                                    headers: requestHeaders,
                                                    body: jsonEncode({
                                                      "Name":
                                                          filteredAssets[index]
                                                              ['Name'],
                                                      "Code":
                                                          filteredAssets[index]
                                                              ['Code'],
                                                      "BranchID":
                                                          filteredAssets[index]
                                                              ['BranchID'],
                                                      "Date": DateTime.now()
                                                          .toString(),
                                                      "Status": 1,
                                                      "UserID": pref
                                                          .getString("UserID")!,
                                                      "UserBranch":
                                                          pref.getString(
                                                              "BranchID"),
                                                      "RoundID":
                                                          roundid.getString(
                                                              "RoundID")!,
                                                      "Reference": value,
                                                    }),
                                                  );
                                                  if (responseAddAsset
                                                          .statusCode ==
                                                      200) {
                                                    setState(() {
                                                      fetchAsset();
                                                      fetchAsset2();
                                                      fetchAsset3();
                                                      selectedOption = value!;
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              filteredAssets[index]
                                                      ['Reference'] =
                                                  selectedOption; // เปลี่ยนข้อความการ์ดตามที่เลือก
                                            });
                                            Navigator.of(context)
                                                .pop(); // ปิด Dialog
                                          },
                                          child: const Text('บันทึก'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // ปิด Dialog โดยไม่เปลี่ยนแปลง
                                          },
                                          child: const Text('ยกเลิก'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
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
                                maxHeight: MediaQuery.of(context).size.height *
                                    0.5, // กำหนดความสูงสูงสุดให้ AlertDialog
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Text(
                                      'สาขาที่อยู่ของทรัพย์สิน :  ${filteredAssets[index]['BranchName']} (${filteredAssets[index]['BranchID']})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.05,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'ผู้ถือครองทรัพย์สิน :  ${filteredAssets[index]['OwnerID']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontStyle: FontStyle.italic,
                                          fontSize: screenWidth * 0.043,
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        'สถานะล่าสุด :  ${filteredAssets[index]['detail'] ?? 'ยังไม่ได้ระบุ'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.043,
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
                          Text(filteredAssets[index]['Name'],
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(13, 209, 13, 1))),
                          const SizedBox(height: 8),
                          Text(
                              'รหัสทรัพย์สิน : ${filteredAssets[index]['Code']}',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor('#EAC435'))),
                          const SizedBox(height: 8),
                          Text(
                            'ผู้บันทึก :  ยังไม่ได้บันทึก',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                //fontStyle: FontStyle.italic,
                                fontSize: screenWidth * 0.043,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 280,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'สถานะครั้งนี้ :  ${filteredAssets[index]['Reference'] ?? 'ยังไม่ได้ระบุ'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    //fontStyle: FontStyle.italic,
                                    fontSize: screenWidth * 0.043,
                                    color: filteredAssets[index]['Reference'] ==
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
            "RoundID": roundid.getString("RoundID")!,
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
