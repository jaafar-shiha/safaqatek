import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safaqtek/blocs/CouponsBloc/coupons_event.dart';
import 'package:safaqtek/blocs/CouponsBloc/coupons_state.dart';
import 'package:safaqtek/models/Coupons/coupons_data.dart';
import 'package:safaqtek/services/coupons_services.dart';
import 'package:safaqtek/utils/result_classes.dart';

class CouponsBloc extends Bloc<CouponsEvent, CouponsState> {

  final CouponsServices _couponsServices = CouponsServices();
  CouponsBloc() : super(const CouponsEmptyState()) {

    on<GetCoupons>(
      (event, emit) async {
        await _couponsServices.getCoupons().then((value) {
          if (value is SuccessState<CouponsData>) {
            emit(CouponsSuccessState(couponsData: value.data));
          } else if (value is ErrorState<CouponsData>) {
            emit(CouponsErrorState(value.error));
          }
        });
      },
    );


  }
}
