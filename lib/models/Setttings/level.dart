class Level {
  Level({
    required this.name,
    required this.purchaseNumber,
  });

  String name;
  String purchaseNumber;

  factory Level.fromMap(Map<String, dynamic> json) => Level(
    name: json["name"],
    purchaseNumber: json["purchase_number"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "purchase_number": purchaseNumber,
  };
}

