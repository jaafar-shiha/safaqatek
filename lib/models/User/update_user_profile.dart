class UpdateUserProfile {
  UpdateUserProfile({
     this.firstName,
     this.lastName,
     this.email,
     this.currency,
     this.nationalId,
     this.residenceId,
     this.addresse,
     this.phone,
     this.avatar,
     this.lang,
     this.sex,
     this.allowNotifications,
    this.longitude,
    this.latitude,
  });

  String? firstName;
  String? lastName;
  String? email;
  String? currency;
  int? nationalId;
  int? residenceId;
  String? addresse;
  String? phone;
  String? avatar;
  String? lang;
  String? sex;
  bool? allowNotifications;
  String? longitude;
  String? latitude;

  factory UpdateUserProfile.fromMap(Map<String, dynamic> json) => UpdateUserProfile(
    firstName: json["firstname"],
    lastName: json["lastname"],
    email: json["email"],
    currency: json["currency"],
    residenceId: json["residence_id"],
    phone: json["phone"],
    addresse: json["addresse"],
    avatar: json["avatar"],
    lang: json["lang"],
    sex: json["sex"],
    allowNotifications: json["allow_notifications"],
    longitude: json["longitude"],
    latitude: json["latitude"],
  );

  Map<String, dynamic> toMap() => {
    "firstname": firstName,
    "lastname": lastName,
    "email": email,
    "currency": currency,
    "residence_id": residenceId,
    "phone": phone,
    "addresse": addresse,
    "avatar": avatar,
    "lang": lang,
    "sex": sex,
    "allow_notifications": allowNotifications,
    "longitude": longitude,
    "latitude": latitude,
  }..removeWhere((key, value) => value == null);

  UpdateUserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? currency,
    int? nationalId,
    int? residenceId,
    String? addresse,
    String? phone,
    String? avatar,
    String? lang,
    String? sex,
    bool? allowNotifications,
    String? longitude,
    String? latitude,
  }) =>
      UpdateUserProfile(
        firstName: firstName ?? this.firstName,
        lastName: firstName ?? this.lastName,
        email: email ?? this.email,
        currency: currency ?? this.currency,
        nationalId: nationalId ?? this.nationalId,
        residenceId: residenceId ?? this.residenceId,
        addresse: addresse ?? this.addresse,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        lang: lang ?? this.lang,
        sex: sex ?? this.sex,
        allowNotifications: allowNotifications ?? this.allowNotifications,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
      );
}
