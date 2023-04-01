
class AddCart {
  AddCart({
    required this.id,
    required this.quantity,
  });

  int id;
  int quantity;

  AddCart copyWith({
    int? id,
    int? quantity,
  }) =>
      AddCart(
        id: id ?? this.id,
        quantity: quantity ?? this.quantity,
      );

  factory AddCart.fromMap(Map<String, dynamic> json) => AddCart(
    id: json["id"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toMap() => {
    "\"id\"": id,
    "\"quantity\"": quantity,
  };
}