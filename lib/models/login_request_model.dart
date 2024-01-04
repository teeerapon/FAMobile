// ignore_for_file: non_constant_identifier_names

class LoginRequstModel {
  LoginRequstModel({
    required this.userCode,
    required this.password,
  });
  late final String userCode;
  late final String password;

  LoginRequstModel.fromJson(Map<String, dynamic> json) {
    userCode = json['UserCode'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['UserCode'] = userCode;
    _data['Password'] = password;
    return _data;
  }
}
