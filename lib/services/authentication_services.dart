import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/http_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Authentication/phone_number_success_response.dart';
import 'package:safaqtek/models/Authentication/register_model.dart';
import 'package:safaqtek/models/Authentication/registration_token.dart';
import 'package:safaqtek/models/Authentication/user_phone_number.dart';
import 'package:safaqtek/models/base_error_response.dart';
import 'package:safaqtek/models/Authentication/change_account_password.dart';
import 'package:safaqtek/models/Authentication/log_in.dart';
import 'package:safaqtek/models/User/user_data.dart';
import 'package:safaqtek/services/base_api.dart';
import 'package:safaqtek/services/connectivity_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServices extends BaseAPI {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'profile',
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  AuthenticationServices();

  Future<ResponseState<RegistrationToken>> registerNewUser({required RegisterModel user}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/register',
      httpEnum: HttpEnum.post,
      data: user.toMap(),
      parseJson: (json) => RegistrationToken.fromMap(json),
    );
  }



  Future<ResponseState<RegistrationToken>> logInUser({required LogInModel logInModel}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/login',
      httpEnum: HttpEnum.post,
      data: logInModel.toMap(),
      parseJson: (json) => RegistrationToken.fromMap(json),
    );
  }

  Future<ResponseState<UserData>> getUserProfile({required String token}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/profile',
      headers: {'Authorization': 'Bearer $token'},
      httpEnum: HttpEnum.get,
      parseJson: (json) => UserData.fromMap(json),
    );
  }

  Future<ResponseState<UserPhoneNumber>> getAccountPhoneNumber({required String email}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/phone?email=$email',
      httpEnum: HttpEnum.post,
      parseJson: (json) => UserPhoneNumber.fromMap(json),
    );
  }

  Future<ResponseState<PhoneNumberSuccessResponse>> checkIfPhoneTaken({required String phoneNumber}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/phone/check',
      httpEnum: HttpEnum.post,
      data: {
        "phone": phoneNumber
      },
      parseJson: (json) => PhoneNumberSuccessResponse.fromMap(json),
    );
  }


  Future<ResponseState<ChangeAccountPasswordModel>> changeAccountPassword(
      {required String email, required String newPassword}) async {
    return await apiMethod(
      apiUrl: 'api/v1/${locator<MainApp>().language!.languageCode}/user/new/password?password=$newPassword',
      httpEnum: HttpEnum.post,
      data: {"email": email},
      parseJson: (json) => ChangeAccountPasswordModel.fromMap(json),
    );
  }

  Future<ResponseState<GoogleSignInAccount>> logInWithGoogle() async {
    bool isConnectedToInternet = await ConnectivityServices.checkInternetConnection();
    if (!isConnectedToInternet) {
      return ResponseState.error(BaseErrorResponse(error: S.current.noInternetConnection));
    }
    GoogleSignInAccount? googleSignInAccount;
    try {
      googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        return ResponseState.success(googleSignInAccount);
      } else {
        return ResponseState.loading();
      }
    } catch (error) {
      return ResponseState.error(BaseErrorResponse(error: error.toString()));
    }
  }

// Future logInWithAppleAccount() async {
//   final credential = await SignInWithApple.getAppleIDCredential(
//     scopes: [
//       AppleIDAuthorizationScopes.email,
//       AppleIDAuthorizationScopes.fullName,
//     ],
//     webAuthenticationOptions: WebAuthenticationOptions(
//       // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
//       clientId: 'de.lunaone.flutter.signinwithappleexample.service',
//       redirectUri: Uri.parse(
//         'https://safaqatek.firebaseapp.com/__/auth/handler',
//       ),
//     ),
//
//   );
// }
}
