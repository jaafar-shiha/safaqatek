import 'package:flutter/material.dart';
import 'package:safaqtek/models/SliderImages/image_slider.dart';

class ImageSliderCard extends StatefulWidget {
  final ImageSlider image;
  const ImageSliderCard({Key? key, required this.image}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSliderCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.network(
        widget.image.image,
        loadingBuilder: (context,child,loadingProgress){
          if (loadingProgress == null) {
            return child;
          }
          return const SizedBox(height: 65,width: double.infinity - 100,);
        },
        errorBuilder: (context, child, errorBuilder) {
          return const SizedBox(
            height: 85,
          );
        },
        height: 85,
      ),
    );
  }
}
