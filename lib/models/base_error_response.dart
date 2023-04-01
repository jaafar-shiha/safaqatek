class BaseErrorResponse {
  BaseErrorResponse({
    this.state,
    this.code,
    required this.error,
    this.execution,
  });

  bool? state;
  String? code;
  String error;
  String? execution;

  factory BaseErrorResponse.fromMap(Map<String, dynamic> json) => BaseErrorResponse(
        state: json["state"],
        code: json["code"],
        error: json["error"] ?? json["message"],
        execution: json["execution"],
      );

  Map<String, dynamic> toMap() => {
        "state": state,
        "code": code,
        "error": error,
        "execution": execution,
      };
}
