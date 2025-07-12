import 'dart:async';
import 'dart:developer';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String?> loginWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;

    if (user != null) {
      final String? firebaseToken = await user.getIdToken();
      // print('Firebase ID Token: $firebaseToken');
      return firebaseToken;
    }
  } catch (e,stack) {
    FirebaseCrashlytics.instance.recordError(e, stack, reason: 'GoogleSignInAccount');
    log('Error during Google sign in: $e');
  }

  return null;
}


Future<Map<String, dynamic>> loginWithPhoneNumber(String num) async {
  String? verificationId;
  int? resendToken;
  PhoneAuthCredential? credentials;

  Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: num,
      timeout:  Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential creds) async {
        if (!completer.isCompleted) {
          credentials = creds;
          await _auth.signInWithCredential(creds);
          completer.complete({
            'verificationId': verificationId,
            'resendToken': resendToken,
            'credentials': credentials,
          });
        }
      },
      verificationFailed: (FirebaseAuthException ex) {
        if (!completer.isCompleted) {
          completer.completeError('Verification Failed: ${ex.message}');
        }
      },
      codeSent: (String verifId, int? resendTok) {
        if (!completer.isCompleted) {
          verificationId = verifId;
          resendToken = resendTok;
          completer.complete({
            'verificationId': verificationId,
            'resendToken': resendToken,
            'credentials': credentials,
          });
        }
      },
      codeAutoRetrievalTimeout: (String verifId) {
        if (!completer.isCompleted) {
          verificationId = verifId;
          completer.complete({
            'verificationId': verificationId,
            'resendToken': resendToken,
            'credentials': credentials,
          });
        }
      },
    );

    final result = await completer.future;

    return result;
  } catch (e,stack) {
    FirebaseCrashlytics.instance.recordError(e, stack, reason: 'loginWithPhoneNumber');

    throw Exception('Failed to verify phone number: ${e.toString()}');
  }
}





