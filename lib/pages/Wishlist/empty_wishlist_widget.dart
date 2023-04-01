import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/providers/tabs_provider.dart';

class EmptyWishlistWidget extends StatelessWidget {
  const EmptyWishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                S.of(context).yourWishlistIsEmpty,
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.dirtyPurple,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/empty-wishlist.png'),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextButton(
                  onPressed: () {
                    tabsProvider.setCurrentTab(currentTab: Tabs.home);
                  },
                  child: Text(
                    S.of(context).goShopping,
                    style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
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
              ),
            ),
          ],
        )
      ],
    );
  }
}
