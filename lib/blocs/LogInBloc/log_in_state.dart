import 'package:google_sign_in/google_sign_in.dart';
import 'package:safaqtek/models/Authentication/registration_token.dart';
import 'package:safaqtek/models/base_error_response.dart';
import 'package:safaqtek/models/User/user.dart';

abstract class LoginState {
  const LoginState();

  factory LoginState.unLogged() = UnLoggedInState;

  factory LoginState.success(RegistrationToken registrationToken) = LogInSucceeded;

  factory LoginState.error(BaseErrorResponse error) = LogInFailed;

  factory LoginState.sendOTPSucceeded(String verificationId) = SendOTPSucceeded;

  factory LoginState.sendOTPFailed(BaseErrorResponse error) = SendOTPFailed;

  factory LoginState.verifyNumberSucceeded() = VerifyNumberSucceeded;

  factory LoginState.verifyNumberFailed(BaseErrorResponse error) = VerifyNumberFailed;

  factory LoginState.gettingUserPhoneNumberSucceeded(String phoneNumber) = GettingUserPhoneNumberSucceeded;

  factory LoginState.gettingUserPhoneNumberFailed(BaseErrorResponse error) = GettingUserPhoneNumberFailed;

  factory LoginState.userAlreadyRegistered(GoogleSignInAccount googleSignInAccount) = UserAlreadyRegistered;

  factory LoginState.userNotRegistered(GoogleSignInAccount googleSignInAccount) = UserNotRegistered;

  factory LoginState.registerUserForFirstTimeSucceeded( RegistrationToken registrationToken) = RegisterUserForFirstTimeSucceeded;

  factory LoginState.registerUserForFirstTimeFailed(BaseErrorResponse error) = RegisterUserForFirstTimeFailed;

  factory LoginState.logInWithAppleSucceeded(BaseErrorResponse error) = LogInWithAppleSucceeded;

  factory LoginState.logInWithAppleFailed(BaseErrorResponse error) = LogInWithAppleFailed;

  factory LoginState.getUserProfileSucceeded(User user) = GetUserProfileSucceeded;

  factory LoginState.getUserProfileFailed(BaseErrorResponse error) = GetUserProfileFailed;
}

class GetUserProfileSucceeded implements LoginState {
  final User user;

  const GetUserProfileSucceeded(this.user);
}

class GetUserProfileFailed implements LoginState {
  final BaseErrorResponse error;

  const GetUserProfileFailed(this.error);
}

class UnLoggedInState implements LoginState {
  const UnLoggedInState();
}

class LogInSucceeded implements LoginState {
  final RegistrationToken registrationToken;

  const LogInSucceeded(this.registrationToken);
}

class LogInFailed implements LoginState {
  final BaseErrorResponse error;

  const LogInFailed(this.error);
}

class SendOTPSucceeded implements LoginState {
  final String verificationId;

  const SendOTPSucceeded(this.verificationId);
}

class SendOTPFailed implements LoginState {
  final BaseErrorResponse error;

  const SendOTPFailed(this.error);
}

class VerifyNumberSucceeded implements LoginState {
  const VerifyNumberSucceeded();
}

class VerifyNumberFailed implements LoginState {
  final BaseErrorResponse error;

  const VerifyNumberFailed(this.error);
}

class GettingUserPhoneNumberSucceeded implements LoginState {
  final String phoneNumber;

  const GettingUserPhoneNumberSucceeded(this.phoneNumber);
}

class GettingUserPhoneNumberFailed implements LoginState {
  final BaseErrorResponse error;

  const GettingUserPhoneNumberFailed(this.error);
}

class ChangingAccountPasswordSucceeded implements LoginState {
  const ChangingAccountPasswordSucceeded();
}

class ChangingAccountPasswordFailed implements LoginState {
  final BaseErrorResponse error;

  const ChangingAccountPasswordFailed(this.error);
}

class LogInWithGoogleSucceeded implements LoginState {
  final GoogleSignInAccount? googleSignInAccount;

  const LogInWithGoogleSucceeded(this.googleSignInAccount);
}

class LogInWithGoogleFailed implements LoginState {
  final BaseErrorResponse error;

  const LogInWithGoogleFailed(this.error);
}

class UserAlreadyRegistered implements LoginState {
  final GoogleSignInAccount googleSignInAccount;

  const UserAlreadyRegistered(this.googleSignInAccount);
}

class UserNotRegistered implements LoginState {
  final GoogleSignInAccount googleSignInAccount;

  const UserNotRegistered(this.googleSignInAccount);
}

class RegisterUserForFirstTimeSucceeded implements LoginState {
  final RegistrationToken registrationToken;
  const RegisterUserForFirstTimeSucceeded(this.registrationToken);
}

class RegisterUserForFirstTimeFailed implements LoginState {
  final BaseErrorResponse error;

  const RegisterUserForFirstTimeFailed(this.error);
}

class LogInWithAppleSucceeded implements LoginState {
  final BaseErrorResponse error;

  const LogInWithAppleSucceeded(this.error);
}

class LogInWithAppleFailed implements LoginState {
  final BaseErrorResponse error;

  const LogInWithAppleFailed(this.error);
}
