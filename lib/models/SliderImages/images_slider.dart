import 'package:safaqtek/models/SliderImages/image_slider.dart';

class ImagesSlider {
  ImagesSlider({
    required this.images,
  });

  List<ImageSlider> images;

  factory ImagesSlider.fromMap(Map<String, dynamic> json) => ImagesSlider(
    images: List<ImageSlider>.from(json["data"].map((x) => ImageSlider.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(images.map((x) => x.toMap())),
  };
}