import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Coupons/coupon.dart';

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  const CouponCard({Key? key,required this.coupon}) : super(key: key);


  String getDesc(BuildContext context){
    late DateTime closingDate = DateTime.now();
    try{
      closingDate = Intl.withLocale('en', () => DateFormat("MM/dd/yyyy").parse(coupon.product.closingAt));
    }
    catch(e){
      closingDate = DateTime.now();
    }
    if (coupon.isWinner??false) {
      return S.of(context).winningCoupon;
    }
    else if (DateTime.now().isAfter(closingDate)){
      return S.of(context).expired;
    }
      else{
      return S.of(context).closingIn;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        right: 15.0,
        left: 15.0,
        bottom: 8.0,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  AppColors.dirtyPurple,
                  AppColors.royalFuchsia,
                  AppColors.royalFuchsia,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(S.of(context).safaqatek, style: AppStyles.h1),
                                const SizedBox(height: 22),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    coupon.product.awardName?.toUpperCase()??S.of(context).awardName,
                                    style: AppStyles.h1.copyWith(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    '${S.of(context).product}: ${coupon.product.name.toUpperCase()}',
                                    style: AppStyles.h1.copyWith(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    '${S.of(context).purchasedOn}: \n${coupon.createdAt}',
                                    style: AppStyles.h1.copyWith(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Container(
                          color: AppColors.whiteLilac,
                          height: 150,
                          width: 130,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Transform.scale(
                              scale: 1.2,
                              child: Image.network(
                                coupon.product.image,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const SizedBox(
                                    height: 150,
                                    width: 130,
                                  );
                                },
                                errorBuilder: (context, child, errorBuilder) {
                                  return const SizedBox(
                                    height: 150,
                                    width: 130,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    thickness: 1,
                    color: AppColors.whiteLilac,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0, bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/clock.png', height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${getDesc(context)}: ${coupon.product.closingAt}',
                              style: AppStyles.h3.copyWith(color: AppColors.whiteLilac),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${S.of(context).couponNo} ${coupon.key}',
                              style: AppStyles.h3.copyWith(color: AppColors.whiteLilac),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -12,
            right: -5,
            child: CircleAvatar(
              child: Text(
                coupon.participateWith,
                style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
              ),
              radius: 16,
            ),
          ),
        ],
      ),
    );
  }
}
