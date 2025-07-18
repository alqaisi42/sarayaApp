import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:newsapp/screens/Splash/splash_screen.dart';
import 'package:newsapp/screens/bookmarks/bookmarks.dart';
import 'package:newsapp/screens/discover/discover.dart';
import 'package:newsapp/screens/home/seachbar/search_bar.dart';
import 'package:newsapp/screens/home/home.dart';

import 'package:newsapp/screens/home/popularNews/popular_newsall.dart';
import 'package:newsapp/screens/login/loginotp_screen.dart';
import 'package:newsapp/screens/login/register.dart';

import 'package:newsapp/screens/login/reset_password.dart';
import 'package:newsapp/screens/login/signup_with_number.dart';
import 'package:newsapp/screens/login/signin.dart';
import 'package:newsapp/screens/profile/profile.dart';

import '../Model/stories_model.dart';
import '../bloc/fullScreenModeBloc/full_screen_mode_bloc.dart';
import '../bloc/fullScreenModeBloc/full_screen_mode_event.dart';
import '../bloc/searchResultBloc/search_result_bloc.dart';
import '../bloc/searchResultBloc/search_result_event.dart';


import '../screens/home/BreakingNewsWidget/BreakingNewsPage.dart';
import '../screens/home/notification/notification.dart';
import '../screens/home/publisher/publisher_all.dart';
import '../screens/home/recommendationNews/recommedation_all.dart';

import '../screens/home/stories/news_stories_ui.dart';
import '../screens/home/stories/topics_all_stories.dart';
import '../screens/home/stories/topics_stories.dart';
import '../screens/home/userFollowedChannels/user_followed_channel_news_all.dart';
import '../screens/profile/category/category.dart';
import '../screens/profile/category/category_displaydata.dart';
import '../screens/profile/contactUs/contact_us.dart';
import '../screens/profile/membership/membership_plan.dart';
import '../screens/profile/transaction/transaction.dart';
import '../screens/profile/userFollowedChannel/user_followed_channel.dart';
import '../screens/profile/userProfile/user_profile_page.dart';


import '../screens/videoNews/video_news.dart';
import '../utils/widgets/bottomNavigation/bottom_navigation.dart';
import '../utils/widgets/channels_preference.dart';

import '../utils/widgets/custome_news_pages.dart';
import '../utils/widgets/custome_profile_displaydata.dart';
import '../utils/widgets/detailPage/detail_page.dart';

import '../utils/widgets/maintence_mode_screen.dart';
import '../utils/widgets/multi_lang_news.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


final GoRouter router = GoRouter(
  initialLocation: '/splashscreen',
  navigatorKey: navigatorKey,
  routes: [
    ShellRoute(
        builder: (context, state, child) {
          return BottomNavigationScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) {
              return const MaterialPage(child: MyHome());
            },
          ),
          GoRoute(
            path: '/discover',
            name: 'discover',
            pageBuilder: (context, state) {
              return const MaterialPage(child: Discover());
            },
          ),
          GoRoute(
            path: '/videoNews',
            name: 'videoNews',
            pageBuilder: (context, state) {
              return const MaterialPage(child: VideoNews());
            },
          ),
          GoRoute(
            path: '/bookmarks',
            name: 'bookmarks',
            pageBuilder: (context, state) {
              return const MaterialPage(child: Bookmarks());
            },
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) {
              return const MaterialPage(child: Profile());
            },
          ),
        ]),

