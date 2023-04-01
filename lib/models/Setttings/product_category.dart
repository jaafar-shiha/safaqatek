class ProductCategory {
  ProductCategory({
    required this.id,
    required this.name,
     this.image,
  });

  int id;
  String name;
  String? image;

  factory ProductCategory.fromMap(Map<String, dynamic> json) => ProductCategory(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

