class Product {
  Product({
    required this.id,
    required this.name,
    required this.awardName,
    required this.image,
    //d required this.awardImage,
    required this.description,
    required this.awardDescription,
    required this.quantity,
    required this.soldOut,
    required this.coponPerUnit ,
    required this.price,
    required this.currency,
    required this.isFavorite ,
    required this.isParticipate ,
    required this.closingAt,
    required this.createdAt,
     this.countOfThisProductInCart =0,
  });

  int id;
  String name;
  String awardName;
  String image;
  //d String awardImage;
  String description;
  String awardDescription;
  int quantity;
  int soldOut;
  String coponPerUnit;
  int price;
  String currency;
  bool isFavorite;
  bool isParticipate;
  String closingAt;
  String createdAt;
  int countOfThisProductInCart;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        awardName: json["award_name"],
        image: json["image"],
    //d awardImage: json["award_image"],
        description: json["description"],
        awardDescription: json["award_description"],
        quantity: json["quantity"],
        soldOut: json["sold_out"],
        coponPerUnit: json["copon_per_unit"],
        price: json["price"],
        currency: json["currency"],
        isFavorite: json["isFavorite"],
        isParticipate: json["isParticipate"],
        closingAt: json["closing_at"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "award_name": awardName,
        "image": image,
    //d "award_image": awardImage,
        "description": description,
        "award_description": awardDescription,
        "quantity": quantity,
        "sold_out": soldOut,
        "copon_per_unit": coponPerUnit,
        "price": price,
        "currency": currency,
        "isFavorite": isFavorite,
        "isParticipate": isParticipate,
        "closing_at": closingAt,
        "created_at": createdAt,
      };

  Product copyWith({
    String? name,
    String? awardName,
    String? image,
    //d String? awardImage,
    String? description,
    String? awardDescription,
    int? quantity,
    int? soldOut,
    String? coponPerUnit,
    int? price,
    String? currency,
    bool? isFavorite,
    bool? isParticipate,
    String? closingAt,
    String? createdAt,
    int? countOfThisProductInCart,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      awardName: awardName ?? this.awardName,
      image: image ?? this.image,
      //d awardImage: awardImage ?? this.awardImage,
      description: description ?? this.description,
      awardDescription: awardDescription ?? this.awardDescription,
      quantity: quantity ?? this.quantity,
      soldOut: soldOut ?? this.soldOut,
      coponPerUnit: coponPerUnit ?? this.coponPerUnit,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      isFavorite: isFavorite ?? this.isFavorite,
      isParticipate: isParticipate ?? this.isParticipate,
      closingAt: closingAt ?? this.closingAt,
      createdAt: createdAt ?? this.createdAt,
      countOfThisProductInCart: countOfThisProductInCart ?? this.countOfThisProductInCart,
    );
  }
}
