// ignore_for_file: unused_import

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fa_mobile_app/service/shared_service.dart';
import 'package:fa_mobile_app/sceen/login_sceen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sceen/permission_branch.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';

// Widget _defaultHome = const LohinSceen();
Widget _defaultHome = const LohinSceen();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool? result = await SharedService.isLoggedIn();
  if (result) {
    // _defaultHome = const LohinSceen();
    _defaultHome = const PermissionBranch();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAPIcallProcess = false;
  GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unrelated_type_equality_checks
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      routes: {
        '/': (context) => _defaultHome,
        '/login': (context) => const LohinSceen(),
        '/permission_branch': (context) => const PermissionBranch(),
      },
    );
  }

  Future<void> checkForUpdate() async {
    try {
      // ตรวจสอบข้อมูลเวอร์ชันแอปจาก PackageInfo
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      // ตรวจสอบการอัปเดตแอป
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // เปรียบเทียบเวอร์ชัน
        if (currentVersion != updateInfo.availableVersionCode.toString()) {
          showUpdateDialog();
        }
      }
    } catch (e) {
      log("Failed to check for updates: $e");
    }
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: const Text(
              'A new version of the app is available. Please update to the latest version.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Later'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                redirectToPlayStore();
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  void redirectToPlayStore() async {
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.purethai.fa_mobile_app';
    if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
      await launchUrl(Uri.parse(playStoreUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $playStoreUrl';
    }
  }
}
