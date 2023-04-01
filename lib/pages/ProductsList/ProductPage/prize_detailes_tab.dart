import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Products/product.dart';

class PrizeDetailsTab extends StatefulWidget {
  final Product product;
  const PrizeDetailsTab({Key? key,required this.product}) : super(key: key);

  @override
  _PrizeDetailsTabState createState() => _PrizeDetailsTabState();
}

class _PrizeDetailsTabState extends State<PrizeDetailsTab> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '${S.of(context).getAChanceTo} ${S.of(context).win} ${widget.product.awardName}'.toUpperCase(),
            style: TextStyle(
              fontSize: 19,
              color: AppColors.gunPowder,
              letterSpacing: 1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.product.awardDescription,
            style: AppStyles.h2,
          ),
        ),
      ],
    );
  }
}
