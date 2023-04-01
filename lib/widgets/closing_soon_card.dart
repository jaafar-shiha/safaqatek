import 'package:flutter/material.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/pages/LogIn/log_in_page.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/product_page.dart';
import 'package:safaqtek/utils/hourglass_image.dart';

class ClosingSoonCard extends StatelessWidget {
  final Product product;

  const ClosingSoonCard({Key? key, required this.product}) : super(key: key);

  Color getLinearIndicatorColor({required double percent}) {
    if (percent <= 0.35) {
      return AppColors.darkMintGreen;
    } else if (percent > 0.35 && percent <= 0.75) {
      return AppColors.golden;
    } else if (percent > 0.75) {
      return AppColors.ferrariRed;
    } else {
      return AppColors.darkMintGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double percent = HourglassImage.getSoldOutQuantityPercent(
      soldOutQuantity: product.soldOut,
      totalQuantity: product.quantity,
    );
    final Color linearIndicatorColor = getLinearIndicatorColor(percent: percent);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        right: 8.0,
        left: 8.0,
      ),
      child: GestureDetector(
        onTap: (){
          if (locator<MainApp>().token == null ||
              locator<MainApp>().currentUser == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
            );
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductPage(product: product)));
        },
        child: Container(
          width: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),

          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  product.image,
                  loadingBuilder: (context,child,loadingProgress){
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(height: 85,);
                  },
                  errorBuilder: (context, child, errorBuilder) {
                    return const SizedBox(
                      height: 85,
                    );
                  },
                  height: 85,
                ),
                Text.rich(
                  TextSpan(
                    text: S.of(context).getAChanceTo,
                    style: AppStyles.h5,
                    children: <InlineSpan>[
                      TextSpan(
                        text: ' ${S.of(context).win}:',
                        style: AppStyles.h5.copyWith(
                          color: AppColors.dirtyPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${product.price} ${product.currency.toUpperCase()}',
                  style: AppStyles.h4.copyWith(color: AppColors.gunPowder),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${product.soldOut} ${S.of(context).soldOutOf} ${product.quantity}',
                    style: AppStyles.h5,
                  ),
                ),
                LinearPercentIndicator(
                  lineHeight: 5.0,
                  percent: percent,
                  backgroundColor: AppColors.ashGrey,
                  progressColor: linearIndicatorColor,
                  animation: true,
                  barRadius: const Radius.circular(75),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
