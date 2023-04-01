class ReusableCartData {
  ReusableCartData({
    required this.brand,
    required this.expMonth,
    required this.expYear,
    required this.last4,
  });

  String brand;
  int expMonth;
  int expYear;
  String last4;

  ReusableCartData copyWith({
    String? brand,
    int? expMonth,
    int? expYear,
    String? last4,
  }) =>
      ReusableCartData(
        brand: brand ?? this.brand,
        expMonth: expMonth ?? this.expMonth,
        expYear: expYear ?? this.expYear,
        last4: last4 ?? this.last4,
      );

  factory ReusableCartData.fromMap(Map<String, dynamic> json) => ReusableCartData(
    brand: json["brand"],
    expMonth: json["exp_month"],
    expYear: json["exp_year"],
    last4: json["last4"],
  );

  Map<String, dynamic> toMap() => {
    "brand": brand,
    "exp_month": expMonth,
    "exp_year": expYear,
    "last4": last4,
  };
}
