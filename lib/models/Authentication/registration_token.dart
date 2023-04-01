
class RegistrationToken  {
  RegistrationToken({
    required this.id,
    required this.token,
  });

  int id;
  String token;

  @override
  factory RegistrationToken.fromMap(Map<String, dynamic> json) => RegistrationToken(
    id: json['id'],
    token: json['token'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'token': token,
  };
}
