import 'package:equatable/equatable.dart';
import 'package:safaqtek/models/Authentication/register_model.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUp extends SignUpEvent {
  final RegisterModel registerModel;
  const SignUp({
    required this.registerModel,
  });

  @override
  List<Object> get props => [registerModel];
}

class SendOTPCode extends SignUpEvent {
  final String phoneNumber;

  const SendOTPCode({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}


class VerifyNumber extends SignUpEvent {
  final String verificationId;
  final String smsCode;

  const VerifyNumber({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}


class GetUserProfile extends SignUpEvent {
  final String token;

  const GetUserProfile({
    required this.token
  });

  @override
  List<Object> get props => [];
}
