import 'package:flutter/material.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/pages/Wishlist/wishlist_product_card.dart';

class FavoriteProductsListWidget extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onDelete;

  const FavoriteProductsListWidget({
    Key? key,
    required this.products,
    required this.onDelete,
  }) : super(key: key);

  @override
  _FavoriteProductsListWidgetState createState() => _FavoriteProductsListWidgetState();
}

class _FavoriteProductsListWidgetState extends State<FavoriteProductsListWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: widget.products
            .map((product) => WishlistProductCard(
                  product: product,
                  onDelete: widget.onDelete,
                ))
            .toList(),
      ),
    );
  }
}
