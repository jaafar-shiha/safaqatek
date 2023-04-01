class Country {
  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.dialCode,
    required this.maxLength,
    required this.minLength,
    required this.flag,
  });

  int id;
  String name;
  String code;
  String dialCode;
  String maxLength;
  String minLength;
  String flag;

  Country copyWith({
    int? id,
    String? name,
    String? code,
    String? dialCode,
    String? maxLength,
    String? minLength,
    String? flag,
  }) =>
      Country(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code ?? this.code,
        dialCode: dialCode ?? this.dialCode,
        maxLength: maxLength ?? this.maxLength,
        minLength: minLength ?? this.minLength,
        flag: flag ?? this.flag,
      );

  factory Country.fromMap(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    dialCode: json["dialCode"],
    maxLength: json["maxLength"],
    minLength: json["minLength"],
    flag: json["flag"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "code": code,
    "dialCode": dialCode,
    "maxLength": maxLength,
    "minLength": minLength,
    "flag": flag,
  };
}
