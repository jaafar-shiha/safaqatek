import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/pages/Cart/cart_products_list_widget.dart';
import 'package:safaqtek/pages/Cart/empty_cart_widget.dart';
import 'package:safaqtek/pages/Cart/payment/payment_page.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context);
    CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context);
    return WillPopScope(
      onWillPop: (){
        tabsProvider.setCurrentTab(currentTab: Tabs.home);
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: MainScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        tabsProvider.setCurrentTab(currentTab: Tabs.home);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.whiteLilac,
                      ),
                    ),
                    Text(
                      S.of(context).cart,
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.whiteLilac,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteLilac,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: cartProductsProvider.cartProducts.isEmpty ? const EmptyCartWidget() : const CartProductsListWidget(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteLilac,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  S.of(context).total,
                                  style: AppStyles.h2,
                                ),

                              ],
                            ),
                            Text(
                              '${cartProductsProvider.total} ${locator<MainApp>().currentUser?.currency?.toUpperCase()??'AED'}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.gunPowder,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: () async {
                            if (cartProductsProvider.total == 0) return;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PaymentPage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              S.of(context).checkout,
                              style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.frenchBlue,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
