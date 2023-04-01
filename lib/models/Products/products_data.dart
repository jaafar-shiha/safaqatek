import 'package:safaqtek/models/Products/product.dart';

class ProductsData {
  ProductsData({
    required this.products,
  });

  List<Product> products;

  factory ProductsData.fromMap(Map<String, dynamic> json) => ProductsData(
    products: List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(products.map((x) => x.toMap())),
  };
}
