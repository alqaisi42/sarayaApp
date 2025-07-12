// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/app_links.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/shimmer.dart';

import 'package:newsapp/screens/home/popularNews/popular_news.dart';
import 'package:newsapp/screens/home/publisher/publisher.dart';
import 'package:newsapp/screens/home/recommendationNews/recommendation.dart';
import 'package:newsapp/screens/home/slider/slider.dart';
import 'package:newsapp/screens/home/userFollowedChannels/user_followed_channel_news.dart';
import 'package:newsapp/screens/home/weather/weather_ui.dart';
import 'package:newsapp/utils/widgets/custome_safearae.dart';
import '../../../l10n/app_localizations.dart';

import 'package:remixicon/remixicon.dart';
import '../../Model/auth model/auth_response_model.dart';
import '../../bloc/categoryNewsBloc/category_bloc.dart';
import '../../bloc/categoryNewsBloc/category_event.dart';
import '../../bloc/channelBloc/channel_bloc.dart';
import '../../bloc/channelBloc/channel_event.dart';
import '../../bloc/followedChannelsPostBloc/followed_channels_post_bloc.dart';
import '../../bloc/followedChannelsPostBloc/followed_channels_post_event.dart';
import '../../bloc/getSettingsBloc/get_settings_bloc.dart';
import '../../bloc/getSettingsBloc/get_settings_state.dart';
import '../../bloc/locationCoordinatesBloc/location_coordinated_state.dart';
import '../../bloc/locationCoordinatesBloc/location_coordinates_bloc.dart';
import '../../bloc/locationCoordinatesBloc/location_coordinates_event.dart';
import '../../bloc/newsTopicsBloc/news_topic_bloc.dart';
import '../../bloc/newsTopicsBloc/news_topic_event.dart';
import '../../bloc/newsTopicsBloc/news_topic_state.dart';
import '../../bloc/notificationBloc/notification_bloc.dart';
import '../../bloc/notificationBloc/notification_event.dart';
import '../../bloc/notificationBloc/notification_state.dart';
import '../../bloc/popularHomeNewsBloc/popular_news_home_bloc.dart';
import '../../bloc/popularHomeNewsBloc/popular_news_home_event.dart';
import '../../bloc/recommendationNewsBloc/recommendation_bloc.dart';
import '../../bloc/recommendationNewsBloc/recommendation_event.dart';
import '../../bloc/sliderBloc/slider_bloc.dart';
import '../../bloc/sliderBloc/slider_event.dart';
import '../../bloc/storiesBloc/stories_bloc.dart';
import '../../bloc/storiesBloc/stories_event.dart';
import '../../bloc/weatherBloc/weather_bloc.dart';
import '../../bloc/weatherBloc/weather_event.dart';
import '../../config/check_internet.dart';
import '../../config/constants.dart';

import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../notification_service.dart';

import '../../utils/widgets/no_internet_screen.dart';

import 'categoryNews/category_news.dart';
import 'stories/homepage_stories.dart';



