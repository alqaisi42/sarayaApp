
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';



import 'package:newsapp/config/api_baseurl.dart';
import 'package:newsapp/config/api_routes.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../Model/auth model/auth_response_model.dart';





import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../blocRepository/auth_repo.dart';





import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  AuthBloc() : super(AuthInitialState()) {
    on<LoginWIthGoogleEvent>(_onLoginWithGoogle);
    on<SendOtpToPhoneEvent>(_onSendOtpToPhone);
    on<LoginWithAppleEvent>(_onLoginWithAppleEvent);
    on<PhoneOtpSendEvent>(_onPhoneOtpSendEvent);
    on<VerifySentOtpEvent>(_verifySentOtpEvent);
    on<PhoneAuthVerificationCompletedEvent>(_onPhoneAuthVerificationCompletedEvent);
    on<CreateAccountEvent>(_onCreateAccountEvent);
    on<LoginWithEmailEvent>(_onLoginWithEmailEvent);
    on<LogOutRequestEvent>(_onLogOut);
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++  Create Account

  void _onCreateAccountEvent(CreateAccountEvent event, emit) async {
    emit(AuthLoadingState(loadingType: 'createAccount'));
    try {
      final Uri url = Uri.parse(createAccountUrl);
      final response = await ApiBaseHelper()
          .createAccount(url, event.name, event.email, event.password,event.fcmId.toString());



      // Check if response is null and handle it
      if (response == null) {
        emit(AuthErrorState(error: 'Server returned null response'));
        return;
      }

      final authResponse = AuthResponse.fromJson(response);

      if (authResponse.error == false) {
        final hiveStorage = HiveStorage();
        // Store the token
        await hiveStorage.storeToken(authResponse);

        emit(AuthSuccessState(authResponse));
      } else {
        emit(AuthErrorState(error: authResponse.message ?? ""));
      }
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Create Account Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }

  //++++++++++++++++++++++++++++++++++++++++++++ Login User

  void _onLoginWithEmailEvent(LoginWithEmailEvent event, emit) async {
    emit(AuthLoadingState(loadingType: 'email'));
    AuthResponse? authResponse;

    try {
      final Uri url = Uri.parse(loginWIthEmail);

      final loginUserResponse =
      await ApiBaseHelper().loginUser(url, event.email, event.password,event.fcmToken.toString());



      authResponse = AuthResponse.fromJson(loginUserResponse);
      authError = authResponse.message;

      if (authResponse.error == false) {
        final hiveStorage = HiveStorage();
        // Store the token
        await hiveStorage.storeToken(authResponse);
        emit(AuthSuccessState(authResponse));
      } else {
        emit(AuthErrorState(error: authResponse.message.toString()));
      }


    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Login With Email Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }

  // =============================================================== Login with Apple

  void _onLoginWithAppleEvent(LoginWithAppleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(loadingType: 'apple'));

    try {
      // Get Apple credential
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuthCredential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final userToken = await userCredential.user!.getIdToken(true);


      final apiHelper = ApiBaseHelper();
      final Uri url = Uri.parse(loginUrl);
      final response = await apiHelper.firebaseTokenSend(url, userToken.toString(), event.fcmId);

      final authResponse = AuthResponse.fromJson(response);

      if (authResponse.error == false) {
        final hiveStorage = HiveStorage();
        await hiveStorage.storeToken(authResponse);

        emit(AuthSuccessState(authResponse));
      } else {
        emit(AuthErrorState(error: authResponse.message.toString()));
      }
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Login With Apple Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }



// =============================================================== Login with google
  void _onLoginWithGoogle(
      LoginWIthGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(loadingType: 'google'));

    try {

      final token = await loginWithGoogle();

      if (token == null) {
        emit(AuthInitialState());
        return;
      }

      // Send the Google Firebase token to the backend
      final apiHelper = ApiBaseHelper();
      final Uri url = Uri.parse(loginUrl);
      final response = await apiHelper.firebaseTokenSend(url, token,event.fcmId);


      final authResponse = AuthResponse.fromJson(response);

      if (authResponse.error ==  false) {

        final hiveStorage = HiveStorage();
        await hiveStorage.storeToken(authResponse);

        emit(AuthSuccessState(authResponse));
      } else {
        emit(AuthErrorState(error: authResponse.message ?? ""));
      }
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Login With Google Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }



  //======================================================================= Login with number

  void _onSendOtpToPhone(event, emit) async {
    try {
      final data = await loginWithPhoneNumber(event.number);

      final credentials = data['credentials'] as PhoneAuthCredential?;
      final verificationId = data['verificationId'] as String?;
      final resendToken = data['resendToken'] as int?;

      try {
        if (credentials != null) {
          add(PhoneAuthVerificationCompletedEvent(credential: credentials, fcmId: ''));
          return;
        }

        if (verificationId != null) {
          add(PhoneOtpSendEvent(verificationId: verificationId, resendToken: resendToken));
          return;
        }
      } catch (e,stack) {
        FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Send Otp Error');
        emit(AuthErrorState(error: e.toString()));
      }
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Send Otp Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }

  void _onPhoneOtpSendEvent(PhoneOtpSendEvent event, Emitter<AuthState> emit) {
    emit(LoginPhoneCodeSentState(verificationId: event.verificationId));
  }

  void _verifySentOtpEvent(VerifySentOtpEvent event, Emitter<AuthState> emit) {
    emit(AuthLoadingState(loadingType: 'number'));
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.otpCode);
      add(PhoneAuthVerificationCompletedEvent(credential: credential, fcmId: event.fcmId));

    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Phone Otp Send Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }

  void _onPhoneAuthVerificationCompletedEvent(PhoneAuthVerificationCompletedEvent event, Emitter<AuthState> emit) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(event.credential);
      final userToken = await userCredential.user!.getIdToken(true);

      final apiHelper = ApiBaseHelper();
      final Uri url = Uri.parse(loginUrl);

      // Send the Firebase token
      final response = await apiHelper.firebaseTokenSend(url, userToken.toString(),event.fcmId);

      final authResponse = AuthResponse.fromJson(response);


      if (authResponse.error == false) {


        final hiveStorage = HiveStorage();
        await hiveStorage.storeToken(authResponse);

        emit(AuthSuccessState(authResponse));
      } else {
        emit(AuthErrorState(error: authResponse.message.toString()));
      }
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Phone Auth Verification Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }

  // ============================================================== Logout



  void _onLogOut(LogOutRequestEvent event, Emitter<AuthState> emit) async {
    emit(LogOutState());

    final hiveStorage = HiveStorage();
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await hiveStorage.clearToken();
      await hiveStorage.clearLastFreePlanUpdateTime();
      await hiveStorage.clearPlanFeatures();
      await hiveStorage.clearAdFreeStatus();

      emit(LogOutState(message: "Successfully logged out"));
      if (event.context.mounted) {
        GoRouter.of(event.context).go("/splashscreen");
      }
    } catch (e,stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Log Out Error');
      emit(AuthErrorState(error: e.toString()));
    }
  }
}
