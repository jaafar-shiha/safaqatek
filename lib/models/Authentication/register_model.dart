class RegisterModel {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String phone;

  RegisterModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phone,
  });

  factory RegisterModel.fromMap(Map<String, dynamic> json) => RegisterModel(
        email: json["email"],
        firstName: json["firstname"],
        lastName: json["lastname"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "firstname": firstName,
        "lastname": lastName,
        "password": password,
        "phone": phone,
      };
}
