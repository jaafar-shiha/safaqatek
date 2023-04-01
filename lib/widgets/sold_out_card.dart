import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Products/product.dart';

class SoldOutCard extends StatefulWidget {
  final Product product;

  const SoldOutCard({Key? key, required this.product,}) : super(key: key);

  @override
  State<SoldOutCard> createState() => _SoldOutCardState();
}

class _SoldOutCardState extends State<SoldOutCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        right: 8.0,
        left: 8.0,
      ),
      child: Container(
        width: 210,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),

        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    widget.product.image,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        height: 100,
                      );
                    },
                    errorBuilder: (context, child, errorBuilder) {
                      return const SizedBox(
                        height: 100,
                      );
                    },
                    height: 100,
                  ),
                  Text.rich(
                    TextSpan(
                      text: '${widget.product.price} ${widget.product.currency}'.toUpperCase(),
                      style: AppStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: '\n${S.of(context).drawDate} ',
                          style: AppStyles.h4.copyWith(
                            color: AppColors.gunPowder,
                          ),
                          children: [
                            TextSpan(
                              text: widget.product.createdAt,
                              style: AppStyles.h4,
                            ),
                          ],),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 220,
                      height: 30,
                      child: TextButton(
                        onPressed: widget.product.isParticipate ? () {} : null,
                        child: Text(
                          widget.product.isParticipate
                              ? S.of(context).youAreParticipantInThis
                              : S.of(context).youAreNotParticipantInThis,
                          style: AppStyles.h4.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: widget.product.isParticipate ? AppColors.dirtyPurple : AppColors.gray,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                width: 1,
                                color: widget.product.isParticipate ? AppColors.dirtyPurple : AppColors.gray,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                child: Image.asset(
                  'assets/images/sold_out.png',
                  height: 110,
                  width: 110,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
