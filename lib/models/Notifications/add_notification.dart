class AddNotification {
  AddNotification({
    required this.title,
    required this.body,
  });

  String title;
  String body;

  AddNotification copyWith({
    String? title,
    String? body,
  }) =>
      AddNotification(
        title: title ?? this.title,
        body: body ?? this.body,
      );

  factory AddNotification.fromMap(Map<String, dynamic> json) => AddNotification(
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "body": body,
  };
}
