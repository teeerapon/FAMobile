// ignore_for_file: unused_local_variable, override_on_non_overriding_member

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'details_reported.dart';
import 'no_count_sceen.dart';
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

  @override
  Widget build(BuildContext context) {
    var count1 = assets.toList().length;
    var count2 = assets2.toList().length;
    var count3 = assets3.toList().length;
    var count4 = lostAssets.toList().length;
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size(60.0, 60.0),
              child: TabBar(
                tabs: [
                  Tab(
                    child: SizedBox(
                      height: 50,
                      child: Text('นับแล้ว \n($count1)',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      height: 50,
                      child: Text('ต่างสาขา \n($count3)',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      height: 50,
                      child: Text('คงเหลือ \n($count2)',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              'ทรัพย์สิน สาขาที่ : ' + widget.branchPermission.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
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
              Form(child: _fixassets(context)),
              Form(child: _fixassets3(context)),
              Form(child: _fixassets2(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fixassets(BuildContext context) {
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        return getCard(assets[index]);
      },
    );
  }

  Widget getCard(index) {
    var detalsStatus = index['Reference'];
    var titleName = index['Name'];
    var codeAssets = index['Code'];
    var brachID = index['BranchID'];
    var userID = index['UserID'];
    var roundID = index['RoundID'];
    var branchuserID = index['UserBranch'];
    var time = index['Date'];
    DateTime date = DateTime.parse(time);
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    final String assetDate = formatter.format(date);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        color: const Color.fromRGBO(40, 59, 113, 1),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailsReported(
                            titleName: index['Name'],
                            codeAssets: index['Code'],
                            brachID: index['BranchID'],
                            date: assetDate.toString(),
                            reference: index['Reference'],
                            round: index['RoundID'].toString(),
                            detail: index['detail'].toString(),
                            imagePath: index['imagePath'].toString(),
                            imagePath_2: index['imagePath_2'].toString(),
                            userCode: userID,
                            userBranch: branchuserID.toString(),
                            backBranch: widget.branchPermission,
                          )));
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 280,
                  child: Text('$titleName',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(13, 209, 13, 1))),
                ),
                const SizedBox(height: 8),
                Text('รหัสทรัพย์สิน : $codeAssets',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.yellow)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('สาขา : $brachID',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    const SizedBox(width: 10),
                    // Text('รอบบันทึก : รอบที่ $roundID',
                    //     style: const TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.white))
                    Text('วันที่บันทึก : $assetDate',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 280,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'สถานะครั้งนี้ :  $detalsStatus',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          //fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: detalsStatus == 'ไม่ได้ระบุสถานะ'
                              ? Colors.red
                              : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fixassets3(BuildContext context) {
    return ListView.builder(
      itemCount: assets3.length,
      itemBuilder: (context, index) {
        return getCard3(assets3[index]);
      },
    );
  }

  Widget getCard3(index) {
    var detalsStatus = index['Reference'];
    var titleName = index['Name'];
    var codeAssets = index['Code'];
    var brachID = index['BranchID'];
    var userID = index['UserID'];
    var branchuserID = index['UserBranch'];
    var time = index['Date'];
    var roundID = index['RoundID'];
    DateTime date = DateTime.parse(time);
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    final String assetDate = formatter.format(date);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        color: const Color.fromRGBO(40, 59, 113, 1),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailsReported(
                            titleName: index['Name'],
                            codeAssets: index['Code'],
                            brachID: index['BranchID'],
                            date: assetDate.toString(),
                            reference: index['Reference'],
                            detail: index['detail'],
                            round: index['RoundID'].toString(),
                            imagePath: index['imagePath'].toString(),
                            imagePath_2: index['imagePath_2'].toString(),
                            userCode: userID.toString(),
                            userBranch: branchuserID.toString(),
                            backBranch: widget.branchPermission,
                          )));
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 280,
                  child: Text('$titleName',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(13, 209, 13, 1))),
                ),
                const SizedBox(height: 8),
                Text('รหัสทรัพย์สิน : $codeAssets',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.yellow)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('สาขา : $brachID',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    const SizedBox(width: 10),
                    // Text('รอบบันทึก : รอบที่ $roundID',
                    //     style: const TextStyle(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.white))
                    Text('วันที่บันทึก : $assetDate',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 280,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      'สถานะครั้งนี้ :  $detalsStatus',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          //fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: detalsStatus == 'ไม่ได้ระบุสถานะ'
                              ? Colors.red
                              : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fixassets2(BuildContext context) {
    return ListView.builder(
      itemCount: assets2.length,
      itemBuilder: (context, index) {
        return getCard2(assets2[index]);
      },
    );
  }

  Widget getCard2(index) {
    var titleName = index['Name'];
    var codeAssets = index['Code'];
    var brachID = index['BranchID'];
    // var userID = "null";
    // var branchuserID = "null";
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        color: const Color.fromRGBO(40, 59, 113, 1),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => NoCountedSceen(
                            titleName: index['Name'],
                            codeAssets: index['Code'],
                            brachID: index['BranchID'],
                            assetID: index['AssetID'],
                            detail: index['detail'].toString(),
                            imagePath: index['imagePath'].toString(),
                            imagePath_2: index['imagePath_2'].toString(),
                            roundID: widget.period_round.toString(),
                          )));
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 280,
                  child: Text('$titleName',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(13, 209, 13, 1))),
                ),
                const SizedBox(height: 8),
                Text('รหัสทรัพย์สิน : $codeAssets',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.yellow)),
                const SizedBox(height: 8),
                Text('สาขา : $brachID',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
