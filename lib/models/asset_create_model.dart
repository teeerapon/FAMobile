// ignore_for_file: non_constant_identifier_names

class AssetCreateModel {
  AssetCreateModel({
    required this.AssetID,
    required this.Code,
    required this.Name,
    required this.BranchID,
    required this.Date,
    required this.Status,
    required this.UserID,
    required this.UserBranch,
  });
  late final String AssetID;
  late final String Code;
  late final String Name;
  late final int BranchID;
  late final String Date;
  late final int Status;
  late final int UserID;
  late final int UserBranch;

  AssetCreateModel.fromJson(Map<String, dynamic> json) {
    AssetID = json['AssetID'];
    Code = json['Code'];
    Name = json['Name'];
    BranchID = json['BranchID'];
    Date = json['Date'];
    Status = json['Status'];
    UserID = json['UserID'];
    UserBranch = json['UserBranch'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['AssetID'] = AssetID;
    _data['Code'] = Code;
    _data['Name'] = Name;
    _data['BranchID'] = BranchID;
    _data['Date'] = Date;
    _data['Status'] = Status;
    _data['UserID'] = UserID;
    _data['UserBranch'] = UserBranch;
    return _data;
  }
}
