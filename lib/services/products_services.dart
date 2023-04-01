import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/http_enum.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Products/products_data.dart';
import 'package:safaqtek/models/SliderImages/images_slider.dart';
import 'package:safaqtek/models/Winners/winners_data.dart';
import 'package:safaqtek/models/base_success_response.dart';
import 'package:safaqtek/services/base_api.dart';
import 'package:safaqtek/utils/result_classes.dart';

class ProductsServices extends BaseAPI {

  Future<ResponseState<ProductsData>> getProducts({required int prizeTypeId}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/product',
      httpEnum: HttpEnum.get,
      headers: locator<MainApp>().token == null ? {} : {
        'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      queryParameters: {
        "category": prizeTypeId
      },
      parseJson: (json) => ProductsData.fromMap(json),
    );
  }

  Future<ResponseState<ImagesSlider>> getSliderImages() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/slider',
      httpEnum: HttpEnum.post,
      parseJson: (json) => ImagesSlider.fromMap(json),
    );
  }

  Future<ResponseState<BaseSuccessResponse>> addProductToFavorite({required int id}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/product/wishlist/add/$id',
      httpEnum: HttpEnum.get,
      headers: {
          'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      parseJson: (json) => BaseSuccessResponse.fromMap(json),
    );
  }

  Future<ResponseState<BaseSuccessResponse>> removeProductFromFavorite({required int id}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/product/wishlist/delete/$id',
      httpEnum: HttpEnum.get,
      headers: {
          'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      parseJson: (json) => BaseSuccessResponse.fromMap(json),
    );
  }


  Future<ResponseState<ProductsData>> getSoldOutProducts() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/product',
      httpEnum: HttpEnum.get,
      queryParameters: {
        "sold_out": true
      },
      parseJson: (json) => ProductsData.fromMap(json),
    );
  }

  Future<ResponseState<ProductsData>> getClosingSoonProducts() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/product',
      httpEnum: HttpEnum.get,
      queryParameters: {
        "closing_soon": true
      },
      parseJson: (json) => ProductsData.fromMap(json),
    );
  }

  Future<ResponseState<WinnersData>> getWinners() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/product/winners',
      httpEnum: HttpEnum.get,
      parseJson: (json) => WinnersData.fromMap(json),
    );
  }

  Future<ResponseState<ProductsData>> getProduct({required int id}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/product/current/$id',
      httpEnum: HttpEnum.get,
      parseJson: (json) => ProductsData.fromMap(json),
    );
  }

  Future<ResponseState<ProductsData>> getFavoriteProducts() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/wishlists',
      httpEnum: HttpEnum.get,
      headers: {
        'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      parseJson: (json) => ProductsData.fromMap(json),
    );
  }

}