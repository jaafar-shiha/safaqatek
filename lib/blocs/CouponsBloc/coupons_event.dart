import 'package:equatable/equatable.dart';

abstract class CouponsEvent extends Equatable {
  const CouponsEvent();
}

class GetCoupons extends CouponsEvent {

  const GetCoupons();

  @override
  List<Object> get props => [];
}

