import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/pages/LogIn/log_in_page.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'main_tab_bar_icon.dart';

class MainTabBar extends StatefulWidget {
  const MainTabBar({Key? key, }) : super(key: key);

  @override
  State<MainTabBar> createState() => _TabBarState();
}

class _TabBarState extends State<MainTabBar> {

  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context,listen: true);
    CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 2.5,
              blurRadius: 6,
              offset: Offset(1, 7), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MainTabBarIcon(
                title: S.of(context).home,
                imagePath: 'assets/images/home.png',
                isSelected: tabsProvider.selectedTab == Tabs.home,
                onPressed: (){
                  tabsProvider.setCurrentTab(currentTab: Tabs.home);
                },
              ),
              MainTabBarIcon(
                title: S.of(context).wishlist,
                imagePath: 'assets/images/wishlist.png',
                isSelected: tabsProvider.selectedTab == Tabs.wishlist,
                onPressed: (){
                  if (locator<MainApp>().token == null ||
                      locator<MainApp>().currentUser == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                    );
                    return;
                  }
                  tabsProvider.setCurrentTab(currentTab: Tabs.wishlist);
                },
              ),
              MainTabBarIcon(
                title: S.of(context).notifications,
                imagePath: 'assets/images/notifications.png',
                isSelected: tabsProvider.selectedTab == Tabs.notifications,
                onPressed: (){
                  if (locator<MainApp>().token == null ||
                      locator<MainApp>().currentUser == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                    );
                    return;
                  }
                  tabsProvider.setCurrentTab(currentTab: Tabs.notifications);
                },
              ),
              MainTabBarIcon(
                title: S.of(context).cart,
                imagePath: 'assets/images/cart.png',
                showNotification: true,
                numberInNotification: cartProductsProvider.getProductsCountInCart,
                isSelected: tabsProvider.selectedTab == Tabs.cart,
                onPressed: (){
                  if (locator<MainApp>().token == null ||
                      locator<MainApp>().currentUser == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                    );
                    return;
                  }
                  tabsProvider.setCurrentTab(currentTab: Tabs.cart);
                },
              ),
              MainTabBarIcon(
                title: S.of(context).coupons,
                imagePath: 'assets/images/coupons.png',
                isSelected: tabsProvider.selectedTab == Tabs.coupons,
                onPressed: (){
                  if (locator<MainApp>().token == null ||
                      locator<MainApp>().currentUser == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                    );
                    return;
                  }
                  tabsProvider.setCurrentTab(currentTab: Tabs.coupons);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
