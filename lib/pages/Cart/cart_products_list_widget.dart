import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/pages/Cart/cart_product_card.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/widgets/toggle.dart';

class CartProductsListWidget extends StatefulWidget {
  const CartProductsListWidget({Key? key}) : super(key: key);

  @override
  _CartProductsListWidgetState createState() => _CartProductsListWidgetState();
}

class _CartProductsListWidgetState extends State<CartProductsListWidget> {
  @override
  Widget build(BuildContext context) {
    CartProductsProvider productsProvider = Provider.of<CartProductsProvider>(context, listen: true);
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
              children: productsProvider.cartProducts
                  .map((product) => CartProductCard(
                        product: product,
                      ))
                  .toList()),
          if (locator<MainApp>().appSettings!.data.setting.donateOption)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Toggle(
                onChanged: (value) {
                  productsProvider.isDonate = value;
                },
                isActivated: productsProvider.isDonate,
                textColor: AppColors.frenchBlue,
                title: '${S.of(context).ifYouDonateYourProductsYouWillGet} ${Provider.of<CartProductsProvider>(
                  context,listen: true
                ).getProductsCountInCart * 2} ${S.of(context).coupons}',
              ),
            ),
        ],
      ),
    );
  }
}
