
class NotificationModel {
  NotificationModel({
    required this.title,
    required this.body,
    required this.createdAt,
  });

  String title;
  String body;
  String createdAt;

  NotificationModel copyWith({
    String? title,
    String? body,
    String? createdAt,
  }) =>
      NotificationModel(
        title: title ?? this.title,
        body: body ?? this.body,
        createdAt: createdAt ?? this.createdAt,
      );

  factory NotificationModel.fromMap(Map<String, dynamic> json) => NotificationModel(
    title: json["title"],
    body: json["body"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "body": body,
    "created_at": createdAt,
  };
}
