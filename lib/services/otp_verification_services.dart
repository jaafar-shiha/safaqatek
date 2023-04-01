import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safaqtek/models/base_error_response.dart';
import 'package:safaqtek/utils/result_classes.dart';

class OTPVerificationServices {
  Future<ResponseState<String>> sendOTPCode(String mobile) async {

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      ResponseState<String> response = ResponseState.loading();
      final completer = Completer<ResponseState<String>>();
      _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        verificationCompleted: (_) {},
        verificationFailed: (firebaseAuthException) {
          response = ResponseState.error(BaseErrorResponse(error: firebaseAuthException.message!));
          completer.complete(response);
        },
        codeSent: (verificationId, forceResendingToken) {
          response = ResponseState.success(verificationId);
          completer.complete(response);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      return completer.future;
    } catch (e) {
      //TODO : DELETE this, cause its for web
      ResponseState<String> response = ResponseState.loading();
      try {
        await FirebaseAuth.instance
            .signInWithPhoneNumber(
          mobile,
        )
            .then((confirmationResult) {
          response = ResponseState.success(confirmationResult.verificationId);
        });
        return response;
      } on FirebaseException catch (firebaseException) {
        response = ResponseState.error(BaseErrorResponse(error: firebaseException.message!));
        return response;
      }
    }
  }

  Future<ResponseState<bool>> verifyNumber({required String verificationId, required String smsCode}) async {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    PhoneAuthCredential _credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      await _auth.signInWithCredential(_credential);
      return ResponseState.success(true);
    } on FirebaseException catch (firebaseException) {
      return ResponseState.error(
        BaseErrorResponse(error: firebaseException.message!),
      );
    }
  }

}
