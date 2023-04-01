import 'package:safaqtek/models/Payment/payment_data.dart';
import 'package:safaqtek/models/base_error_response.dart';

abstract class PaymentState {
  const PaymentState();
}

class EmptyPaymentCart extends PaymentState {}

class PayingWithCardSucceeded extends PaymentState {
  final PaymentData paymentData;

  const PayingWithCardSucceeded({required this.paymentData});
}

class PayingWithCardFailed extends PaymentState {
  final BaseErrorResponse baseErrorResponse;

  const PayingWithCardFailed({required this.baseErrorResponse});
}
