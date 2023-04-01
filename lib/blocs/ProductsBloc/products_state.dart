import 'package:safaqtek/models/Products/products_data.dart';
import 'package:safaqtek/models/SliderImages/images_slider.dart';
import 'package:safaqtek/models/Winners/winners_data.dart';
import 'package:safaqtek/models/base_error_response.dart';

abstract class ProductsState {
  factory ProductsState.empty() = GetProductsEmpty;

  factory ProductsState.getProductsSucceeded(ProductsData productsData) = GetProductsSucceeded;

  factory ProductsState.getProductsFailed(BaseErrorResponse error) = GetProductsFailed;

  factory ProductsState.getImagesSliderSucceeded(ImagesSlider sliderImages) = GetImagesSliderSucceeded;

  factory ProductsState.getImagesSliderFailed(BaseErrorResponse error) = GetImagesSliderFailed;

  factory ProductsState.addProductToFavoriteSucceeded() = AddProductToFavoriteSucceeded;

  factory ProductsState.addProductToFavoriteFailed(BaseErrorResponse error) = AddProductToFavoriteFailed;

  factory ProductsState.removeProductFromFavoriteSucceeded() = RemoveProductFromFavoriteSucceeded;

  factory ProductsState.removeProductFromFavoriteFailed(BaseErrorResponse error) = RemoveProductFromFavoriteFailed;

  factory ProductsState.getSoldOutProductsSucceeded(ProductsData productsData) = GetSoldOutProductsSucceeded;

  factory ProductsState.getSoldOutProductsFailed(BaseErrorResponse error) = GetSoldOutProductsFailed;

  factory ProductsState.getWinnersSucceeded(WinnersData winnersData) = GetWinnersSucceeded;

  factory ProductsState.getWinnersFailed(BaseErrorResponse error) = GetWinnersFailed;

  factory ProductsState.getFavoriteProductsSucceeded(ProductsData wishlistProductsData) = GetFavoriteProductsSucceeded;

  factory ProductsState.getFavoriteProductsFailed(BaseErrorResponse error) = GetFavoriteProductsFailed;

}

class GetProductsEmpty implements ProductsState {
  const GetProductsEmpty();
}

class GetProductsSucceeded implements ProductsState {
  ProductsData productsData;

  GetProductsSucceeded(this.productsData);
}

class GetProductsFailed implements ProductsState {
  BaseErrorResponse error;

  GetProductsFailed(this.error);
}

class GetSoldOutProductsSucceeded implements ProductsState {
  ProductsData productsData;

  GetSoldOutProductsSucceeded(this.productsData);
}

class GetSoldOutProductsFailed implements ProductsState {
  BaseErrorResponse error;

  GetSoldOutProductsFailed(this.error);
}


class GetClosingSoonProductsSucceeded implements ProductsState {
  ProductsData productsData;

  GetClosingSoonProductsSucceeded(this.productsData);
}

class GetClosingSoonProductsFailed implements ProductsState {
  BaseErrorResponse error;

  GetClosingSoonProductsFailed(this.error);
}

class GetImagesSliderSucceeded implements ProductsState {
  ImagesSlider imagesSlider;

  GetImagesSliderSucceeded(this.imagesSlider);
}

class GetImagesSliderFailed implements ProductsState {
  BaseErrorResponse error;

  GetImagesSliderFailed(this.error);
}

class AddProductToFavoriteSucceeded implements ProductsState {
  AddProductToFavoriteSucceeded();
}

class AddProductToFavoriteFailed implements ProductsState {
  BaseErrorResponse error;

  AddProductToFavoriteFailed(this.error);
}

class RemoveProductFromFavoriteSucceeded implements ProductsState {
  RemoveProductFromFavoriteSucceeded();
}

class RemoveProductFromFavoriteFailed implements ProductsState {
  BaseErrorResponse error;

  RemoveProductFromFavoriteFailed(this.error);
}

class GetWinnersSucceeded implements ProductsState {
  WinnersData winnersData;

  GetWinnersSucceeded(this.winnersData);
}

class GetWinnersFailed implements ProductsState {
  BaseErrorResponse error;

  GetWinnersFailed(this.error);
}

class GetFavoriteProductsSucceeded implements ProductsState {
  ProductsData productsData;

  GetFavoriteProductsSucceeded(this.productsData);
}

class GetFavoriteProductsFailed implements ProductsState {
  BaseErrorResponse error;

  GetFavoriteProductsFailed(this.error);
}
