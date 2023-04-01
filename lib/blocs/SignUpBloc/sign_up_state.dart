import 'package:safaqtek/models/Authentication/registration_token.dart';
import 'package:safaqtek/models/base_error_response.dart';
import 'package:safaqtek/models/User/user.dart';

abstract class SignUpState{

  factory SignUpState.unRegistered() = UnRegisteredState;

  factory SignUpState.success(RegistrationToken token,) = SignUpSucceeded;

  factory SignUpState.error(BaseErrorResponse error) = SigningUpFailed;

  factory SignUpState.loading() = SigningUpLoading;

  factory SignUpState.sendOTPSucceeded(String verificationId) = SendOTPSucceeded;

  factory SignUpState.sendOTPFailed(BaseErrorResponse error) = SendOTPFailed;

  factory SignUpState.verifyNumberSucceeded() = VerifyNumberSucceeded;

  factory SignUpState.verifyNumberFailed(BaseErrorResponse error) = VerifyNumberFailed;

  factory SignUpState.getUserProfileSucceeded(User user) = GetUserProfileSucceeded;

  factory SignUpState.getUserProfileFailed(BaseErrorResponse error) = GetUserProfileFailed;
}

class GetUserProfileSucceeded implements SignUpState {
  final User user;

  const GetUserProfileSucceeded(this.user);
}

class GetUserProfileFailed implements SignUpState {
  final BaseErrorResponse error;

  const GetUserProfileFailed(this.error);
}

class UnRegisteredState implements SignUpState {
  const UnRegisteredState();
}

class SigningUpLoading implements SignUpState {
  const SigningUpLoading();
}

class SignUpSucceeded implements SignUpState {
  final RegistrationToken token;

  const SignUpSucceeded(this.token,);
}


class SigningUpFailed implements SignUpState {
  final BaseErrorResponse error;

  const SigningUpFailed(this.error);
}


class SendOTPSucceeded implements SignUpState {

  final String verificationId;
  const SendOTPSucceeded(this.verificationId);
}

class SendOTPFailed implements SignUpState {

  final BaseErrorResponse error;
  const SendOTPFailed(this.error);
}

class VerifyNumberSucceeded implements SignUpState {

  const VerifyNumberSucceeded();
}

class VerifyNumberFailed implements SignUpState {


  final BaseErrorResponse error;
  const VerifyNumberFailed(this.error);
}

