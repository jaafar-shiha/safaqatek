import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Winners/winner.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WinnersCard extends StatefulWidget {
  final Winner winner;
  const WinnersCard({Key? key,required this.winner}) : super(key: key);

  @override
  State<WinnersCard> createState() => _WinnersCardState();
}

class _WinnersCardState extends State<WinnersCard> {

  late String videoId;

  @override
  void initState() {
    videoId = YoutubePlayer.convertUrlToId(widget.winner.url)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          right: 8.0,
          left: 8.0,
        ),
        child: Container(
          width: 190,
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
                  YoutubePlayer.getThumbnail(videoId: videoId),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      height: 100,
                    );
                  },
                  errorBuilder: (context, child, loadingProgress) {
                    return Container(
                      height: 100,
                    );
                  },
                  height: 100,
                ),
                Text.rich(
                  TextSpan(
                    text: S.of(context).congratulations,
                    style: AppStyles.h3.copyWith(
                      color: AppColors.dirtyPurple,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.winner.firstName,
                  style: AppStyles.h3,
                ),
                Text(
                  '${S.of(context).onWinning} ${widget.winner.awardName}',
                  style: AppStyles.h3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${S.of(context).couponNo} ${widget.winner.coupon}',
                    style: AppStyles.h4.copyWith(
                      color: AppColors.gunPowder,
                      fontSize: 8,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Text(
                  '${S.of(context).announced} ${widget.winner.announcedOn}',
                  style: AppStyles.h4.copyWith(
                    color: AppColors.gunPowder,
                    fontSize: 8,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
