class PhoneNumberSuccessResponse {
  final bool accept;

  PhoneNumberSuccessResponse({required this.accept,});

  factory PhoneNumberSuccessResponse.fromMap(Map<String, dynamic> json) => PhoneNumberSuccessResponse(
    accept: json["accept"],
  );

  Map<String, dynamic> toMap() => {
    "accept": accept,
  };
}
