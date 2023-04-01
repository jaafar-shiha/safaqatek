import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WinnersCard extends StatefulWidget {
  final String videoId;
  final Function() onTap;

  const WinnersCard({
    Key? key,
    required this.videoId,
    required this.onTap,
  }) : super(key: key);

  @override
  State<WinnersCard> createState() => _WinnersCardState();
}

class _WinnersCardState extends State<WinnersCard> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;

  @override
  initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteLilac,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Samsung galaxy z fold 3 bundle',
                  style: AppStyles.h2.copyWith(color: AppColors.dirtyPurple),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'USER NAME',
                          style: AppStyles.h2.copyWith(color: AppColors.dirtyPurple),
                        ),
                        Text(
                          '${S.of(context).winnerAnnouncedOn}\nJanuary 12, 2022',
                          style: AppStyles.h3,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        YoutubePlayer.getThumbnail(videoId: widget.videoId),
                        height: 80,
                        errorBuilder: (context, child, errorBuilder) {
                          return Container(
                            height: 80,
                            width: 100,
                            decoration: BoxDecoration(
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
                            child: Center(
                              child: Icon(
                                Icons.error,
                                color: AppColors.whiteLilac,
                                size: 30,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return FadeTransition(
                            opacity: animation!,
                            child: Container(
                              height: 80,
                              width: 100,
                              decoration: BoxDecoration(
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
