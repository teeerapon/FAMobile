// ignore_for_file: camel_case_types

class Config {
  static const String appName = "แจ้งเตือน";
  // static const String appAssets = "Assets";
  // static const String apiURL = "192.168.220.1:32001"; //Ipconfig 49.0.64.71:32001
  static const String apiURL = "10.20.100.29:32001";
  static const String loginAPI = "/api/login"; //logins
  static const String profileAPI = "/api/users/:body"; //profile
  static const String assetsAPI = "/api/getAsset"; //CheckCode
  static const String assetsAPIByUserID =
      "/api/getAssetbyUserBranch"; //ShowDetails True Asset Count
  static const String wrongBranch =
      "/api/wrongBranch"; //ShowDetails False Asset Count
  static const String assetsAPIget2 = "api/testGetBranch"; //Allget Assets เหลือ
  static const String addAssetsAPI = "/api/addAsset"; //AddCode After Check Code
  static const String periodLogin = "/api/period_login"; //Login
  static const String updateReference =
      "/api/updateReference"; //Update True,False Assets Count
  static const String roundPeriod = "/api/period_round"; // Munu List period
  static const String lostAsset = "/api/lostAssets"; // LostAssets
  static const String permissionBranch =
      "/api/permission_branch"; // permission_branch
  static const String checkCodeResult =
      "/api/check_code_result"; // check Code Result
}
