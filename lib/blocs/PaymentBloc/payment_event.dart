import 'package:equatable/equatable.dart';
import 'package:safaqtek/models/Payment/add_payment_data.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class PayWithCart extends PaymentEvent {
  final AddPaymentData addPaymentData;

  const PayWithCart({required this.addPaymentData});
  @override
  List<Object?> get props => [];
}