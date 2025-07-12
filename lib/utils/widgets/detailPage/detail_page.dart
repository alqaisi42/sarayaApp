import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/bloc/notificationReadBloc/notification_read_bloc.dart';
import 'package:newsapp/bloc/notificationReadBloc/notification_read_event.dart';
import 'package:newsapp/config/colors.dart';

import 'package:newsapp/utils/widgets/detailPage/translator/translation_service.dart';
import 'package:share_plus/share_plus.dart';
import '../../../bloc/detailPageBloc/details_page_bloc.dart';
import '../../../bloc/detailPageBloc/details_page_event.dart';
import '../../../bloc/detailPageBloc/details_page_state.dart';
import '../../../bloc/fullScreenModeBloc/full_screen_mode_bloc.dart';
import '../../../bloc/fullScreenModeBloc/full_screen_mode_event.dart';
import '../../../bloc/fullScreenModeBloc/full_screen_mode_state.dart';
import '../../../bloc/subscriptionCountBloc/subscription_count_bloc.dart';
import '../../../bloc/subscriptionCountBloc/subscription_count_event.dart';
import '../../../bloc/subscriptionCountBloc/subscription_count_state.dart';
import '../../../config/check_internet.dart';
import '../../../config/constants.dart';
import '../../../config/googleAdMob/interstitial_ad.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/hiveLocalStorage/hive_storage.dart';
import '../../../config/shimmer.dart';



import '../../../l10n/app_localizations.dart';
import '../no_internet_screen.dart';
import 'detailPageData/detail_page_data.dart';
import 'detailPageHeader/detail_page_header.dart';


final reactionGlobalKey = GlobalKey<InterstitialAdWidgetState>();

class DetailPage extends StatefulWidget {
  final String slug;
  final String? fcmId;
  const DetailPage({super.key, required this.slug, this.fcmId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ScrollController _scrollController = ScrollController();


  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;




  bool _isFullscreenCheck = false;

  @override
  void initState() {
    super.initState();
    TranslationService.instance.sourceLanguage.value = '';
    TranslationService.instance.targetLanguage.value = '';


    context
        .read<NotificationReadBloc>()
        .add(UpdateNotificationRead(slug: widget.slug, isReadVal: true));





    initializeAsync();
    TextToSpeechHelper.initialize();
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
            context.read<DetailspageBloc>().add(FetchDetailspage(
                slug: widget.slug, context: context, deviceid: userDeviceId));
          });
        });
      }
    });
  }



  Future<void> initializeAsync() async {
    await deviceId();

    if (mounted) {
      context.read<DetailspageBloc>().add(FetchDetailspage(
          slug: widget.slug,
          context: context,
          deviceid: userDeviceId));
    }



    final features = await HiveStorage().getFreePlanFeatures();
    final userToken = await HiveStorage().getToken();

    // final bool? isPlanActive = features?['isActivePlan'];
    final bool? isPlanActive = true;


    if(userToken?.data?.token != null && isPlanActive == true) {
      if(mounted){

        context.read<SubscriptionCountBloc>().add(PostSubscriptionCount(countType: 'article'));
      }
    }
  }

  @override
  void dispose() {

    super.dispose();


    _connectivitySubscription.cancel();
  }

  Future<void> _refreshContent() async {
    context.read<DetailspageBloc>().add(FetchDetailspage(
        slug: widget.slug, context: context, deviceid: userDeviceId));
  }

  Future<void> toggleFullscreen() async {
    final currentState = context.read<FullScreenBloc>().state;

    if (currentState.isFullScreen) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      if (mounted) {
        context.read<FullScreenBloc>().add(ToggleFullScreen(isFullScreenCheck: false));
      }
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (mounted) {
        context.read<FullScreenBloc>().add(ToggleFullScreen(isFullScreenCheck: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  _connectionStatus.contains(connectivityCheck)
              ? NoInternetScreen()
              : Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<FullScreenBloc, FullScreenState>(
          builder: (context, state) {
            return state.isFullScreen
                ?  SizedBox.shrink()
                : AppBar(
              title: DetailPageHeader(slug: widget.slug),
            );
          },
        ),
      ),

                  body: RefreshIndicator(
                    onRefresh: _refreshContent,
                    color: AppColors().primaryColor,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: BlocListener<SubscriptionCountBloc, SubscriptionCountState>(
                      listener: (context, state) {
                        if (state is SubscriptionCountError) {
                         CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
                        }
                      },
                      child: BlocBuilder<DetailspageBloc, DetailspageState>(
                        builder: (context, state) {
                          if (state is DetailspageLoadingState) {
                            return _buildLoadingShimmer(context);
                          } else if (state is DetailspageSuccessState) {
                            final detailData = state.detailPage.first.data!;

                            if(state.detailPage.isEmpty ){
                              return EmptyStateWidget(
                                title: '${AppLocalizations.of(context)!.articles} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
                                customImage: Image.asset(
                                  'assets/img/empty.png',
                                  width: MediaQueryHelper.screenWidth(context) * 0.65,
                                ),
                                buttonText:AppLocalizations.of(context)!.retry,
                                onButtonPressed: () {
                                  initializeAsync();
                                },

                              );
                            }



                            return SingleChildScrollView(
                              controller: _scrollController,
                              child: DetailpageData(
                                id: detailData.id?.toString() ?? "",
                                title: detailData.title ?? "",
                                channelName: detailData.channelName ?? "",
                                channelLogo: detailData.channelLogo ?? "",
                                description: detailData.description ?? "",
                                image: detailData.image ?? "",
                                pubDate: detailData.pubdate ?? "",
                                commentCount: detailData.comment ?? 0,
                                viewCount: detailData.viewCount ?? 0,
                                channelSlug: detailData.channelSlug ?? "",
                                slug: detailData.slug ?? "",
                                publishDate: detailData.publishDate ?? "",
                                resource: detailData.resource ?? "",
                                emojiType: detailData.emojiType ?? "",
                                userHasReacted: detailData.userHasReacted ?? false,
                                userReactList: detailData.reactionList,
                                postType: detailData.postType.toString(),
                                videoThumb: detailData.videoThumb.toString(),
                                videoUrl: detailData.video.toString(),
                                realatedPost: detailData.reletedPost,
                                isFullscreenCheck: _isFullscreenCheck,
                                isAdsFree:  state.detailPage[0].isAdsFree ?? false,
                                newsLanguageCode:  state.detailPage[0].newsLanguageCode ?? 'en',
                                onFullscreenChange: (bool isFullscreen) {
                                  setState(() {
                                    _isFullscreenCheck = isFullscreen;
                                  });
                                },
                                onFullScreenToggle: () => toggleFullscreen(),
                                onAction: () => toggleFullscreen(),
                              ),
                            );
                          } else if (state is DetailspageErrorState) {
                            return Center(
                              child: Text(
                                state.errorMessage,
                                style: TextStyle(fontFamily: fontType),
                              ),
                            );
                          }
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.noDataAvailable,
                              style: TextStyle(fontFamily: fontType),
                            ),
                          );
                        },
                      ),
                    )
                    ,

                  ),
      floatingActionButton: BlocBuilder<FullScreenBloc, FullScreenState>(
        builder: (context, state) {
          if (state.isFullScreen) {
            return Container(); // or SizedBox.shrink()
          }
          return FloatingActionButton(
            onPressed: () {
              final String appLink = '$baseUrl/posts/${widget.slug}';
              Share.share(appLink);
            },
            child: Icon(HeroiconsOutline.share),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: AppColors().primaryColor,
          );
        },
      ),
                );
  }
}





