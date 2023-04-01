import 'package:safaqtek/models/Payment/reusable_cart.dart';

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.nationality,
    this.residence,
    this.currency,
    this.addresse,
    this.avatar,
    this.lang,
    this.sex,
    this.purchases,
    this.allowNotifications = false,
    this.longitude,
    this.latitude,
    this.reusableCarts,
  });

  String firstName;
  String lastName;
  String email;
  String? nationality;
  String? residence;
  String? currency;
  String? addresse;
  String? avatar;
  String? lang;
  String? sex;
  int? purchases;
  String? phone;
  bool? allowNotifications;
  String? longitude;
  String? latitude;
  List<ReusableCart>? reusableCarts;

  factory User.fromMap(Map<String, dynamic> json) => User(
    firstName: json["firstname"],
    lastName: json["lastname"],
    email: json["email"],
    phone: json["phone"],
    nationality: json["nationality"],
    residence: json["residence"],
    currency: json["currency"],
    addresse: json["addresse"],
    avatar: json["avatar"],
    lang: json["lang"],
    sex: json["sex"],
    purchases: json["purchases"],
    allowNotifications: json["allow_notifications"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    reusableCarts: json["cards"] == null ? [] : List<ReusableCart>.from(json["cards"].map((x) => ReusableCart.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "firstname": firstName,
    "lastname": lastName,
    "email": email,
    "phone": phone,
    "nationality": nationality,
    "residence": residence,
    "currency": currency,
    "addresse": addresse,
    "avatar": avatar,
    "lang": lang,
    "sex": sex,
    "purchases": purchases,
    "allow_notifications": allowNotifications,
    "longitude": longitude,
    "latitude": latitude,
    "cards": reusableCarts == null ? [] : reusableCarts!.map((e) => e.toMap()).toList(),
  };
}
