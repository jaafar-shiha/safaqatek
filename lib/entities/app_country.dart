class AppCountry {
  AppCountry({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.maxLength,
    required this.minLength,
    required this.flag,
  });

  String name;
  String code;
  String dialCode;
  String maxLength;
  String minLength;
  String flag;

  AppCountry copyWith({
    String? name,
    String? code,
    String? dialCode,
    String? maxLength,
    String? minLength,
    String? flag,
  }) =>
      AppCountry(
        name: name ?? this.name,
        code: code ?? this.code,
        dialCode: dialCode ?? this.dialCode,
        maxLength: maxLength ?? this.maxLength,
        minLength: minLength ?? this.minLength,
        flag: flag ?? this.flag,
      );

  factory AppCountry.fromMap(Map<String, dynamic> json) => AppCountry(
    name: json["name"],
    code: json["code"],
    dialCode: json["dialCode"],
    maxLength: json["maxLength"],
    minLength: json["minLength"],
    flag: json["flag"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "code": code,
    "dialCode": dialCode,
    "maxLength": maxLength,
    "minLength": minLength,
    "flag": flag,
  };
}
