import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_bloc.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_event.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Winners/winner.dart';
import 'package:safaqtek/pages/Winners/video_page.dart';
import 'package:safaqtek/pages/Winners/winners_card.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WinnersPage extends StatefulWidget {
  const WinnersPage({Key? key}) : super(key: key);

  @override
  _WinnersPageState createState() => _WinnersPageState();
}

class _WinnersPageState extends State<WinnersPage> {
  @override
  void initState() {
    _productsBloc.add(const GetWinners());
    super.initState();
  }

  late final ProductsBloc _productsBloc = BlocProvider.of<ProductsBloc>(context);

  ValueNotifier<bool> isGettingWinnersSucceeded = ValueNotifier(false);

  List<Winner> winners = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is GetWinnersSucceeded) {
          isGettingWinnersSucceeded.value = true;
          setState(() {
            winners = state.winnersData.winners;
          });
        } else if (state is GetWinnersFailed) {
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        }
      },
      bloc: _productsBloc,
      listenWhen: (prev, cur) {
        return prev != cur;
      },
      child: MainScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      S.of(context).winners,
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.whiteLilac,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: isGettingWinnersSucceeded,
                  builder: (context, _, child) {
                    if (!isGettingWinnersSucceeded.value) {
                      return Expanded(
                        child: SpinKitPulse(
                          color: AppColors.whiteLilac,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                    return child!;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: winners
                          .map((winner) => WinnersCard(
                        videoId: YoutubePlayer.convertUrlToId(winner.url)!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideoPage(videoId: YoutubePlayer.convertUrlToId(winner.url)!),
                            ),
                          );
                        },
                      ))
                          .toList(),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
/*
* */
