// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';





import 'package:newsapp/utils/widgets/profile_btn.dart';
import 'package:remixicon/remixicon.dart';

import '../../Model/auth model/auth_response_model.dart';
import '../../bloc/authBloc/auth_bloc.dart';
import '../../bloc/authBloc/auth_event.dart';
import '../../bloc/authBloc/auth_state.dart';

import '../../bloc/deleteUserBloc/delete_user_bloc.dart';
import '../../bloc/deleteUserBloc/delete_user_event.dart';
import '../../bloc/deleteUserBloc/delete_user_state.dart';
import '../../bloc/getSettingsBloc/get_settings_bloc.dart';
import '../../bloc/getSettingsBloc/get_settings_state.dart';
import '../../bloc/getUserProfileBloc/get_user_profile_bloc.dart';

import '../../bloc/getUserProfileBloc/get_user_profile_event.dart';
import '../../bloc/languageBloc/language_switcher_bloc.dart';
import '../../bloc/languageBloc/language_switcher_event.dart';

import '../../bloc/memberShipPlanBloc/membership_bloc.dart';
import '../../bloc/memberShipPlanBloc/membership_event.dart';
import '../../bloc/themeBloc/theme_switcher_bloc.dart';
import '../../bloc/themeBloc/theme_switcher_event.dart';
import '../../config/check_internet.dart';

import '../../../l10n/app_localizations.dart';


import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../utils/widgets/no_internet_screen.dart';

import 'fontSizeSettings/font_size.dart';
import 'membership/membership_card.dart';



