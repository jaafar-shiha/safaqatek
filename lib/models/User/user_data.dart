import 'package:safaqtek/models/User/user.dart';

class UserData {
  UserData({
    required this.user,
  });

  User user;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    user: User.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "data": user.toMap(),
  };
}
