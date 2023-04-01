import 'package:safaqtek/models/Authentication/registration_token.dart';

class ChangeAccountPasswordModel{

  String code;
  RegistrationToken? data;
  ChangeAccountPasswordModel({
    required this.code,
    this.data,
  });
  factory ChangeAccountPasswordModel.fromMap(Map<String, dynamic> json) => ChangeAccountPasswordModel(
    code: json["code"],
    data: json["data"] == null ? null : RegistrationToken.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "data": data?.toMap(),
  };
}
