import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safaqtek/models/Authentication/log_in.dart';
import 'package:safaqtek/models/Authentication/register_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LogIn extends LoginEvent {
  final LogInModel logInModel;

  const LogIn({
    required this.logInModel,
  });

  @override
  List<Object> get props => [
        logInModel,
      ];
}


class SendOTPCode extends LoginEvent {
  final String phoneNumber;

  const SendOTPCode({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [phoneNumber];
}

class GetAccountPhoneNumber extends LoginEvent {
  final String email;

  const GetAccountPhoneNumber({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class VerifyNumber extends LoginEvent {
  final String verificationId;
  final String smsCode;

  const VerifyNumber({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object> get props => [smsCode];
}

class ChangeAccountPassword extends LoginEvent {
  final String newPassword;
  final String email;

  const ChangeAccountPassword({
    required this.newPassword,
    required this.email,
  });

  @override
  List<Object> get props => [newPassword];
}

class LogInWithGooglePressed extends LoginEvent {
  const LogInWithGooglePressed();

  @override
  List<Object> get props => [];
}

//We will call this event to check if a google account already registered in our database or not.
class CheckIfEmailRegister extends LoginEvent {
  final GoogleSignInAccount googleSignInAccount;
  const CheckIfEmailRegister(this.googleSignInAccount);

  @override
  List<Object> get props => [];
}

// After checking if a google account is registered or not:
// IN CASE NOT REGISTERED: we will register it, OTHERWISE:  we will log the user in.
class RegisterUserForFirstTime extends LoginEvent {
  final RegisterModel registerModel;
  const RegisterUserForFirstTime(this.registerModel);

  @override
  List<Object> get props => [];
}

class LogInWithApplePressed extends LoginEvent {
  const LogInWithApplePressed();

  @override
  List<Object> get props => [];
}

class GetUserProfile extends LoginEvent {
  final String token;

  const GetUserProfile({
    required this.token
  });

  @override
  List<Object> get props => [];
}