class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // For Internet Check
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  String? token;

  @override
  void initState()  {
    super.initState();


    context.read<MembershipBloc>().add(FetchMembershipPlans());

    deviceId();
    CheckInternet.initConnectivity().then((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        setState(() {
          _connectionStatus = results;
        });
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
          });
        });
      }
    });

    _loadToken();
  }




  Future<String?> _loadToken() async {

    AuthResponse? fetchedToken = await HiveStorage().getToken();
    Users? user = fetchedToken?.data?.user;
    setState(() {
      token = fetchedToken?.data?.token;
      userProfile = user?.profile;
      userName = user?.name;

    });

    log("user token $token");

    if(token != null && token!.isNotEmpty){
      if(mounted){
        context.read<GetUserProfileBloc>().add(FetchUserProfile());
      }
    }

    if (kDebugMode) {
      print("profile+-+-+-+-+ $userProfile");
      print("name+-+-+-+-+ $userName");
    }


   return token;
  }


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> deleteUser() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final HiveStorage hiveStorage = HiveStorage();

   await auth.signOut();
   await hiveStorage.clearToken();
  }


  @override
  Widget build(BuildContext context) {
    return  _connectionStatus.contains(connectivityCheck)
          ? NoInternetScreen()
          : BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            _loadToken();
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  // expandedHeight: 120,
                  // floating: false,
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      AppLocalizations.of(context)!.profile,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: fontType,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.02),
                        // Profile section with animation
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (token == null) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).push('/signin');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.blueclr.withValues(alpha:0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.blueclr.withValues(alpha:0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: AppColors.blueclr.withValues(alpha:0.2),
                                          child: Icon(
                                            Remix.user_line,
                                            size: 30,
                                            color: AppColors.blueclr,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.login,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: fontType,
                                                ),
                                              ),
                                               SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(context)!.signInToAccessAllFeatures,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Remix.arrow_right_s_line,
                                          color: AppColors.blueclr,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).push("/userProfilePage");
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors().primaryColor.withValues(alpha:0.1),
                                        AppColors().primaryColor.withValues(alpha:0),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors().primaryColor.withValues(alpha:0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors().primaryColor,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors().primaryColor.withValues(alpha:0.2),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: ImageUtils.networkImageProvider(userProfile),
                                          backgroundColor: Colors.grey[200],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userName.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: fontType,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                             SizedBox(height: 4),
                                            Text(
                                              AppLocalizations.of(context)!.tapToEditProfile,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors().primaryColor.withValues(alpha:0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Remix.arrow_right_s_line,
                                          color: AppColors().primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        BlocBuilder<GetSettingsBloc, GetSettingsState>(
                          builder: (context, state) {
                            // Get the limit values
                            final getSettingsBloc = context.read<GetSettingsBloc>();
                            final String? postLimit = getSettingsBloc.freeTrialPostLimit();
                            final String? storyLimit = getSettingsBloc.freeTrialStoryLimit();


                            final bool shouldHideMembershipCard = postLimit == "-1" && storyLimit == "-1";


                            if (shouldHideMembershipCard) {
                              return SizedBox.shrink();
                            }


                            return Column(
                              children: [
                                SizedBox(height: 24),
                                MembershipCard(),
                              ],
                            );
                          },
                        ),

                        if (token != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              // color: AppColors().primaryColor.withValues(alpha:0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.05),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.myAccount,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: fontType,

                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).push('/userChannelFollow');
                                  },
                                  child: ProfileBtn(
                                    profileIcon: Remix.user_follow_line,
                                    profileLabel: AppLocalizations.of(context)!.followedChannels,
                                    profileIcon2: Remix.arrow_right_s_line,
                                    iconColor: AppColors().primaryColor,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).go('/bookmarks');
                                  },
                                  child: ProfileBtn(
                                    profileIcon: HeroiconsOutline.bookmark,
                                    profileLabel: AppLocalizations.of(context)!.bookmarks,
                                    profileIcon2: Remix.arrow_right_s_line,
                                    iconColor: AppColors().primaryColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).push('/transaction');
                                  },
                                  child: ProfileBtn(
                                    profileIcon: HeroiconsOutline.cubeTransparent,
                                    profileLabel: AppLocalizations.of(context)!.transaction,
                                    profileIcon2: Remix.arrow_right_s_line,
                                    iconColor: AppColors().primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // const SizedBox(height: 16),

                        ],

                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.05),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha:0.03),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.generalSettings,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: fontType,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  showThemeDialog(context);
                                },
                                child: ProfileBtn(
                                  profileIcon: Remix.sun_line,
                                  profileLabel: AppLocalizations.of(context)!.theme,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.blueGrey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).push('/categorySection');
                                },
                                child: ProfileBtn(
                                  profileIcon:HeroiconsSolid.rectangleGroup,
                                  profileLabel: AppLocalizations.of(context)!.topics,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.deepPurpleAccent,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showFontSizePopup(context);
                                },
                                child: ProfileBtn(
                                  profileIcon: Remix.text_snippet,
                                  profileLabel: AppLocalizations.of(context)!.textSize,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.amber,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  showLanguageDialog(context);
                                },
                                child: ProfileBtn(
                                  profileIcon: HeroiconsOutline.language,
                                  profileLabel: AppLocalizations.of(context)!.language,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.05),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha:0.03),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.supportAndAbout,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: fontType,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).push('/contactUs');
                                },
                                child: ProfileBtn(
                                  profileIcon: HeroiconsOutline.envelope,
                                  profileLabel: AppLocalizations.of(context)!.contactUs,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.lightBlueAccent,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  rateApp(androidPackageName, appStoreId.toString());
                                },
                                child: ProfileBtn(
                                  profileIcon: HeroiconsOutline.sparkles,
                                  profileLabel: AppLocalizations.of(context)!.rateApp,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.deepOrangeAccent,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  shareApp(appName, androidPackageName, context);
                                },
                                child: ProfileBtn(
                                  profileIcon: HeroiconsOutline.share,
                                  profileLabel: AppLocalizations.of(context)!.shareApp,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.deepPurpleAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.05),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha:0.03),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.legal,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: fontType,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).push('/customeProfileDisplayData/${AppLocalizations.of(context)!.termsAndConditions}/terms_conditions');
                                },
                                child: ProfileBtn(
                                  profileIcon: HeroiconsOutline.clipboardDocument,
                                  profileLabel: AppLocalizations.of(context)!.termsAndConditions,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.blue,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).push('/customeProfileDisplayData/${AppLocalizations.of(context)!.privacyPolicy}/privacy_policy');
                                },
                                child: ProfileBtn(
                                  profileIcon: HeroiconsOutline.lockClosed,
                                  profileLabel: AppLocalizations.of(context)!.privacyPolicy,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).push('/customeProfileDisplayData/${AppLocalizations.of(context)!.aboutUs}/about_us');
                                },
                                child: ProfileBtn(
                                  profileIcon: HeroiconsOutline.informationCircle,
                                  profileLabel: AppLocalizations.of(context)!.aboutUs,
                                  profileIcon2: Remix.arrow_right_s_line,
                                  iconColor: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (token != null) ...[
                          const SizedBox(height: 24),
                          BlocListener<DeleteUserBloc, DeleteUserState>(
                            listener: (context, state) {
                              if (state is DeleteUserLoadingState) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                    child: CircularProgressIndicator(color: AppColors().primaryColor),
                                  ),
                                );
                              } else if (state is DeleteUserSuccess) {
                                Navigator.pop(context);
                                deleteUser();
                                GoRouter.of(context).pushReplacement("/splashscreen");
                              } else if (state is DeleteUserErrorState) {
                                Navigator.pop(context);
                                CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
                              }
                            },
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDeletePopup(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha:0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red.withValues(alpha:0.3)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          HeroiconsOutline.trash,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          AppLocalizations.of(context)!.deleteAccount,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(LogOutRequestEvent(context: context));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors().primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                    shadowColor: AppColors().primaryColor.withValues(alpha:0.3),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppLocalizations.of(context)!.logout,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontType,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );


  }
}



