import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_bloc.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_event.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/models/SliderImages/image_slider.dart';
import 'package:safaqtek/models/Winners/winner.dart';
import 'package:safaqtek/pages/LogIn/log_in_page.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/closing_soon_shimmer.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/image_slider_card.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/image_slider_shimmer.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/prizes_shimmer.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/sold_out_shimmer.dart';
import 'package:safaqtek/pages/Profile/profile_page.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/widgets/app_dialog.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/closing_soon_card.dart';
import 'package:safaqtek/widgets/custom_container_clipper.dart';
import 'package:safaqtek/widgets/prizes_card.dart';
import 'package:safaqtek/widgets/prizes_type_chips_choices.dart';
import 'package:safaqtek/widgets/sold_out_card.dart';
import 'package:safaqtek/widgets/winners_card.dart';
import 'dart:io' show Platform, exit;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  int prizeCategoryId = 0;

  late final ProductsBloc _productsBloc = BlocProvider.of<ProductsBloc>(context);

  @override
  initState() {
    _productsBloc.add(GetProducts(prizeTypeId: prizeCategoryId));
    _productsBloc.add(const GetClosingSoonProducts());
    _productsBloc.add(const GetImagesSlider());
    _productsBloc.add(const GetSoldOutProducts());
    _productsBloc.add(const GetWinners());
    super.initState();
  }

  ValueNotifier<bool> isGettingClosingSoonProductsSucceeded = ValueNotifier(false);

  ValueNotifier<bool> isGettingPrizesSucceeded = ValueNotifier(false);

  ValueNotifier<bool> isGettingImagesSliderSucceeded = ValueNotifier(false);

  ValueNotifier<bool> isGettingSoldOutProductsSucceeded = ValueNotifier(false);

  ValueNotifier<bool> isGettingWinnersSucceeded = ValueNotifier(false);

  List<Product> prizes = List.empty(growable: true);

  List<Product> closingSoonProducts = List.empty(growable: true);

  List<Product> soldOutProducts = List.empty(growable: true);

  List<ImageSlider> imagesSlider = List.empty(growable: true);

  List<Winner> winners = List.empty(growable: true);

  late MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (locator<MainApp>().currentUser == null) {
          Navigator.pop(context);
          return Future.delayed(const Duration(milliseconds: 1));
        }
        showDialog(
          context: context,
          builder: (context) => AppDialog.showAlertDialog(title: S.of(context).doYouWantToCloseTheApp, actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  S.of(context).no,
                  style: AppStyles.h3,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                }
                if (Platform.isIOS) {
                  exit(0);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  S.of(context).yes,
                  style: AppStyles.h3,
                ),
              ),
            )
          ]),
        );
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: BlocListener<ProductsBloc, ProductsState>(
        listener: (context, state) {
          refreshController.refreshToIdle();

          //Handling get closing soon products
          if (state is GetClosingSoonProductsSucceeded) {
            isGettingClosingSoonProductsSucceeded.value = true;
            closingSoonProducts = state.productsData.products;
          } else if (state is GetClosingSoonProductsFailed) {
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          }

          //Handling get products
          if (state is GetProductsSucceeded) {
            isGettingPrizesSucceeded.value = true;
            prizes = state.productsData.products;
          } else if (state is GetProductsFailed) {
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          }

          //Handling get images slider
          if (state is GetImagesSliderSucceeded) {
            isGettingImagesSliderSucceeded.value = true;
            imagesSlider = state.imagesSlider.images;
          } else if (state is GetImagesSliderFailed) {
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          }

          //Handling get sold out products
          if (state is GetSoldOutProductsSucceeded) {
            isGettingSoldOutProductsSucceeded.value = true;
            soldOutProducts = state.productsData.products;
          } else if (state is GetSoldOutProductsFailed) {
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          }

          //Handling get winners
          if (state is GetWinnersSucceeded) {
            isGettingWinnersSucceeded.value = true;
            winners = state.winnersData.winners;
          } else if (state is GetWinnersFailed) {
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          }
        },
        listenWhen: (previous, current) {
          return previous != current;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).safaqatek,
                      style: AppStyles.h1,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (locator<MainApp>().token == null || locator<MainApp>().currentUser == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogInPage(
                                      isFromGuestPage: true,
                                    )),
                          );
                          return;
                        }
                        bool? needRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            ) ??
                            false;
                        if (needRefresh) {
                          isGettingClosingSoonProductsSucceeded.value = false;
                          isGettingImagesSliderSucceeded.value = false;
                          isGettingPrizesSucceeded.value = false;
                          isGettingSoldOutProductsSucceeded.value = false;
                          isGettingWinnersSucceeded.value = false;
                          _productsBloc.add(GetProducts(prizeTypeId: prizeCategoryId));
                          _productsBloc.add(const GetImagesSlider());
                          _productsBloc.add(const GetSoldOutProducts());
                          _productsBloc.add(const GetClosingSoonProducts());
                          _productsBloc.add(const GetWinners());
                          mainProvider.refresh(value: false);
                        }
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: (Provider.of<MainProvider>(context, listen: true).profileUrl != '' &&
                                Provider.of<MainProvider>(context, listen: true).profileUrl != null)
                            ? NetworkImage(
                                Provider.of<MainProvider>(context, listen: true).profileUrl!,
                              )
                            : const AssetImage('assets/images/default_profile_picture.png') as ImageProvider,
                        backgroundColor: AppColors.dirtyPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipPath(
                clipper: CustomContainerClipper(),
                child: Container(
                  color: AppColors.whiteLilac,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SmartRefresher(
                                controller: refreshController,
                                enablePullDown: true,
                                onRefresh: () {
                                  isGettingClosingSoonProductsSucceeded.value = false;
                                  _productsBloc.add(const GetClosingSoonProducts());

                                  isGettingImagesSliderSucceeded.value = false;
                                  _productsBloc.add(const GetImagesSlider());

                                  isGettingPrizesSucceeded.value = false;
                                  _productsBloc.add(GetProducts(prizeTypeId: prizeCategoryId));

                                  isGettingSoldOutProductsSucceeded.value = false;
                                  _productsBloc.add(const GetSoldOutProducts());

                                  isGettingWinnersSucceeded.value = false;
                                  _productsBloc.add(const GetWinners());
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ValueListenableBuilder(
                                          valueListenable: isGettingClosingSoonProductsSucceeded,
                                          builder: (context, val, child) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text(
                                                    S.of(context).closingSoon,
                                                    style: AppStyles.h2,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: isGettingClosingSoonProductsSucceeded.value
                                                          ? closingSoonProducts
                                                              .map((product) => ClosingSoonCard(
                                                                    product: product,
                                                                  ))
                                                              .toList()
                                                          : const [
                                                              ClosingSoonShimmer(),
                                                              ClosingSoonShimmer(),
                                                              ClosingSoonShimmer(),
                                                              ClosingSoonShimmer(),
                                                              ClosingSoonShimmer(),
                                                            ],
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: ValueListenableBuilder(
                                                    valueListenable: isGettingImagesSliderSucceeded,
                                                    builder: (context, val, child) {
                                                      if (isGettingImagesSliderSucceeded.value) {
                                                        if (imagesSlider.isNotEmpty) {
                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            child: SizedBox(
                                                              width: double.infinity - 100,
                                                              height: 65,
                                                              child: CarouselSlider(
                                                                options: CarouselOptions(
                                                                  height: 65.0,
                                                                ),
                                                                items: (imagesSlider.length == 1
                                                                        ? [imagesSlider.first]
                                                                        : imagesSlider.getRange(
                                                                            0,
                                                                            (imagesSlider.length * 0.5).round(),
                                                                          ))
                                                                    .map((image) {
                                                                  return Builder(
                                                                    builder: (context) {
                                                                      return ImageSliderCard(image: image);
                                                                    },
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        return Container();
                                                      } else {
                                                        return const ImageSliderShimmer();
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text(
                                                    S.of(context).whatDoYouWantToWinToday,
                                                    style: AppStyles.h2,
                                                  ),
                                                ),
                                                PrizesTypeChipsChoices(
                                                  categories: locator<MainApp>()
                                                      .appSettings!
                                                      .data
                                                      .productCategories
                                                      .map(
                                                        (prizeType) => prizeType,
                                                      )
                                                      .toList(),
                                                  onChanged: (value) {
                                                    prizeCategoryId = value;
                                                    isGettingPrizesSucceeded.value = false;
                                                    _productsBloc.add(GetProducts(prizeTypeId: prizeCategoryId));
                                                  },
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 8.0,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.vertical,
                                                    child: ValueListenableBuilder<bool>(
                                                      valueListenable: isGettingPrizesSucceeded,
                                                      builder: (context, val, child) {
                                                        return Column(
                                                          children: (isGettingPrizesSucceeded.value)
                                                              ? prizes
                                                                  .map(
                                                                    (product) => PrizesCard(
                                                                        product: product,
                                                                        showPrizeDetails:
                                                                            locator<MainApp>().appSettings != null
                                                                                ? locator<MainApp>()
                                                                                    .appSettings!
                                                                                    .data
                                                                                    .setting
                                                                                    .showPrizeDetails
                                                                                : false),
                                                                  )
                                                                  .toList()
                                                              : const [
                                                                  PrizesShimmer(),
                                                                  PrizesShimmer(),
                                                                  PrizesShimmer(),
                                                                  PrizesShimmer(),
                                                                  PrizesShimmer(),
                                                                ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          S.of(context).soldOut,
                                          style: AppStyles.h2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ValueListenableBuilder(
                                              valueListenable: isGettingSoldOutProductsSucceeded,
                                              builder: (context, val, child) {
                                                return Row(
                                                  children: isGettingSoldOutProductsSucceeded.value &&
                                                          soldOutProducts.isNotEmpty
                                                      ? soldOutProducts
                                                          .map(
                                                            (product) => SoldOutCard(
                                                              product: product,
                                                            ),
                                                          )
                                                          .toList()
                                                      : const [
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                        ],
                                                );
                                              }),
                                        ),
                                      ),
                                      Center(
                                        child: ValueListenableBuilder(
                                          valueListenable: isGettingImagesSliderSucceeded,
                                          builder: (context, val, child) {
                                            if (imagesSlider.length <= 1) return Container();
                                            if (isGettingImagesSliderSucceeded.value) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: SizedBox(
                                                  width: double.infinity - 100,
                                                  height: 65,
                                                  child: CarouselSlider(
                                                    options: CarouselOptions(
                                                      height: 65.0,
                                                      autoPlay: true,
                                                    ),
                                                    items: imagesSlider
                                                        .getRange(
                                                      0,
                                                      (imagesSlider.length - 1 / 2).floor(),
                                                    )
                                                        .map((image) {
                                                      return Builder(
                                                        builder: (context) {
                                                          return ImageSliderCard(image: image);
                                                        },
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const ImageSliderShimmer();
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          S.of(context).winners,
                                          style: AppStyles.h2,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ValueListenableBuilder(
                                              valueListenable: isGettingWinnersSucceeded,
                                              builder: (context, val, child) {
                                                return Row(
                                                  children: isGettingWinnersSucceeded.value && winners.isNotEmpty
                                                      ? winners
                                                          .map(
                                                            (winner) => WinnersCard(
                                                              winner: winner,
                                                            ),
                                                          )
                                                          .toList()
                                                      : const [
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                          SoldOutShimmer(),
                                                        ],
                                                );
                                              }),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
