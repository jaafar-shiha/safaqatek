import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/pages/Cart/cart_page.dart';
import 'package:safaqtek/pages/Coupons/coupons_page.dart';
import 'package:safaqtek/pages/ProductsList/products_list.dart';
import 'package:safaqtek/pages/Notifications/notifications_page.dart';
import 'package:safaqtek/pages/Wishlist/wishlist_page.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:safaqtek/widgets/main_tab_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget getPageForSelectedTab({required Tabs selectedTab}) {
    switch (selectedTab) {
      case Tabs.home:
        return const ProductsList();
      case Tabs.wishlist:
        return const WishlistPage();
      case Tabs.notifications:
        return const NotificationsPage();
      case Tabs.cart:
        return const CartPage();
      case Tabs.coupons:
        return const CouponsPage();
      default:
        return const ProductsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context,listen: true);
    locator<MainApp>().context = context;
    return MainScaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            getPageForSelectedTab(selectedTab: tabsProvider.selectedTab),
            const MainTabBar(),
          ],
        ),
      ),
    );
  }
}
