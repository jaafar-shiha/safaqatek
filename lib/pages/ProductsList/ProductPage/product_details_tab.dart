import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/models/Products/product.dart';

class ProductDetailsTab extends StatefulWidget {
  final Product product;
  const ProductDetailsTab({Key? key,required this.product}) : super(key: key);

  @override
  _ProductDetailsTabState createState() => _ProductDetailsTabState();
}

class _ProductDetailsTabState extends State<ProductDetailsTab> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.product.name.toUpperCase(),
            style: TextStyle(
              fontSize: 19,
              color: AppColors.gunPowder,
              letterSpacing: 1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.product.description,
            style: AppStyles.h2,
          ),
        ),
      ],
    );
  }
}
