class BaseSuccessResponse {
  BaseSuccessResponse({
    required this.state,
    required this.code,
    required this.message,
    required this.execution,
  });

  bool state;
  String code;
  String message;
  String execution;

  factory BaseSuccessResponse.fromMap(Map<String, dynamic> json) => BaseSuccessResponse(
    state: json["state"],
    code: json["code"],
    message: json["message"],
    execution: json["execution"],
  );

  Map<String, dynamic> toMap() => {
    "state": state,
    "code": code,
    "message": message,
    "execution": execution,
  };
}
