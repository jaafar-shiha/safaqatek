import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/http_enum.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Coupons/coupons_data.dart';
import 'package:safaqtek/services/base_api.dart';
import 'package:safaqtek/utils/result_classes.dart';

class CouponsServices extends BaseAPI{

  Future<ResponseState<CouponsData>> getCoupons() async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/coupons',
      httpEnum: HttpEnum.get,
      headers: {
        'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      parseJson: (json) => CouponsData.fromMap(json),
    );
  }
}