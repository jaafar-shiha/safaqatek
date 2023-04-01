import 'package:flutter/material.dart';
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
import 'package:safaqtek/pages/LogIn/log_in_page.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/product_page.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/utils/dynamic_link_services.dart';
import 'package:safaqtek/utils/hourglass_image.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:share_plus/share_plus.dart';

class PrizesCard extends StatefulWidget {
  final Product product;
  final bool showPrizeDetails;

  const PrizesCard({
    Key? key,
    required this.product,
    required this.showPrizeDetails,
  }) : super(key: key);

  @override
  State<PrizesCard> createState() => _PrizesCardState();
}

class _PrizesCardState extends State<PrizesCard> with SingleTickerProviderStateMixin {
  late ValueNotifier<bool> isLovedValue = ValueNotifier(widget.product.isFavorite);

  double? _scale;

  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.1,
      upperBound: 1.0,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void onTap() {
    if (locator<MainApp>().token == null ||
        locator<MainApp>().currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
      );
      return;
    }
    isLovedValue.value = !isLovedValue.value;
    _controller!.forward(from: 1.0);
  }

  void _tapDown(TapDownDetails details) {
    if (locator<MainApp>().token == null ||
        locator<MainApp>().currentUser == null) {
      return;
    }
    _controller!.forward();
  }

  void _tapUp({
    required TapUpDetails details,
  }) {
    if (locator<MainApp>().token == null ||
        locator<MainApp>().currentUser == null) {
      return;
    }
    _controller!.reverse();
    isLovedValue.value = !isLovedValue.value;
    isLovedValue.value ? addFavoriteProduct() : removeFavoriteProduct();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  bool isLoveIconTappedOutOfArea = false;

  late final ProductsBloc _productsBloc = BlocProvider.of<ProductsBloc>(context);

  void addFavoriteProduct() {
    if (locator<MainApp>().token == null ||
        locator<MainApp>().currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
      );
      return;
    }
    _productsBloc.add(AddProductToFavorite(id: widget.product.id));
  }

  void removeFavoriteProduct() {
    if (locator<MainApp>().token == null ||
        locator<MainApp>().currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
      );
      return;
    }
    _productsBloc.add(RemoveProductFromFavorite(id: widget.product.id));
  }

  @override
  Widget build(BuildContext context) {
    CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context, listen: true);
    final double percent = HourglassImage.getSoldOutQuantityPercent(
      soldOutQuantity: widget.product.soldOut,
      totalQuantity: widget.product.quantity,
    );
    _scale = 0.9 + _controller!.value;
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is AddProductToFavoriteFailed) {
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        } else if (state is RemoveProductFromFavoriteFailed) {
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        }
      },
      listenWhen: (previous, current) {
        return previous != current;
      },
      child: GestureDetector(
        onTap: () {
          if (locator<MainApp>().token == null ||
              locator<MainApp>().currentUser == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
            );
            return;
          }
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductPage(product: widget.product),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 15.0,
            right: 8.0,
            left: 8.0,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 380, maxHeight: 380),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2.5,
                  color: Colors.grey[350]!,
                  blurRadius: 6,
                  offset: const Offset(1, 7), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              color: AppColors.lightGray,
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: AppColors.gray.withOpacity(0.5),
                          height: 1,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteLilac,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${S.of(context).outOf} ${widget.product.quantity}',
                                                style: AppStyles.h5.copyWith(color: AppColors.dirtyPurple),
                                              ),
                                              Image.asset(
                                                HourglassImage.getHourglass(percent: percent),
                                                height: 50,
                                              ),
                                              Text(
                                                '${S.of(context).sold} ${widget.product.soldOut}',
                                                style: AppStyles.h5.copyWith(color: AppColors.dirtyPurple),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                            child: IconButton(
                                              onPressed: () async {
                                                if (locator<MainApp>().token == null ||
                                                    locator<MainApp>().currentUser == null) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                  );
                                                  return;
                                                }
                                                await DynamicLinkServices.createDynamicLink(id: widget.product.id)
                                                    .then((url) {
                                                  Share.share(url);
                                                });
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                              icon: Icon(
                                                Icons.share_outlined,
                                                color: AppColors.gray,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          ValueListenableBuilder<bool>(
                                            valueListenable: isLovedValue,
                                            builder: (context, val, child) {
                                              return GestureDetector(
                                                onTapDown: _tapDown,
                                                onTapUp: (tapUpDetails) => _tapUp(
                                                  details: tapUpDetails,
                                                ),
                                                onVerticalDragUpdate: (dragUpdateDetails) {
                                                  if (locator<MainApp>().token == null ||
                                                      locator<MainApp>().currentUser == null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                    );
                                                    return;
                                                  }
                                                  if (!isLoveIconTappedOutOfArea &&
                                                      (dragUpdateDetails.localPosition.dy < -16 ||
                                                          dragUpdateDetails.localPosition.dy > 16)) {
                                                    _controller!.reverse();
                                                    isLovedValue.value = !isLovedValue.value;
                                                    isLovedValue.value ? addFavoriteProduct() : removeFavoriteProduct();
                                                    isLoveIconTappedOutOfArea = true;
                                                  }
                                                },
                                                onVerticalDragEnd: (dragEndDetails) {
                                                  if (locator<MainApp>().token == null ||
                                                      locator<MainApp>().currentUser == null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                    );
                                                    return;
                                                  }
                                                  isLoveIconTappedOutOfArea = false;
                                                },
                                                onHorizontalDragUpdate: (dragUpdateDetails) {
                                                  if (locator<MainApp>().token == null ||
                                                      locator<MainApp>().currentUser == null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                    );
                                                    return;
                                                  }
                                                  if (!isLoveIconTappedOutOfArea &&
                                                      (dragUpdateDetails.localPosition.dx < -16 ||
                                                          dragUpdateDetails.localPosition.dx > 16)) {
                                                    _controller!.reverse();
                                                    isLovedValue.value = !isLovedValue.value;
                                                    isLovedValue.value ? addFavoriteProduct() : removeFavoriteProduct();
                                                    isLoveIconTappedOutOfArea = true;
                                                  }
                                                },
                                                onHorizontalDragEnd: (dragEndDetails) {
                                                  if (locator<MainApp>().token == null ||
                                                      locator<MainApp>().currentUser == null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                    );
                                                    return;
                                                  }
                                                  isLoveIconTappedOutOfArea = false;
                                                },
                                                onTap: () async {
                                                  if (locator<MainApp>().token == null ||
                                                      locator<MainApp>().currentUser == null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                    );
                                                    return;
                                                  }
                                                  await _controller!.forward();
                                                  await _controller!.reverse();
                                                },
                                                child: Transform.scale(
                                                  scale: _scale!,
                                                  child: isLovedValue.value
                                                      ? Icon(
                                                          Icons.favorite_outlined,
                                                          color: AppColors.ferrariRed,
                                                          size: 30,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_outline_sharp,
                                                          color: AppColors.gray,
                                                          size: 30,
                                                        ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 1.1,
                                            child: Container(

                                              height: 160,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text.rich(
                                                  TextSpan(
                                                    text:
                                                        '${S.of(context).buy} ${widget.product.name} ${S.of(context).For}',
                                                    style: AppStyles.h3,
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text:
                                                            ' ${widget.product.price} ${widget.product.currency.toUpperCase()}',
                                                        style: AppStyles.h3.copyWith(
                                                          color: AppColors.frenchBlue,
                                                        ),
                                                        children: <InlineSpan>[
                                                          TextSpan(
                                                            text: '\n${S.of(context).winA}: ',
                                                            style: AppStyles.h3.copyWith(
                                                              color: AppColors.dirtyPurple,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: widget.product.awardName,
                                                                style: AppStyles.h3.copyWith(fontWeight: FontWeight.normal),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${S.of(context).maximumDrawDateIs} ${widget.product.closingAt} ${S.of(context).orWhenThePromotionIsSoldOut}',
                                                style: AppStyles.h4
                                                    .copyWith(color: Colors.black, fontSize: 8, letterSpacing: 1),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              widget.showPrizeDetails
                                                  ? Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            if (locator<MainApp>().token == null ||
                                                                locator<MainApp>().currentUser == null) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                              );
                                                              return;
                                                            }
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => ProductPage(product: widget.product),
                                                            ));
                                                          },
                                                          child: Text(
                                                            S.of(context).prizeDetails,
                                                            style: AppStyles.h2.copyWith(color: AppColors.dirtyPurple),
                                                          ),
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                              AppColors.whiteLilac,
                                                            ),
                                                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(25),
                                                                side: BorderSide(color: AppColors.dirtyPurple),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      if (locator<MainApp>().token == null ||
                                                          locator<MainApp>().currentUser == null) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => const LogInPage(isFromGuestPage: true,)),
                                                        );
                                                        return;
                                                      }
                                                      cartProductsProvider.addProductToCart(product: widget.product);
                                                      AppFlushBar.showFlushbar(
                                                              message: S.of(context).addedToCartSuccessfully)
                                                          .show(context);
                                                    },
                                                    child: Text(
                                                      S.of(context).addToCart,
                                                      style: AppStyles.h2.copyWith(color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(
                                                        AppColors.dirtyPurple,
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
                                              if (!widget.showPrizeDetails)
                                                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                                            ],
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
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Image.network(
                            widget.product.image,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Container(
                                height: 85,
                              );
                            },
                            errorBuilder: (context, child, errorBuilder) {
                              return Container(
                                height: 85,
                              );
                            },
                            height: 160,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