class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}
class _MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  bool _isFirstConnectivityCheck = true;
  final FirebaseMessagingService _firebaseMessagingService = FirebaseMessagingService();
  late TabController _tabController;
  final ScrollController _tabScrollController = ScrollController();

  String? _fcmToken;

  String? token;
  //For Internet Check
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // For Share Post
  final AppLinksDeepLink _appLinksDeepLink = AppLinksDeepLink.instance;

  @override
  void initState() {
    super.initState();
    // checkInitialMessage();

    _loadToken();
    initNotification();
    _appLinksDeepLink.initDeepLinks(context);
    context.read<NewsTopicBloc>().add(FetchNewsTopic());
    context.read<NotificationBloc>().add(FetchNotification(initialValue: 1, context: context));

    CheckInternet.initConnectivity().then((results) {
      if (mounted && results.isNotEmpty) {
        setState(() {
          _connectionStatus = results;
        });
      }
    });
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (mounted) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          if (_isFirstConnectivityCheck) {
            _isFirstConnectivityCheck = false;
            return;
          }
          setState(() {
            _connectionStatus = value;
            _refreshContent();
          });
        });
      }
    });
  }

  Future<void> initNotification() async {
    final token = await _firebaseMessagingService.getToken();
    setState(() {
      _fcmToken = token;
    });


  }

  @override
  void dispose() {
    AppLinksDeepLink.instance.dispose();
    _connectivitySubscription.cancel();
    _tabController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  Future<String?> _loadToken() async {
    AuthResponse? fetchedToken = await HiveStorage().getToken();
    final userToken = fetchedToken?.data;
    setState(() {
      token = userToken?.token;
    });
    return token;
  }

  Future<void> _refreshContent() async {
    context.read<LocationBloc>().add(FetchLocationEvent(context: context));
    context.read<SliderBloc>().add(FetchSlider(refreshIndicator: true));
    context.read<ChannelBloc>().add(FetchChannels(refreshIndicator: true, context: context));
    context.read<PopularBloc>().add(FetchPopular(refreshIndicator: true, context: context));
    context.read<RecommendationBloc>().add(FetchRecommendation(refreshIndicator: true, context: context));
    context.read<NewsTopicBloc>().add(FetchNewsTopic(refreshIndicator: true));
    context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: context,));
    context.read<NotificationBloc>().add(FetchNotification(initialValue: 1, context: context, fcmToken: _fcmToken));
    context.read<WeatherBloc>().add(FetchWeatherData(lat: latitude, lon: longitude, reFetch: true));
    context.read<StoriesBloc>().add(FetchStories(reFetch: true));
    initNotification();
  }


  void _scrollToSelectedTab() {
    // Get all tab widths
    final RenderBox tabBarBox = context.findRenderObject() as RenderBox;
    double tabBarWidth = tabBarBox.size.width;

    // Calculate approximate position of the tab (assuming equal width tabs)
    // We can refine this with more precise calculations if needed
    double approximateTabWidth = tabBarWidth / _tabController.length;
    double targetPosition = _tabController.index * approximateTabWidth;

    // Ensure the scroll position is within bounds
    double maxScroll = _tabScrollController.position.maxScrollExtent;
    double targetScroll = min(targetPosition, maxScroll);

    // Animate to the position
    _tabScrollController.animateTo(
      targetScroll,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return  _connectionStatus.contains(connectivityCheck)
            ? NoInternetScreen()
            : BlocBuilder<NewsTopicBloc, NewstopicState>(
          builder: (context, state) {
            int tabCount = 1;
            List<Widget> tabs = [Tab(child: Text(AppLocalizations.of(context)!.forYou, style: TextStyle(fontFamily: fontType)))];
            List<Widget> tabContent = [
              RefreshIndicator(
                onRefresh: _refreshContent,
                color: AppColors().primaryColor,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      HomepageStories(),
                      CustomSlider(),
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                          if (state is LocationSuccess) {
                            final lat = state.latitude;
                            final lon = state.longitude;
                            longitude = lon;
                            latitude = lat;
                            if(weatherKey.isNotEmpty){
                              return WeatherUI(lat: lat, lon: lon);
                            } else {
                              return SizedBox.shrink();
                            }


                          } else if (state is LocationFailure) {
                            return SizedBox.shrink();
                          } else {
                            return  SizedBox.shrink();
                          }
                        },
                      )
                      ,
                      PopularNews(),
                      Publisher(),
                      UserFollowedChannelNews(),
                      Recommendation(),
                    ],
                  ),
                ),
              ),
            ];

            if (state is NewstopicLoadingState) {
              for (int i = 0; i < 5; i++) {
                tabs.add(ShimmerWidget(
                  width: MediaQueryHelper.screenWidth(context) * 0.2,
                  height: MediaQueryHelper.screenHeight(context) * 0.04,
                ));

                tabContent.add(Center(child: CircularProgressIndicator()));
                tabCount++;
              }
            } else if (state is NewstopicSuccessState) {
              int count = 0;

              for (var topic in state.newsTopic) {
                for (var data in topic.data ?? []) {
                  if (count < 5) {
                    tabs.add(Tab(child: Text(data.name ?? "", style: TextStyle(fontSize: 15, fontFamily: fontType,color: isDark ? Colors.grey[350] : Colors.grey[600]))));
                    tabContent.add(_buildCategoryContent(data.name ?? ""));
                    count++;
                    tabCount++;
                  } else {
                    break;
                  }
                }
                if (count >= 5) break;
              }
            }


            _tabController = TabController(
              length: tabCount,
              vsync: this,
            );


            _tabController.addListener(() {

              if (_tabController.indexIsChanging || _tabController.animation!.value == _tabController.index.toDouble()) {

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {

                    _scrollToSelectedTab();
                  }
                });
              }
            });

            return  Scaffold(
                 backgroundColor: Theme.of(context).colorScheme.surface,
                 appBar: AppBar(
                   backgroundColor: Theme.of(context).colorScheme.surface,
                   title: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Image.asset("assets/img/logo.png", height: 27,),
                       SizedBox(width: 10,),
                       Text(
                         AppLocalizations.of(context)!.appName,
                         style: TextStyle(
                           fontSize: 18,
                           fontFamily: fontType,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                   bottom: PreferredSize(
                     preferredSize: Size.fromHeight(MediaQueryHelper.screenHeight(context) * 0.04),
                     child: Align(
                       alignment: Alignment.centerLeft,
                       child: SingleChildScrollView(
                         controller: _tabScrollController,
                         scrollDirection: Axis.horizontal,
                         physics: BouncingScrollPhysics(),
                         child: Row(
                           children: [
                             // Updated TabBar with controller
                             TabBar(
                               controller: _tabController,
                               dividerColor: Colors.transparent,
                               unselectedLabelStyle: TextStyle(
                                   color: AppColors.greyColor, fontWeight: FontWeight.w500),
                               tabAlignment: TabAlignment.start,
                               indicatorColor: AppColors().primaryColor,
                               labelColor: AppColors().primaryColor,
                               labelStyle: TextStyle(
                                   fontSize: 16,
                                   fontFamily: fontType,
                                   fontWeight: FontWeight.w600),
                               isScrollable: true,
                               tabs: tabs,
                               onTap: (index) {
                                 // When tab is tapped, ensure it's visible
                                 WidgetsBinding.instance.addPostFrameCallback((_) {
                                   if (mounted) {
                                     _scrollToSelectedTab();
                                   }
                                 });
                               },
                             ),
                             // Add the "See All" button separately
                             GestureDetector(
                               onTap: () {
                                 GoRouter.of(context).push('/categorySection');
                               },
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                 child: Text(
                                   AppLocalizations.of(context)!.seeAll,
                                   style: TextStyle(
                                     fontFamily: fontType,
                                     color: AppColors().primaryColor,
                                     fontSize: 16,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                   actions: [
                     BlocBuilder<GetSettingsBloc, GetSettingsState>(
                       builder: (context, state) {
                         if (state is GetSettingsSuccessState) {
                           final settingsList = state.getSettingsData;

                           if (settingsList.isNotEmpty && settingsList[0].data != null) {
                             final setting = settingsList[0].data!.firstWhere(
                                   (item) => item.name == "news_language_status",

                             );

                             if (setting.value == 'true') {
                               return GestureDetector(
                                 onTap: () {
                                   GoRouter.of(context).push("/multiLangNews");
                                 },
                                 child: Icon(HeroiconsSolid.language),
                               );
                             }
                           }
                         }

                         return SizedBox.shrink();
                       },
                     )

                     ,
                     BlocBuilder<NotificationBloc, NotificationState>(
                       builder: (context, state) {
                         bool? hasNotifications = false;

                         if (state is NotificationSuccessState) {
                           hasNotifications = state.notificationData[0].data!.isAllRead ?? false;
                         }

                         return Stack(
                           clipBehavior: Clip.none,
                           children: [
                             IconButton(
                               icon: Icon(HeroiconsOutline.bell),
                               onPressed: () {
                                 GoRouter.of(context).pushNamed('notification');
                               },
                             ),
                             if (hasNotifications)
                               Positioned(
                                 top: 8,
                                 right: 15,
                                 child: Container(
                                   width: 8,
                                   height: 8,
                                   decoration: BoxDecoration(
                                     color: Colors.red,
                                     shape: BoxShape.circle,
                                   ),
                                 ),
                               ),
                           ],
                         );
                       },
                     )
                   ],
                 ),
                 body: CustomSafeArea(
                   child: TabBarView(
                     controller: _tabController,
                     children: tabContent,
                   ),
                 ),
                 floatingActionButton: FloatingActionButton(
                   onPressed: () {
                     context.pushNamed('discoversearch');
                   },
                   child: Icon(Remix.search_2_line),
                   backgroundColor: Theme.of(context).colorScheme.primary,
                   foregroundColor: AppColors().primaryColor,
                 ),
               );
          },
        );


  }
}

Widget _buildCategoryContent(String category) {
  return BlocProvider(
    create: (context) => CategoryBloc()..add(FetchCategoryContent(category: category, initialValue: 1, context: context)),
    child: CategoryNews(category: category),
  );
}



