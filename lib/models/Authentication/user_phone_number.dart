class UserPhoneNumber {
  UserPhoneNumber({
    required this.code,
    this.data,
  });

  String code;
  PhoneData? data;

  factory UserPhoneNumber.fromMap(Map<String, dynamic> json) => UserPhoneNumber(
    code: json["code"],
    data: json["data"] == null ? null : PhoneData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "data": data?.toMap(),
  };
}

class PhoneData {
  PhoneData({
     this.phone,
  });

  String? phone;

  factory PhoneData.fromMap(Map<String, dynamic> json) => PhoneData(
    phone: json["phone"],
  );

  Map<String, dynamic> toMap() => {
    "phone": phone,
  };
}