void showDeletePopup(BuildContext context)async {
  showDialog(
    context:  context,
    builder: (context) => AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: AppColors().primaryColor, size: 40),
      title: Text(AppLocalizations.of(context)!.areYouSure,style: TextStyle(fontFamily: fontType),),
      content: Text(AppLocalizations.of(context)!.doYouWantToDeleteYourAccountWithThisAction,style: TextStyle(fontFamily: fontType),),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(AppLocalizations.of(context)!.cancel,style: TextStyle(fontFamily: fontType),),
        ),
        FilledButton(
          onPressed: () async {
            context.read<DeleteUserBloc>().add(DeleteUser(userDevice: userDeviceId, context: context));
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: Text(AppLocalizations.of(context)!.okLabel,style: TextStyle(color: Colors.white,fontFamily: fontType),),
        ),
      ],
    ),
  );
}


void showThemeDialog(BuildContext context) {
  ThemeMode? selectedTheme = context.read<ThemeBloc>().state;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.only(
              left: MediaQueryHelper.screenWidth(context) * 0.03,
              right: MediaQueryHelper.screenWidth(context) * 0.03),
          actionsPadding: EdgeInsets.only(
              right: MediaQueryHelper.screenWidth(context) * 0.03,
              bottom: MediaQueryHelper.screenHeight(context) * 0.01),
          title: Text(AppLocalizations.of(context)!.chooseTheme,style: TextStyle(fontFamily: fontType),),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: MediaQueryHelper.screenWidth(context) * 0.1,
                height: MediaQueryHelper.screenHeight(context) * 0.22,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeMode>(
                      visualDensity: VisualDensity(horizontal: -4),
                      activeColor: AppColors().primaryColor,
                      title:  Text(AppLocalizations.of(context)!.systemMode,
                          style: TextStyle(
                              fontSize: 17, fontFamily: fontType)),
                      value: ThemeMode.system,
                      groupValue: selectedTheme,
                      onChanged: (ThemeMode? value) {
                        setState(() {
                          selectedTheme = value;
                        });
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      visualDensity: VisualDensity(horizontal: -4),
                      activeColor: AppColors().primaryColor,
                      title: Text(
                        AppLocalizations.of(context)!.darkMode,
                        style:
                            TextStyle(fontSize: 17, fontFamily: fontType),
                      ),
                      value: ThemeMode.dark,
                      groupValue: selectedTheme,
                      onChanged: (ThemeMode? value) {
                        setState(() {
                          selectedTheme = value;
                        });
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      visualDensity: VisualDensity(horizontal: -4),
                      activeColor: AppColors().primaryColor,
                      title:  Text(AppLocalizations.of(context)!.lightMode,
                          style: TextStyle(
                              fontSize: 17, fontFamily: fontType)),
                      value: ThemeMode.light,
                      groupValue: selectedTheme,
                      onChanged: (ThemeMode? value) {
                        setState(() {
                          selectedTheme = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child:  Text(AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                      color: AppColors().primaryColor,
                      fontSize: 16,
                      fontFamily: fontType)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text(
                AppLocalizations.of(context)!.apply,
                style: TextStyle(
                    color: AppColors().primaryColor,
                    fontSize: 16,
                    fontFamily: fontType),
              ),
              onPressed: () {
                if (selectedTheme != null) {
                  context.read<ThemeBloc>().add(ThemeChanged(selectedTheme!));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

void showLanguageDialog(BuildContext context) {
  String? selectedLanguage = context.read<LanguageBloc>().state.locale.languageCode;



  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
        ),
        actionsPadding: EdgeInsets.only(
          right: MediaQueryHelper.screenWidth(context) * 0.03,
          bottom: MediaQueryHelper.screenHeight(context) * 0.01,
        ),
        title: Text(
          AppLocalizations.of(context)!.chooseLanguage,
          style: TextStyle(fontFamily: fontType),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQueryHelper.screenWidth(context) * 0.1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: languagesCode.map((lang) {
                    return RadioListTile<String>(
                      visualDensity: VisualDensity(horizontal: -4),
                      activeColor: AppColors().primaryColor,
                      title: Text(
                        lang['name']!,
                        style: TextStyle(fontSize: 17, fontFamily: fontType),
                      ),
                      value: lang['code'].toString(),
                      groupValue: selectedLanguage,
                      onChanged: (String? value) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: AppColors().primaryColor,
                fontSize: 16,
                fontFamily: fontType,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.apply,
              style: TextStyle(
                color: AppColors().primaryColor,
                fontSize: 16,
                fontFamily: fontType,
              ),
            ),
            onPressed: () {
              if (selectedLanguage != null) {
                context.read<LanguageBloc>().add(
                  ChangeLanguage(languageCode: selectedLanguage!),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


