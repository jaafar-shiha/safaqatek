
class CouponProduct {
  CouponProduct({
    required this.name,
     this.awardName,
    //d required this.awardImage,
    required this.image,
    required this.closingAt,
    required this.price,
    required this.currency,
  });

  String name;
  String? awardName;
  //d String awardImage;
  String image;
  String closingAt;
  int price;
  String currency;

  CouponProduct copyWith({
    String? name,
    String? awardName,
    String? image,
    //d String? awardImage,
    String? closingAt,
    int? price,
    String? currency,
  }) =>
      CouponProduct(
        name: name ?? this.name,
        awardName: awardName ?? this.awardName,
        image: image ?? this.image,
        //d awardImage: awardImage ?? this.awardImage,
        closingAt: closingAt ?? this.closingAt,
        price: price ?? this.price,
        currency: currency ?? this.currency,
      );

  factory CouponProduct.fromMap(Map<String, dynamic> json) => CouponProduct(
    name: json["name"],
    awardName: json["award_name"],
    image: json["image"],
    //d awardImage: json["award_image"],
    closingAt: json["closing_at"],
    price: json["price"],
    currency: json["currency"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "award_name": awardName,
    "image": image,
    //d "award_image": awardImage,
    "closing_at": closingAt,
    "price": price,
    "currency": currency,
  };
}