GoRoute(
      path: '/categorySection',
      name: 'categorySection',
      pageBuilder: (context, state) {
        return MaterialPage(child: CategorySection());
      },
    ),

    GoRoute(
      path: '/topicsStories',
      name: 'topicsStories',
      pageBuilder: (context, state) {
        return const MaterialPage(child: TopicsStories());
      },
    ),




    GoRoute(
      path: '/maintenanceModeScreen',
      name: 'maintenanceModeScreen',
      pageBuilder: (context, state) {
        return const MaterialPage(child: MaintenanceModeScreen());
      },
    ),

    GoRoute(
      path: '/transaction',
      name: 'transaction',
      pageBuilder: (context, state) {
        return const MaterialPage(child: Transaction());
      },
    ),

    GoRoute(
      path: '/channelsPreference',
      name: 'channelsPreference',
      pageBuilder: (context, state) =>
          MaterialPage(child: ChannelsPreference()),
    ),

    GoRoute(
      name: 'breakingNews',
      path: '/breakingNews',
      builder: (context, state) => BreakingNewsPage(), // create this screen
    ),

    GoRoute(
      path: '/multiLangNews',
      name: 'multiLangNews',
      pageBuilder: (context, state) =>
          MaterialPage(child: MultiLangNews(pageName: state.extra as String?)),
    ),
    GoRoute(
      path: '/userChannelFollow',
      name: 'userChannelFollow',
      pageBuilder: (context, state) {
        return const MaterialPage(child: UserChannelFollow());
      },
    ),
    GoRoute(
      path: '/popularNewsAll',
      name: 'popularNewsAll',
      pageBuilder: (context, state) {
        return const MaterialPage(child: PopularNewsall());
      },
    ),
    GoRoute(
      path: '/recommedationAll',
      name: 'recommedationAll',
      pageBuilder: (context, state) {
        return const MaterialPage(child: RecommendationAll());
      },
    ),
    GoRoute(
      path: '/categoryData/:category',
      name: 'CategoryData',
      builder: (context, state) {
        final categoryValue = state.pathParameters['category'] ?? "";
        return CategoryData(
          category: categoryValue,
        );
      },
    ),
    GoRoute(
      path: '/channelsAll',
      name: 'channelsAll',
      pageBuilder: (context, state) {
        return MaterialPage(child: PublisherAll(pageName: state.extra as String?));
      },
    ),
    GoRoute(
      path: '/customeProfileDisplayData/:title/:about_us',
      name: 'customeProfileDisplayData',
      builder: (context, state) {
        final appTitle = state.pathParameters['title'] ?? '';
        final slug = state.pathParameters['about_us'] ?? '';
        return CustomeProfileDisplayData(title: appTitle, slug: slug);
      },
    ),

    GoRoute(
      path: '/userProfilePage',
      name: 'userProfilePage',
      pageBuilder: (context, state) {
        return MaterialPage(child: UserProfilePage());
      },
    ),
    GoRoute(
      path: '/splashscreen',
      name: 'splashscreen',
      pageBuilder: (context, state) {
        return MaterialPage(
          child: Builder(
            builder: (ctx) {
              // Now ctx has access to MultiBlocProvider in main.dart
              return const SplashScreen();
            },
          ),
        );
      },
    ),

    GoRoute(
      path: '/userFollowedChannelNewsAll',
      name: 'userFollowedChannelNewsAll',
      pageBuilder: (context, state) => const MaterialPage(child: UserFollowedChannelNewsAll()),
    ),



    GoRoute(
      path: '/detailpage/:slug',
      onExit: (context, state) async {
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

        if (isLandscape) {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);
          if(context.mounted){
            context.read<FullScreenBloc>().add(ToggleFullScreen(isFullScreenCheck: false));
          }
          return false;
        }
        return true;
      },
      builder: (context, state) {
        final slug = state.pathParameters['slug'] ?? '';
        final fcmToken = state.uri.queryParameters['fcmId'] ?? '';
        return DetailPage(slug: slug, fcmId: fcmToken);
      },
    ),



    GoRoute(
      path: '/topicsAllStories/:topicsname',
      builder: (context, state) {
        final topicsname = state.pathParameters['topicsname'] ?? '';
        return TopicsAllStories(
          topicName: topicsname,
        );
      },
    ),
    GoRoute(
      path: '/notification',
      name: 'notification',
      pageBuilder: (context, state) =>
      const MaterialPage(child: NotificationNews()),
    ),
    GoRoute(
      path: '/discoversearch',
      name: 'discoversearch',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const Discoversearch(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fastAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn, // Faster transition
          );
          return ScaleTransition(
            scale: fastAnimation,
            alignment: Alignment.center,
            child: child,
          );
        },
      ),
      onExit: (context, state) async {

        if (context.mounted) {
          context.read<SearchResultBloc>().add(EmptySearchResult());
        }

        return true;
      },
    ),
    GoRoute(
      path: '/signin',
      name: 'signin',
      pageBuilder: (context, state) => const MaterialPage(child: Signin()),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (context, state) => MaterialPage(child: RegisterScreen()),
    ),
    GoRoute(
      path: '/loginotpscreen',
      name: 'loginotpscreen',
      pageBuilder: (context, state) =>
      const MaterialPage(child: Loginotpscreen()),
    ),
    GoRoute(
      path: '/signupWithPhoneNumber',
      name: 'signupWithPhoneNumber',
      pageBuilder: (context, state) =>
      const MaterialPage(child: SignupWithPhoneNumber()),
    ),
    GoRoute(
      path: '/resetpasswordscreen',
      name: 'resetpasswordscreen',
      pageBuilder: (context, state) =>
          MaterialPage(child: ResetPasswordscreen()),
    ),
    GoRoute(
      path: '/contactUs',
      name: 'contactUs',
      pageBuilder: (context, state) =>
          MaterialPage(child: ContactUs()),
    ),
    GoRoute(
      path: '/story',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return StoryPage(
          initialPage: extra['initialPage'] as int,
          stories: extra['stories'] as List<Stories>,

        );
      },
    ),
    GoRoute(
      path: '/membershipScreen',
      name: 'membershipScreen',
      pageBuilder: (context, state) =>
          MaterialPage(child: MembershipScreen()),
    ),
    GoRoute(
      path: '/customNewsPage/:slug',
      name: 'customNewsPage',
      builder: (context, state) {
        final slug = state.pathParameters['slug'] ?? '';
        return ChannelPage(slug: slug);
      },
    ),
  ],
);


