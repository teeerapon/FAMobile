// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:url_launcher/url_launcher.dart';

class FalseUpdate extends StatefulWidget {
  const FalseUpdate({Key? key}) : super(key: key);

  @override
  _FalseUpdateState createState() => _FalseUpdateState();
}

class _FalseUpdateState extends State<FalseUpdate> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();
  String? userCode;
  String? password;

  final _faChecker = AppVersionChecker(
    appId: "com.purethai.fa_mobile_app",
    androidStore: AndroidStore.googlePlayStore,
  );
  String? appURL;

  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  void checkVersion() async {
    await Future.wait([
      _faChecker
          .checkUpdate()
          .then((value) => appURL = value.appURL.toString()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          child: Form(
            key: globalFormkey,
            child: page_404(context),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget page_404(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 25, top: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.withOpacity(0.6),
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: const <Widget>[
              Center(
                child: Text(
                  "แจ้งเตือน !!",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 26,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  "FA Mobile มีการเปลี่ยนแปลง",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "กรุณาอัปเดทเป็นเวอร์ชั่นล่าสุด",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: _launchUrl,
              child: const Text('กดที่นี่เพื่อ อัปเดท',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(255, 46, 140, 1),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse(appURL!);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
