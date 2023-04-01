import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_event.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_state.dart';
import 'package:safaqtek/models/Products/products_data.dart';
import 'package:safaqtek/models/SliderImages/images_slider.dart';
import 'package:safaqtek/models/Winners/winners_data.dart';
import 'package:safaqtek/models/base_success_response.dart';
import 'package:safaqtek/services/products_services.dart';
import 'package:safaqtek/utils/result_classes.dart';


class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  late final ProductsServices _productsServices = ProductsServices();

  ProductsBloc() : super(const GetProductsEmpty()) {

    on<GetClosingSoonProducts>(
          (event, emit) async {
        await _productsServices.getClosingSoonProducts().then((value) {
          if (value is SuccessState<ProductsData>) {
            emit(GetClosingSoonProductsSucceeded(value.data));
          } else if (value is ErrorState<ProductsData>) {
            emit(GetClosingSoonProductsFailed(value.error));
          }
        });
      },
    );

    on<GetImagesSlider>(
          (event, emit) async {
        await _productsServices.getSliderImages().then((value) {
          if (value is SuccessState<ImagesSlider>) {
            emit(GetImagesSliderSucceeded(value.data));
          } else if (value is ErrorState<ImagesSlider>) {
            emit(GetImagesSliderFailed(value.error));
          }
        });
      },
    );


    on<GetProducts>(
          (event, emit) async {
        await _productsServices.getProducts(prizeTypeId: event.prizeTypeId).then((value) {
          if (value is SuccessState<ProductsData>) {
            emit(GetProductsSucceeded(value.data));
          } else if (value is ErrorState<ProductsData>) {
            emit(GetProductsFailed(value.error));
          }
        });
      },
    );

    on<GetSoldOutProducts>(
          (event, emit) async {
        await _productsServices.getSoldOutProducts().then((value) {
          if (value is SuccessState<ProductsData>) {
            emit(GetSoldOutProductsSucceeded(value.data));
          } else if (value is ErrorState<ProductsData>) {
            emit(GetSoldOutProductsFailed(value.error));
          }
        });
      },
    );

    on<GetWinners>(
          (event, emit) async {
        await _productsServices.getWinners().then((value) {
          if (value is SuccessState<WinnersData>) {
            emit(GetWinnersSucceeded(value.data));
          } else if (value is ErrorState<WinnersData>) {
            emit(GetWinnersFailed(value.error));
          }
        });
      },
    );


    on<AddProductToFavorite>(
          (event, emit) async {
        await _productsServices.addProductToFavorite(id: event.id).then((value) {
          if (value is SuccessState<BaseSuccessResponse>) {
            emit(AddProductToFavoriteSucceeded());
          } else if (value is ErrorState<BaseSuccessResponse>) {
            emit(AddProductToFavoriteFailed(value.error));
          }
        });
      },
    );

    on<RemoveProductFromFavorite>(
          (event, emit) async {
        await _productsServices.removeProductFromFavorite(id: event.id).then((value) {
          if (value is SuccessState<BaseSuccessResponse>) {
            emit(RemoveProductFromFavoriteSucceeded());
          } else if (value is ErrorState<BaseSuccessResponse>) {
            emit(RemoveProductFromFavoriteFailed(value.error));
          }
        });
      },
    );


    on<GetFavoriteProducts>(
          (event, emit) async {
        await _productsServices.getFavoriteProducts().then((value) {
          if (value is SuccessState<ProductsData>) {
            emit(GetFavoriteProductsSucceeded(value.data));
          } else if (value is ErrorState<ProductsData>) {
            emit(GetFavoriteProductsFailed(value.error));
          }
        });
      },
    );

  }
}
