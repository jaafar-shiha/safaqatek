import 'package:safaqtek/models/Coupons/coupons_data.dart';
import 'package:safaqtek/models/base_error_response.dart';

abstract class CouponsState {
  const CouponsState();
}

class CouponsEmptyState extends CouponsState {
  const CouponsEmptyState();
}

class CouponsSuccessState extends CouponsState {
  final CouponsData couponsData;
  const CouponsSuccessState({required this.couponsData});
}

class CouponsErrorState extends CouponsState {
  final BaseErrorResponse error;

  const CouponsErrorState(this.error);
}
