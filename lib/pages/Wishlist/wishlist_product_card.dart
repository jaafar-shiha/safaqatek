import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/utils/hourglass_image.dart';

class WishlistProductCard extends StatefulWidget {
  final Product product;
  final Function(Product) onDelete;

  const WishlistProductCard({
    Key? key,
    required this.product,
    required this.onDelete,
  }) : super(key: key);

  @override
  _WishlistProductCardState createState() => _WishlistProductCardState();
}

class _WishlistProductCardState extends State<WishlistProductCard> {
  @override
  Widget build(BuildContext context) {
    final double percent = HourglassImage.getSoldOutQuantityPercent(
      soldOutQuantity: widget.product.soldOut,
      totalQuantity: widget.product.quantity,
    );
    CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context, listen: true);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.gray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        widget.product.image,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const SizedBox(
                            height: 110,
                            width: 95,
                          );
                        },
                        errorBuilder: (context, child, errorBuilder) {
                          return const SizedBox(
                            height: 110,
                            width: 95,
                          );
                        },
                        height: 110,
                        width: 95,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.name.toUpperCase(), style: AppStyles.h3,),
                      Text(widget.product.awardName.toUpperCase(), style: AppStyles.h3),
                      Text(
                        '${widget.product.currency.toUpperCase()} ${widget.product.price}',
                        style: AppStyles.h3.copyWith(
                          color: AppColors.dirtyPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${S.of(context).outOf} ${widget.product.quantity}',
                    style: AppStyles.h5.copyWith(color: AppColors.dirtyPurple),
                  ),
                  Image.asset(
                    HourglassImage.getHourglass(percent: percent),
                    fit: BoxFit.cover,
                    height: 50,
                  ),
                  Text(
                    '${S.of(context).sold} ${widget.product.soldOut}',
                    style: AppStyles.h5.copyWith(color: AppColors.dirtyPurple),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18,
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart, color: AppColors.whiteLilac, size: 20),
                      onPressed: () {
                        cartProductsProvider.addProductToCart(product: widget.product);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    bottom: 8.0,
                    top: 14.0,
                    left: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.gray,
                    child: IconButton(
                      icon: Image.asset('assets/images/un-favorite.png'),
                      onPressed: () {
                        widget.onDelete(widget.product);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(
          height: 0.5,
          indent: 15,
          endIndent: 15,
          color: AppColors.lightGray,
        ),
      ],
    );
  }
}
