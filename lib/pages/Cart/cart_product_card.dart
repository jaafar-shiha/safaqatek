import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';

import '../../widgets/app_dialog.dart';

class CartProductCard extends StatefulWidget {
  final Product product;

  const CartProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  @override
  Widget build(BuildContext context) {
    CartProductsProvider productsProvider = Provider.of<CartProductsProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.awardName.toUpperCase(), style: AppStyles.h2),
                        Text(widget.product.name.toUpperCase(), style: AppStyles.h2),
                        Text(
                          '${widget.product.price} ${widget.product.currency.toUpperCase()}',
                          style: AppStyles.h2.copyWith(
                            color: AppColors.dirtyPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              Text(
                                '${widget.product.coponPerUnit} ${S.of(context).coupon} ',
                                style: AppStyles.h3.copyWith(
                                  color: AppColors.dirtyPurple,
                                ),
                              ),
                              Text(
                                S.of(context).perUnit,
                                style: AppStyles.h3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 18,
                      child: IconButton(
                        icon: Icon(Icons.add, color: AppColors.whiteLilac, size: 20),
                        onPressed: () {
                          productsProvider.addProductToCart(product: widget.product);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '${productsProvider.cartProducts.singleWhere(
                            (element) => element.id == widget.product.id,
                          ).countOfThisProductInCart}',
                      style: AppStyles.h2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.gray,
                      child: IconButton(
                        icon: Icon(Icons.remove, color: AppColors.whiteLilac, size: 20),
                        onPressed: () {
                          if (productsProvider.cartProducts.singleWhere(
                                (element) => element.id == widget.product.id,
                          ).countOfThisProductInCart > 0) {
                            productsProvider.removeProductFromCart(product: widget.product);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AppDialog.showAlertDialog(
                                  title: S.of(context).areYouSureYouWantToRemoveThisItemFromYourCart,
                                  actions: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          S.of(context).keepIt,
                                          style: AppStyles.h3,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          S.of(context).yesRemove,
                                          style: AppStyles.h3,
                                        ),
                                      ),
                                    )
                                  ]),
                            );
                          }
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
      ),
    );
  }
}
