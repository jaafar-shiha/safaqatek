import 'package:dio/dio.dart';
import 'package:safaqtek/constants/http_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/base_error_response.dart';
import 'package:safaqtek/services/connectivity_services.dart';
import 'package:safaqtek/utils/result_classes.dart';

typedef ParseJson<T> = T Function(dynamic json);

class BaseAPI {
  Dio dio = Dio();

  static BaseOptions options = BaseOptions(
    baseUrl: 'https://safaqatek.com/',
    connectTimeout: 50000,
    receiveTimeout: 30000,
    followRedirects: false,
    validateStatus: (status) => status == 200 || status == 201,
    headers: {
      Headers.acceptHeader: Headers.jsonContentType,
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
  );

  Future<ResponseState<T>> apiMethod<T>({
    Map<String, dynamic>? headers,
    required String apiUrl,
    required HttpEnum httpEnum,
    Map<String, dynamic>? queryParameters,
    required ParseJson<T>? parseJson,
    Map? data,
  }) async {
    bool isConnectedToInternet = await ConnectivityServices.checkInternetConnection();
    if (!isConnectedToInternet) {
      return ResponseState<T>.error(BaseErrorResponse(error: S.current.noInternetConnection));
    }
    switch (httpEnum) {
      case HttpEnum.get:
        dio.options = options;
        return await dio.get(
          apiUrl,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        )
            .then((response) {
            return ResponseState<T>.success(parseJson!(response.data));
        }).catchError((error, stackTrace) {
          try {
            return ResponseState<T>.error(BaseErrorResponse.fromMap(error.response.data));
          } catch (e) {
            return ResponseState<T>.error(BaseErrorResponse(error: S.current.unknownError));
          }
        });
      case HttpEnum.post:
        dio.options = options;
        return await dio
            .post(
          apiUrl,
          options: Options(
            headers: headers,
          ),
          data: data,
        )
            .then((response) {
          return ResponseState<T>.success(parseJson!(response.data));
        }).catchError((error, stackTrace) {
          try {
            return ResponseState<T>.error(BaseErrorResponse.fromMap(error.response.data));
          } catch (e) {
            return ResponseState<T>.error(BaseErrorResponse(error: S.current.unknownError));
          }
        });
      case HttpEnum.put:
        return ResponseState.loading();
      case HttpEnum.delete:
        return ResponseState.loading();
      default:
        return ResponseState.loading();
    }
  }
}
