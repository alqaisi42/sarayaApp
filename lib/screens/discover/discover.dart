// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/bloc/bookmark/bookmark_article_bloc.dart';
import 'package:newsapp/config/constants.dart';
import 'package:newsapp/config/shimmer.dart';


import 'package:remixicon/remixicon.dart';
import 'package:share_plus/share_plus.dart';

import '../../Model/auth model/auth_response_model.dart';

import '../../bloc/discoverBloc/discover_event.dart';
import '../../bloc/discoverBloc/discover_bloc.dart';
import '../../bloc/discoverBloc/discover_state.dart';

import '../../config/check_internet.dart';
import '../../config/colors.dart';


import '../../config/helper/empty_state_ui.dart';
import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../utils/widgets/no_internet_screen.dart';
import '../../../l10n/app_localizations.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  DiscoverUIState createState() => DiscoverUIState();
}

class DiscoverUIState extends State<Discover> {
  String? token;
  final SwiperController _swiperController = SwiperController();

  // For Internet Check
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> _refreshContent() async {
    context.read<DiscoverBloc>().add(FetchDiscover(context: context));
  }

  @override
  void initState() {
    _loadToken();



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
            context.read<DiscoverBloc>().add(FetchDiscover(context: context));
          });
        });
      }
    });

    super.initState();
    context.read<DiscoverBloc>().add(FetchDiscover(context: context));
  }



  Future<String?> _loadToken() async {
    AuthResponse? fetchedToken = await HiveStorage().getToken();

    setState(() {
      userToken = fetchedToken!.data!.token.toString();

    });

    return userToken;
  }



  @override
  void dispose() {
    _swiperController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return   _connectionStatus.contains(connectivityCheck)
        ? NoInternetScreen()
        : Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        color: AppColors().primaryColor,
        child: BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, state) {
            if (state is DiscoverNewsLoadingState) {

              return ShimmerWidget(
                width: MediaQueryHelper.screenWidth(context),
                height: MediaQueryHelper.screenHeight(context),
              );
            } else if (state is DiscoverNewsErrorState) {
              return Center(child: Text(state.errorMessage.toString(),style: TextStyle(fontFamily: fontType),));
            } else if (state is DiscoverNewsSuccessState) {
              final discoverData = state.discoverNews[0].data ?? [];

              if(discoverData.isEmpty){
                return EmptyStateWidget(
                  title: '${AppLocalizations.of(context)?.discoverTitle} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
                  customImage: Image.asset(
                    'assets/img/empty.png',
                    width: MediaQueryHelper.screenWidth(context) * 0.68,
                  ),
                  buttonText:AppLocalizations.of(context)!.retry,
                  onButtonPressed: () {
                    _refreshContent();
                  },

                );
              }

              return Stack(
                children: [
                  Swiper(
                    itemCount: discoverData.length + (state.hasMoreData ? 1 : 0),
                    loop: false,
                    itemBuilder: (context, index) {
                      if (index == discoverData.length) {
                        context.read<DiscoverBloc>().add(FetchMoreDiscover(context: context));
                        return ShimmerWidget(
                          width: MediaQueryHelper.screenWidth(context),
                          height: MediaQueryHelper.screenHeight(context),
                        );
                      }
                      return buildDiscoverItem(context, discoverData[index]);
                    },
                    scrollDirection: Axis.vertical,
                    onIndexChanged: (index) {
                      if (state.hasMoreData &&
                          index >= discoverData.length - 2) {
                        context.read<DiscoverBloc>().add(FetchMoreDiscover(context: context));
                      }
                    },
                  ),
                ],
              );
            } else if (state is DiscoverNewsLoadingMoreState) {
              final discoverData = state.discoverNews[0].data ?? [];

              return Stack(
                children: [
                  Swiper(
                    itemCount: discoverData.length + 1,
                    loop: false,
                    itemBuilder: (context, index) {
                      if (index == discoverData.length) {
                        return ShimmerWidget(
                          width: MediaQueryHelper.screenWidth(context),
                          height: MediaQueryHelper.screenHeight(context),
                        );
                      }
                      return buildDiscoverItem(context, discoverData[index]);
                    },
                    scrollDirection: Axis.vertical,
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );


  }
}

Widget buildDiscoverItem(BuildContext context, dynamic item) {

  return Stack(
    children: [
      Positioned(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {},
              child: ImageUtils.networkImage(item.image,height: MediaQueryHelper.screenHeight(context) * 0.55,width: double.infinity,fit: BoxFit.cover)
            ),
            Container(
              height: MediaQueryHelper.screenHeight(context) * 0.55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha:0.5),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.2],
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: MediaQueryHelper.screenHeight(context) * 2,
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 0,
                blurRadius: 100,
                offset: Offset(0, -4),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 292,
        left: 0,
        right: 0,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
            child: Container(
              width: double.infinity,
              height: 90,
            ),
          ),
        ),
      ),
      Positioned(
        top: MediaQueryHelper.screenHeight(context) * 0.42,
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQueryHelper.screenHeight(context) * 0.02,
                    left: MediaQueryHelper.screenWidth(context) * 0.04,
                    right: MediaQueryHelper.screenWidth(context) * 0.04),
                child: Container(
                  height: MediaQueryHelper.screenHeight(context) * 0.32,
                  // color: Colors.blue,
                  child: SingleChildScrollView(
                    child: DisplayDescription(item: item,),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).push(
                                        '/customNewsPage/${item.channelSlug}');
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.tapFor,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fontType,
                                          color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        item.channelName ?? "",
                                        style: TextStyle(
                                            color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[500],
                                            fontSize: 14,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontType),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final String appLink =
                                        '$baseUrl/posts/${item.slug}';
                                    Share.share(appLink);
                                  },
                                  icon: Icon(Remix.share_forward_2_fill,color: AppColors(context).isDark ? Colors.grey[500] : Colors.grey[600],),
                                ),
                                DiscoverFavoriteButton(
                                  postSlug: item.slug,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {

                        checkLimitAndNavigate(context, item.slug.toString());
                      },
                      child: Container(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ImageUtils.networkImage(item.image),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10,
                                      ),
                                      child: Container(
                                        color: Colors.black.withValues(alpha:0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 14),
                                      child: Text(
                                        item.title ?? "",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200,
                                            fontFamily: fontType),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      HeroiconsOutline.chevronRight,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


class DisplayDescription extends StatefulWidget {
  final dynamic item;

  const DisplayDescription({super.key, required this.item});

  @override
  ItemCardState createState() => ItemCardState();
}

class ItemCardState extends State<DisplayDescription> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    String descriptionText =  item.description ?? "No Data";


    String truncatedText = descriptionText.length > 100
        ? '${descriptionText.substring(0, min(300, descriptionText.length))}...'
        : descriptionText;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          item.title ?? "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: fontType,
          ),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text:  truncatedText,
            style: TextStyle(
              color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
              fontSize: 14,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
              fontFamily: fontType,


            ),
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.readMore,
                style: TextStyle(
                  color: AppColors().primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {

                    checkLimitAndNavigate(context, item.slug.toString());
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}




// Check Image Path and null value
Widget buildImage(String? imageUrl) {
  final isValidUrl = imageUrl != null &&
      imageUrl.isNotEmpty &&
      Uri.tryParse(imageUrl)?.hasAbsolutePath == true;

  return isValidUrl
      ? Image.network(
          imageUrl,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return SizedBox.shrink();
          },
        )
      : Image.asset("assets/img/defaultDiscoverImage.png");
}

class DiscoverFavoriteButton extends StatefulWidget {
  final String postSlug;

  const DiscoverFavoriteButton({
    super.key,
    required this.postSlug,
  });

  @override
  FavoriteButtonState createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<DiscoverFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(builder: (context, state) {
      state as BookmarkArticleAll;
      return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          state.slugs.contains(widget.postSlug)
                              ? HeroiconsSolid.bookmark
                              : HeroiconsOutline.bookmark,
                          color: state.slugs.contains(widget.postSlug)
                              ? AppColors().primaryColor
                              : Colors.grey.shade500,
                        ),
                        title: Text(
                            state.slugs.contains(widget.postSlug) ? AppLocalizations.of(context)!.removeBookmark : AppLocalizations.of(context)!.bookmarkPost,style: TextStyle(fontFamily: fontType)),
                        onTap: () async {

                          if(state.slugs.contains(widget.postSlug)){
                            context.read<BookmarkArticleBloc>().add(BookmarkArticleRemove(slug: widget.postSlug, context: context,slugType: "bookmark"));
                          }else{
                            context.read<BookmarkArticleBloc>().add(BookmarkArticleAdd(slug: widget.postSlug, context: context,slugType: "bookmark"));
                          }
                          Navigator.pop(context);

                        },
                      ),
                    ],
                  ),
                );
              },
            );

        },
        icon: Icon(HeroiconsOutline.ellipsisVertical,color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],),
      );
    });
  }
}



