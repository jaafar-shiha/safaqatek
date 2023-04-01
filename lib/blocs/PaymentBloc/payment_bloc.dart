import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safaqtek/blocs/PaymentBloc/payment_event.dart';
import 'package:safaqtek/blocs/PaymentBloc/payment_state.dart';
import 'package:safaqtek/models/Payment/payment_data.dart';
import 'package:safaqtek/services/payment_services.dart';
import 'package:safaqtek/utils/result_classes.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentServices _paymentServices = PaymentServices();

  PaymentBloc() : super(EmptyPaymentCart()) {
    on<PayWithCart>(
      (event, emit) async {
        await _paymentServices.purchaseProducts(paymentData: event.addPaymentData).then((value) {
          if (value is SuccessState<PaymentData>) {
            emit(PayingWithCardSucceeded(paymentData: value.data));
          } else if (value is ErrorState<PaymentData>) {
            emit(PayingWithCardFailed(baseErrorResponse: value.error));
          }
        });
      },
    );
  }
}
