class LogInModel {
  final String emailOrPhoneNumber;
  final String password;

  LogInModel({required this.emailOrPhoneNumber, required this.password});

  factory LogInModel.fromMap(Map<String, dynamic> json) => LogInModel(
        emailOrPhoneNumber: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "email": emailOrPhoneNumber,
        "password": password,
      };
}
