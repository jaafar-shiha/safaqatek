import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_bloc.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_event.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/constants/product_page_tabs_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/prize_detailes_tab.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/product_details_tab.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/utils/dynamic_link_services.dart';
import 'package:safaqtek/utils/hourglass_image.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:share_plus/share_plus.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin {
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
    isLovedValue.value = !isLovedValue.value;
    _controller!.forward(from: 1.0);
  }

  void _tapDown(TapDownDetails details) {
    _controller!.forward();
  }

  void _tapUp({required TapUpDetails details}) {
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

  ValueNotifier<ProductPageTabs> selectedTab = ValueNotifier(ProductPageTabs.prizeDetails);

  late TabsProvider tabsProvider = Provider.of<TabsProvider>(context, listen: false);

  late final ProductsBloc _productsBloc = BlocProvider.of<ProductsBloc>(context);

  void addFavoriteProduct() {
    _productsBloc.add(AddProductToFavorite(id: widget.product.id));
  }

  void removeFavoriteProduct() {
    _productsBloc.add(RemoveProductFromFavorite(id: widget.product.id));
  }

  bool isProductInCart() {
    CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context, listen: true);
    try{
      cartProductsProvider.cartProducts.singleWhere((element) => element.id == widget.product.id);
      return true;
    }
    catch (e){
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final double percent = HourglassImage.getSoldOutQuantityPercent(
      soldOutQuantity: widget.product.soldOut,
      totalQuantity: widget.product.quantity,
    );
    CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context, listen: true);
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
      child: MainScaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
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
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteLilac,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
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
                                    Align(
                                      alignment: Alignment.center,
                                      child: Transform.scale(
                                        scale: 1.7,
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
                                          height: 130,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ValueListenableBuilder<bool>(
                                          valueListenable: isLovedValue,
                                          builder: (context, val, child) {
                                            return GestureDetector(
                                              onTapDown: _tapDown,
                                              onTapUp: (tapUpDetails) => _tapUp(
                                                details: tapUpDetails,
                                              ),
                                              onVerticalDragUpdate: (dragUpdateDetails) {
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
                                                isLoveIconTappedOutOfArea = false;
                                              },
                                              onHorizontalDragUpdate: (dragUpdateDetails) {
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
                                                isLoveIconTappedOutOfArea = false;
                                              },
                                              onTap: () async {
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: IconButton(
                                            onPressed: () async{
                                              await DynamicLinkServices.createDynamicLink(id: widget.product.id).then((url) {
                                                Share.share(url);
                                              });
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                            icon: Icon(
                                              Icons.share_outlined,
                                              color: AppColors.gray,
                                              size: 31,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: selectedTab,
                                      builder: (context, val, child) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width / 1.9,
                                                        child: TextButton(
                                                          onPressed: () {

                                                            selectedTab.value = ProductPageTabs.prizeDetails;
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: Text(
                                                              S.of(context).prizeDetails,
                                                              style: AppStyles.h3.copyWith(color: AppColors.whiteLilac),
                                                            ),
                                                          ),
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                              selectedTab.value == ProductPageTabs.prizeDetails
                                                                  ? AppColors.dirtyPurple
                                                                  : AppColors.gray,
                                                            ),
                                                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(25),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width / 2.1,
                                                        child: TextButton(
                                                          onPressed: () {
                                                            selectedTab.value = ProductPageTabs.productDetails;
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: Text(
                                                              S.of(context).productDetails,
                                                              style: AppStyles.h3.copyWith(color: AppColors.whiteLilac),
                                                            ),
                                                          ),
                                                          style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                              selectedTab.value == ProductPageTabs.productDetails
                                                                  ? AppColors.dirtyPurple
                                                                  : AppColors.gray,
                                                            ),
                                                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(25),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            selectedTab.value == ProductPageTabs.prizeDetails
                                                ? PrizeDetailsTab(
                                                    product: widget.product,
                                                  )
                                                : ProductDetailsTab(
                                                    product: widget.product,
                                                  )
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  S.of(context).goShopping,
                                                  style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                    AppColors.frenchBlue,
                                                  ),
                                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25),
                                                      side: BorderSide(
                                                        color: AppColors.frenchBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextButton(
                                                onPressed: () {
                                                  tabsProvider.setCurrentTab(currentTab: Tabs.cart);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  S.of(context).viewCart,
                                                  style: AppStyles.h2.copyWith(color: AppColors.frenchBlue),
                                                ),
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                    AppColors.whiteLilac,
                                                  ),
                                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25),
                                                      side: BorderSide(color: AppColors.frenchBlue, width: 1.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${S.of(context).buy} ${widget.product.name}'.toUpperCase(),
                                                    style: AppStyles.h3),
                                                Text(
                                                  '${widget.product.price} ${widget.product.currency}'.toUpperCase(),
                                                  style: AppStyles.h3.copyWith(fontWeight: FontWeight.bold),
                                                ),

                                              ],
                                            ),
                                          ),
                                          isProductInCart()
                                              ? Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: AppColors.gray,
                                                      child: IconButton(
                                                        onPressed: () {

                                                          cartProductsProvider.removeProductFromCart(
                                                              product: widget.product);
                                                        },
                                                        icon: const Icon(Icons.remove),
                                                        color: AppColors.whiteLilac,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      child: Text(
                                                        '${cartProductsProvider.cartProducts.singleWhere((element) => element.id == widget.product.id).countOfThisProductInCart}',
                                                        style: AppStyles.h2,
                                                      ),
                                                    ),
                                                    CircleAvatar(
                                                      backgroundColor: AppColors.frenchBlue,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          cartProductsProvider.addProductToCart(product: widget.product);
                                                        },
                                                        icon: const Icon(Icons.add),
                                                        color: AppColors.whiteLilac,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : TextButton(
                                                  onPressed: () {
                                                    cartProductsProvider.addProductToCart(product: widget.product);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text(
                                                      S.of(context).addToCart,
                                                      style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                      AppColors.frenchBlue,
                                                    ),
                                                    shape: MaterialStateProperty.all<OutlinedBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(9),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
