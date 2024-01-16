// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:flutter/material.dart';
import 'package:fa_mobile_app/service/shared_service.dart';
import 'package:fa_mobile_app/sceen/login_sceen.dart';
import 'sceen/permission_branch.dart';
import 'sceen/false_update.dart';
import 'package:new_version/new_version.dart';
import 'package:fa_mobile_app/updatedialog.dart';

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

    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersion(
      androidId: 'com.purethai.fa_mobile_app',
    );

    Timer(const Duration(milliseconds: 800), () {
      checkNewVersion(newVersion);
    });

    super.initState();
  }

void checkNewVersion(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if(status != null) {
      if(status.canUpdate) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UpdateDialog(
              allowDismissal: true,
              description: status.releaseNotes!,
              version: status.storeVersion,
              appLink: status.appStoreLink,
            );
          },
        );
        // newVersion.showUpdateDialog(
        //   context: context,
        //   versionStatus: status,
        //   dialogText: 'New Version is available in the store (${status.storeVersion}), update now!',
        //   dialogTitle: 'Update is Available!',
        // );
      }
    }
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
}
