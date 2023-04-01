import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_event.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_state.dart';
import 'package:safaqtek/models/Authentication/registration_token.dart';
import 'package:safaqtek/models/User/user_data.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/services/otp_verification_services.dart';
import 'package:safaqtek/utils/result_classes.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final OTPVerificationServices _otpVerificationServices = OTPVerificationServices();
  late final AuthenticationServices _authenticationServices = AuthenticationServices();

  SignUpBloc() : super(const UnRegisteredState()) {
    on<SignUp>(
      (event, emit) async {
        emit(const SigningUpLoading());
        await _authenticationServices.registerNewUser(user: event.registerModel).then((value) {
          if (value is SuccessState<RegistrationToken>) {
            emit(SignUpState.success(value.data,));
          } else if (value is ErrorState<RegistrationToken>) {
            emit(SignUpState.error(value.error));
          }
        });
      },
    );

    on<SendOTPCode>(
      (event, emit) async {
        emit(const SigningUpLoading());
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
        emit(const SigningUpLoading());
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
