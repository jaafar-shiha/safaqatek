class ImageSlider {
  ImageSlider({
    required this.id,
    required this.image,
    required this.active,
  });

  int id;
  String image;
  bool active;

  factory ImageSlider.fromMap(Map<String, dynamic> json) => ImageSlider(
    id: json["id"],
    image: json["image"],
    active: json["active"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "image": image,
    "active": active,
  };
}
