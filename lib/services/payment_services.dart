import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/http_enum.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Payment/add_payment_data.dart';
import 'package:safaqtek/models/Payment/payment_data.dart';
import 'package:safaqtek/services/base_api.dart';
import 'package:safaqtek/utils/result_classes.dart';

class PaymentServices extends BaseAPI {

  Future<ResponseState<PaymentData>> purchaseProducts({required AddPaymentData paymentData}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/purchase',
      httpEnum: HttpEnum.post,
      headers: {
        'Authorization': 'Bearer ${locator<MainApp>().token}',
      },
      data: paymentData.toMap(),
      parseJson: (json) => PaymentData.fromMap(json),
    );
  }
}
