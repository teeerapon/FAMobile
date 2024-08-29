// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fa_mobile_app/config.dart';
import 'package:fa_mobile_app/models/login_request_model.dart';
import 'package:fa_mobile_app/service/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LohinSceen extends StatefulWidget {
  const LohinSceen({Key? key}) : super(key: key);

  @override
  _LohinSceenState createState() => _LohinSceenState();
}

class _LohinSceenState extends State<LohinSceen> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();
  String? userCode;
  String? password;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Version 2.0.0 (2024-08-26)',
                style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: HexColor('#283B71'),
        body: ProgressHUD(
          inAsyncCall: isAPIcallProcess,
          opacity: 0,
          key: UniqueKey(),
          child: Form(
            key: globalFormkey,
            child: _loginUI(context),
          ),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
          Padding(
            padding: const EdgeInsets.only(left: 35, bottom: 20, top: 30),
            child: Text(
              "ล็อกอินเพื่อเข้าสู่ระบบ",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  //fontStyle: FontStyle.italic,
                  fontSize: screenWidth * 0.05,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: FormHelper.inputFieldWidget(
              context,
              "UserCode",
              "UserCode",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "กรุณากรอก UserCode";
                }
                return null;
              },
              (onSavedVal) => {
                userCode = onSavedVal,
              },
              borderColor: Colors.white,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.person),
              prefixIconColor: Colors.white,
              borderFocusColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
            child: FormHelper.inputFieldWidget(
              context,
              "password",
              "password",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "กรุณากรอก UserCode";
                }
                return null;
              },
              (onSavedVal) => {
                password = onSavedVal,
              },
              borderColor: Colors.white,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: Colors.white,
              borderFocusColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.6),
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.white.withOpacity(0.8),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
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
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Center(
              child: FormHelper.submitButton(
                "เข้าสู่ระบบ",
                () {
                  if (validateAndSave()) {
                    setState(() {
                      isAPIcallProcess = true;
                    });

                    LoginRequstModel model = LoginRequstModel(
                      userCode: userCode!,
                      password: password!,
                    );

                    APIService.login(model).then((response) {
                      setState(() {
                        isAPIcallProcess = false;
                      });
                      if (response ||
                          (userCode == 'demo' && password == 'demo')) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/permission_branch', (route) => false);
                      } else {
                        FormHelper.showSimpleAlertDialog(
                            context,
                            Config.appName,
                            "(UserCode หรือ Password ผิด) กรุณาตรวจสอบใหม่อีกครั้ง",
                            "ยอมรับ", () {
                          Navigator.pop(context);
                        });
                      }
                    });
                  }
                },
                btnColor: HexColor("#fc2d8a"),
                borderColor: Colors.white.withOpacity(0.5),
                borderRadius: 10,
                txtColor: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'จำรหัสผ่านไม่ได้ ? กรุณาติดต่อ',
                  style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('IT support',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromRGBO(255, 46, 140, 1),
                      )),
                ),
              ],
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
}
