import 'package:flutter/material.dart';

class CustomContainerClipper extends CustomClipper<Path> {

  final double borderRadius;
  final bool onlyFromTopEdges;
  CustomContainerClipper({this.borderRadius = 50, this.onlyFromTopEdges = true});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0,  borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);
    if (onlyFromTopEdges){
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    else{
      path.lineTo(size.width, size.height - borderRadius);
      path.quadraticBezierTo(size.width, size.height, size.width - borderRadius, size.height);
      path.lineTo(borderRadius, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);
      path.lineTo(0, borderRadius);
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }


}
