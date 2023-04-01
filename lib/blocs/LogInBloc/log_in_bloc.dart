import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_event.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_state.dart';
import 'package:safaqtek/models/Authentication/change_account_password.dart';
import 'package:safaqtek/models/Authentication/registration_token.dart';
import 'package:safaqtek/models/Authentication/user_phone_number.dart';
import 'package:safaqtek/models/User/user_data.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/services/otp_verification_services.dart';
import 'package:safaqtek/utils/result_classes.dart';

class LogInBloc extends Bloc<LoginEvent, LoginState> {
  late final AuthenticationServices _authenticationServices = AuthenticationServices();
  final OTPVerificationServices _otpVerificationServices = OTPVerificationServices();

  LogInBloc() : super(const UnLoggedInState()) {
    on<LogIn>(
      (event, emit) async {
        await _authenticationServices.logInUser(logInModel: event.logInModel).then((value) {
          if (value is SuccessState<RegistrationToken>) {
            emit(LoginState.success(value.data));
          } else if (value is ErrorState<RegistrationToken>) {
            emit(LoginState.error(value.error));
          }
        });
      },
    );

    // on<LogInWithFirebase>(
    //       (event, emit) async {
    //     await _authenticationServices.logInUserWithFirebase(logInModel: event.logInModel).then((value) {
    //       if (value is SuccessState<User>) {
    //         emit(LogInState.logInWithFirebaseSucceeded(value.data));
    //       } else if (value is ErrorState<User>) {
    //         emit(LogInState.logInWithFirebaseFailed(value.error));
    //       }
    //     });
    //   },
    // );
    on<GetAccountPhoneNumber>(
      (event, emit) async {
        await _authenticationServices.getAccountPhoneNumber(email: event.email).then((value) {
          if (value is SuccessState<UserPhoneNumber>) {
            emit(LoginState.gettingUserPhoneNumberSucceeded(value.data.data!.phone!));
          } else if (value is ErrorState<UserPhoneNumber>) {
            emit(LoginState.gettingUserPhoneNumberFailed(value.error));
          }
        });
      },
    );

    on<SendOTPCode>(
      (event, emit) async {
        await _otpVerificationServices.sendOTPCode(event.phoneNumber).then((value) {
          if (value is SuccessState<String>) {
            emit(SendOTPSucceeded(value.data));
          } else if (value is ErrorState<String>) {
            emit(SendOTPFailed(value.error));
          }
        });
      },
    );

    on<VerifyNumber>(
      (event, emit) async {
        await _otpVerificationServices
            .verifyNumber(
          verificationId: event.verificationId,
          smsCode: event.smsCode,
        )
            .then((value) {
          if (value is SuccessState<bool>) {
            emit(const VerifyNumberSucceeded());
          } else if (value is ErrorState<bool>) {
            emit(VerifyNumberFailed(value.error));
          }
        });
      },
    );

    on<ChangeAccountPassword>(
      (event, emit) async {
        await _authenticationServices
            .changeAccountPassword(
          newPassword: event.newPassword,
          email: event.email
        )
            .then((value) {
          if (value is SuccessState<ChangeAccountPasswordModel>) {
            emit(const ChangingAccountPasswordSucceeded());
          } else if (value is ErrorState<ChangeAccountPasswordModel>) {
            emit(ChangingAccountPasswordFailed(value.error));
          }
        });
      },
    );

    on<LogInWithGooglePressed>(
      (event, emit) async {
        await _authenticationServices.logInWithGoogle().then((value) {
          if (value is SuccessState<GoogleSignInAccount>) {
            emit(LogInWithGoogleSucceeded(value.data));
          } else if (value is ErrorState<GoogleSignInAccount>) {
            emit(LogInWithGoogleFailed(value.error));
          }
        });
      },
    );

    on<CheckIfEmailRegister>(
      (event, emit) async {
        await _authenticationServices.getAccountPhoneNumber(email: event.googleSignInAccount.email).then((value) {
          if (value is SuccessState<UserPhoneNumber>) {
            emit(LoginState.userAlreadyRegistered(event.googleSignInAccount));
          } else if (value is ErrorState<UserPhoneNumber>) {
            emit(LoginState.userNotRegistered(event.googleSignInAccount));
          }
        });
      },
    );

    on<RegisterUserForFirstTime>(
      (event, emit) async {
        await _authenticationServices.registerNewUser(user: event.registerModel).then((value) {
          if (value is SuccessState<RegistrationToken>) {
            emit(LoginState.registerUserForFirstTimeSucceeded(value.data));
          } else if (value is ErrorState<RegistrationToken>) {
            emit(LoginState.registerUserForFirstTimeFailed(value.error));
          }
        });
      },
    );

    on<LogInWithApplePressed>(
      (event, emit) async {
        await _authenticationServices.logInWithGoogle().then((value) {
          if (value is SuccessState<GoogleSignInAccount>) {
            emit(LogInWithGoogleSucceeded(value.data));
          } else if (value is ErrorState<GoogleSignInAccount>) {
            emit(LogInWithGoogleFailed(value.error));
          }
        });
      },
    );

    on<GetUserProfile>(
          (event, emit) async {
        await _authenticationServices.getUserProfile(token: event.token).then((value) {
          if (value is SuccessState<UserData>) {
            emit(GetUserProfileSucceeded(value.data.user));
          } else if (value is ErrorState<UserData>) {
            emit(GetUserProfileFailed(value.error));
          }
        });
      },
    );
  }
}
