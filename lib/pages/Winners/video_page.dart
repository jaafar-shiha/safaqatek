import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_video_info/youtube.dart';

class VideoPage extends StatefulWidget {
  final String videoId;

  const VideoPage({Key? key, required this.videoId}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;
  static YoutubeDataModel? videoData;
  YoutubeExplode yt = YoutubeExplode();
  DateTime? uploadDate;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<YoutubeDataModel> getVideoData() async {
    var video = yt.videos.get('https://youtube.com/watch?v=Dpp1sIL1m5Q'); // Returns a Video instance.
    await video.then((value) {
      uploadDate = value.uploadDate;
    });
    return await YoutubeData.getData('https://www.youtube.com/watch?v=${widget.videoId}');
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.whiteLilac,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: YoutubePlayerBuilder(
                onExitFullScreen: () {
                  SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                },
                player: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                  bottomActions: [
                    CurrentPosition(),
                    const SizedBox(
                      width: 4,
                    ),
                    ProgressBar(
                      isExpanded: true,
                      colors: ProgressBarColors(
                          backgroundColor: AppColors.gray,
                          playedColor: AppColors.ferrariRed,
                          handleColor: AppColors.ferrariRed),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    RemainingDuration(),
                    const SizedBox(
                      width: 8,
                    ),
                    PlaybackSpeedButton(
                      controller: _controller,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'YouTube',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.whiteLilac,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    FullScreenButton(),
                  ],
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      player,
                    ],
                  );
                },
              ),
            ),
            FutureBuilder<YoutubeDataModel>(
              future: getVideoData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.frenchBlue,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Expanded(child: Center( child: Text(S.of(context).anErrorHasOccurred)));
                } else if (snapshot.hasData) {
                  videoData = snapshot.data;
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            uploadDate != null
                                ? Text(
                                    '${uploadDate!.day} '
                                    '${DateFormat.MMMM().format(uploadDate!)}, '
                                    '${DateFormat.y().format(uploadDate!)}',
                                    style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                  )
                                : Text(
                                    S.of(context).uploadDateNotAvailable,
                                    style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${videoData!.title}',
                              style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: AppColors.whiteLilac),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${videoData!.viewCount!} ${S.of(context).views}',
                                  style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text(
                                '${videoData!.description}',
                                style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else{
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
