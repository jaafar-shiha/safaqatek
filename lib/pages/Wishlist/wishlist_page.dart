import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_bloc.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_event.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/pages/Wishlist/empty_wishlist_widget.dart';
import 'package:safaqtek/pages/Wishlist/favorite_products_list_widget.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/custom_container_clipper.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late final ProductsBloc _productsBloc = BlocProvider.of<ProductsBloc>(context);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueNotifier<List<Product>> products = ValueNotifier(List.empty(growable: true));

  @override
  void initState() {
    isLoading.value = true;
    _productsBloc.add(const GetFavoriteProducts());
    super.initState();
  }

  void removeFavoriteProduct({required int id}) {
    _productsBloc.add(RemoveProductFromFavorite(id: id));
  }

  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context,);
    return WillPopScope(
      onWillPop: (){
        tabsProvider.setCurrentTab(currentTab: Tabs.home);
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: MainScaffold(
        body: SafeArea(
          child: BlocListener<ProductsBloc, ProductsState>(
            listener: (context, state) {

              if (state is GetFavoriteProductsSucceeded) {isLoading.value = false;
                products.value = state.productsData.products;
              } else if (state is GetFavoriteProductsFailed) {isLoading.value = false;
                AppFlushBar.showFlushbar(message: state.error.error).show(context);
              } else if (state is AddProductToFavoriteFailed) {
                AppFlushBar.showFlushbar(message: state.error.error).show(context);
              } else if (state is RemoveProductFromFavoriteFailed) {
                AppFlushBar.showFlushbar(message: state.error.error).show(context);
              }
            },
            listenWhen: (previous, current) {
              return previous != current;
            },
            bloc: _productsBloc,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          tabsProvider.setCurrentTab(currentTab: Tabs.home);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.whiteLilac,
                        ),
                      ),
                      Text(
                        S.of(context).wishlist,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipPath(
                      clipper: CustomContainerClipper(
                        onlyFromTopEdges: false,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteLilac,
                        ),
                        child: ValueListenableBuilder(
                            valueListenable: products,
                            builder: (context, val, child) {
                              return ValueListenableBuilder(
                                  valueListenable: isLoading,
                                  builder: (context, val, child) {
                                    if (isLoading.value) {
                                      return SpinKitPulse(
                                        color: AppColors.dirtyPurple,
                                        duration: const Duration(seconds: 2),
                                      );
                                    }
                                    return products.value.isEmpty
                                        ? const EmptyWishlistWidget()
                                        : FavoriteProductsListWidget(
                                            products: products.value,
                                            onDelete: (wishlistProduct) {
                                              removeFavoriteProduct(id: wishlistProduct.id);
                                              products.value = products.value..remove(wishlistProduct);
                                              products.value = [...products.value];
                                            },
                                          );
                                  });
                            }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
