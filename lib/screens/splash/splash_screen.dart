import 'dart:async';
import 'dart:developer';



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:go_router/go_router.dart';





import '../../Model/auth model/auth_response_model.dart';

import '../../bloc/deviceFCMBloc/device_fcm_bloc.dart';
import '../../bloc/deviceFCMBloc/device_fcm_event.dart';
import '../../bloc/fontSizeBloc/font_size_bloc.dart';
import '../../bloc/getSettingsBloc/get_settings_bloc.dart';
import '../../bloc/getSettingsBloc/get_settings_event.dart';
import '../../bloc/getSettingsBloc/get_settings_state.dart';
import '../../bloc/languageBloc/language_switcher_bloc.dart';
import '../../bloc/locationCoordinatesBloc/location_coordinates_bloc.dart';
import '../../bloc/locationCoordinatesBloc/location_coordinates_event.dart';

import '../../bloc/memberShipPlanBloc/membership_bloc.dart';
import '../../bloc/memberShipPlanBloc/membership_event.dart';


import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../notification_service.dart';







class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  late GetSettingsBloc settingsBloc;
  String? token;
  final hiveStorage = HiveStorage();

  @override
  void initState() {
    super.initState();
    log('SplashScreen initState called');
    getFcmNotification();
    checkAuthAndLanguage();



  }

  Future<void> getFcmNotification() async {
    try {
      final token = await _firebaseMessagingService.getToken();
      log('FCM Token: $token');

      if(mounted){
        context.read<DeviceFCMBloc>().add(PostDeviceFcm(deviceFcmId: token.toString()));
      }
    } catch (e) {
      log('Error getting FCM token: $e');
      if(mounted){
        CustomFloatingSnackBar.showCustomSnackBar(context, e.toString(), 0);
      }
    }
  }

  Future<void> checkAuthAndLanguage() async {
    log('[DEBUG] checkAuthAndLanguage called');

    try {
      log('[DEBUG] Dispatching location...');
      context.read<LocationBloc>().add(FetchLocationEvent(context: context));

      log('[DEBUG] Initializing language and font size...');
      await LanguageBloc.initLanguage();
      await FontSizeBloc.initFontSize();

      final AuthResponse? authResponse = await HiveStorage().getToken();
      log('[DEBUG] AuthResponse: $authResponse');

      if (authResponse != null && authResponse.data?.token != null) {
        token = authResponse.data?.token;
        log('[DEBUG] Token found: $token');

        if (mounted) {
          context.read<MembershipBloc>().add(FetchMembershipPlans());
        }
      } else {
        log('[DEBUG] Token not found');
      }

      if (mounted) {
        log('[DEBUG] Dispatching FetchGetSettings...');
        context.read<GetSettingsBloc>().add(FetchGetSettings());
      }
    } catch (e) {
      log('[ERROR] checkAuthAndLanguage: $e');
      if (mounted) {
        CustomFloatingSnackBar.showCustomSnackBar(context, e.toString(), 0);
      }
    }
  }

  Future<void> updateFreeTrial(String freeTrialPostLimit, String freeTrialStoryLimit) async {
    final lastUpdate = await hiveStorage.getLastFreePlanUpdateTime();


    final now = DateTime.now();

    if (lastUpdate != null) {
      final diff = now.difference(lastUpdate);
      if (diff.inHours < 24) {

        return;
      }
    }




    await hiveStorage.storeFreePlanFeatures({
      'articleLimit': freeTrialPostLimit,
      'storyLimit': freeTrialStoryLimit,
      'isTrialUsed': false,
    });


    await hiveStorage.setLastFreePlanUpdateTime(now);
  }






  Future<void> handleNavigation() async {
    final bool isFirst = await hiveStorage.isFirstLaunch();

    if (isFirst) {

      if(mounted){
        GoRouter.of(context).pushReplacement('/multiLangNews',extra: 'splashscreen');
      }

      await hiveStorage.setFirstLaunchDone();
    } else {

     if(mounted){
       GoRouter.of(context).pushReplacement('/home');
     }
    }
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetSettingsBloc, GetSettingsState>(
      listener: (context, state) {
        log('[DEBUG] BlocConsumer listener triggered: ${state.runtimeType}');

        if (state is GetSettingsSuccessState) {
          log('GetSettingsSuccessState received');

          // 👇 Always treat as unlimited plan
          updateFreeTrial("999999", "999999");

          try {
            final maintenanceModeSetting = state.getSettingsData[0].data?.firstWhere(
                  (setting) => setting.name == 'maintenance_mode',
            );

            final maintenanceMode = maintenanceModeSetting?.value;
            log('Maintenance mode: $maintenanceMode');

            if (mounted) {
              if (maintenanceMode == '1') {
                GoRouter.of(context).pushReplacement('/maintenanceModeScreen');
              } else {
                final isNewsLanguageActive = state.getSettingsData[0].data
                    ?.firstWhere((setting) => setting.name == 'news_language_status')
                    .value;

                if (isNewsLanguageActive == 'true') {
                  handleNavigation();
                } else {
                  GoRouter.of(context).pushReplacement('/home');
                }
              }
            }
          } catch (e) {
            log('Error processing settings: $e');
          }
        } else if (state is GetSettingsErrorState) {
          log('GetSettingsFailureState: ${state.errorMessage}');
          CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
        }
      },

      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo.png',
                  width: MediaQueryHelper.screenWidth(context) * 0.60,
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}