Widget _buildLoadingShimmer(context) {
  return Column(
    children: [
      ShimmerWidget(
        width: MediaQueryHelper.screenWidth(context),
        height: MediaQuery.of(context).size.height * 0.25,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
      ), //
      ShimmerWidget(
        width: MediaQueryHelper.screenWidth(context),
        height: MediaQuery.of(context).size.height * 0.05,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShimmerWidget(
            width: MediaQueryHelper.screenWidth(context) * 0.3,
            height: MediaQuery.of(context).size.height * 0.05,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              left: MediaQuery.of(context).size.width * 0.03,
              right: MediaQuery.of(context).size.width * 0.03,
            ),
          ),
          ShimmerWidget(
            width: MediaQueryHelper.screenWidth(context) * 0.3,
            height: MediaQuery.of(context).size.height * 0.05,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              left: MediaQuery.of(context).size.width * 0.03,
              right: MediaQuery.of(context).size.width * 0.03,
            ),
          ),
        ],
      ),
      ShimmerWidget(
        width: MediaQueryHelper.screenWidth(context),
        height: MediaQuery.of(context).size.height * 0.05,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      ShimmerWidget(
        width: MediaQueryHelper.screenWidth(context),
        height: MediaQuery.of(context).size.height * 0.3,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
    ],
  );
}



class TextSizeBottomSheet {
  static void show(BuildContext context, double currentTextSize,
      Function(double) onTextSizeChanged) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.textSize,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: fontType,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.aLable,
                        style: TextStyle(fontSize: 16,fontFamily: fontType),
                      ),
                      Expanded(
                        child: Slider(
                          value: currentTextSize,
                          min: 17,
                          max: 40,
                          divisions: 26,
                          thumbColor: AppColors().primaryColor,
                          label: currentTextSize.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              currentTextSize = value;
                            });
                          },
                          onChangeEnd: (double value) {
                            onTextSizeChanged(value);
                          },
                          activeColor: AppColors().primaryColor,
                          inactiveColor: Colors.grey[300],
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.aLable,
                        style: TextStyle(fontSize: 24,fontFamily: fontType),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${AppLocalizations.of(context)!.currentSize}: ${currentTextSize.round()}',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,fontFamily: fontType
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}








