class Cart {
  Cart({
    required this.name,
    required this.price,
    required this.currency,
    required this.quantity,
  });

  String name;
  int price;
  String currency;
  String quantity;

  Cart copyWith({
    String? name,
    int? price,
    String? currency,
    String? quantity,
  }) =>
      Cart(
        name: name ?? this.name,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        quantity: quantity ?? this.quantity,
      );

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
    name: json["name"],
    price: json["price"],
    currency: json["currency"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "price": price,
    "currency": currency,
    "quantity": quantity,
  };
}