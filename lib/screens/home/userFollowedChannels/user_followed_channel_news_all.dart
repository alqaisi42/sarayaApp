import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/followedChannelsPostBloc/followed_channels_post_bloc.dart';
import '../../../bloc/followedChannelsPostBloc/followed_channels_post_event.dart';
import '../../../bloc/followedChannelsPostBloc/followed_channels_post_state.dart';
import '../../../config/check_internet.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../config/googleAdMob/banner_ad.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';


import '../../../utils/widgets/custome_dispay_newscard.dart';
import '../../../utils/widgets/no_internet_screen.dart';
import '../../../l10n/app_localizations.dart';
class UserFollowedChannelNewsAll extends StatefulWidget {
  const UserFollowedChannelNewsAll({super.key});

  @override
  State<UserFollowedChannelNewsAll> createState() => UserFollowedChannelNewsAllState();
}

class UserFollowedChannelNewsAllState extends State<UserFollowedChannelNewsAll> {
  final ScrollController _scrollController = ScrollController();
  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: context,initialValue: 1));

    CheckInternet.initConnectivity().then((List<ConnectivityResult> results) {
      if (mounted && results.isNotEmpty) {
        setState(() {
          _connectionStatus = results;
        });
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (mounted) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
            context.read<FollowedChannelsPostBloc>().add(
              FetchFollowedChannelsPost(refreshIndicator: true, context: context),
            );
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<FollowedChannelsPostBloc>().add(
        FetchMoreFollowedChannelsPost(context: context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus.contains(connectivityCheck)
        ? NoInternetScreen()
        : Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.followedChannelsPost),
      ),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: () async {
          context.read<FollowedChannelsPostBloc>().add(
            FetchFollowedChannelsPost(refreshIndicator: true, context: context),
          );
        },
        child: BlocBuilder<FollowedChannelsPostBloc, FollowedChannelsPostState>(
          builder: (context, state) {
            if (state is FollowedChannelsPostInitialState ||
                (state is FollowedChannelsPostLoadingState &&
                    state.followedChannelPostData.isEmpty)) {
              return Padding(
                padding:  EdgeInsets.only(left: MediaQueryHelper.screenWidth(context) * 0.04,right: MediaQueryHelper.screenWidth(context) * 0.04),
                child: _buildLoadingShimmer(),
              );
            } else if (state is FollowedChannelsPostErrorState &&
                context.read<FollowedChannelsPostBloc>().folloedPostData.isEmpty) {
              return Center(
                child: Text(
                  '${AppLocalizations.of(context)!.error}: ${state.errorMessage}',style: TextStyle(fontFamily: fontType),
                ),
              );
            } else {
              return _buildFollowedChannelsList(state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQueryHelper.screenWidth(context),
          height: MediaQueryHelper.screenHeight(context) * 0.1,
          margin: EdgeInsets.only(
            bottom: MediaQueryHelper.screenWidth(context) * 0.04,
          ),
        );
      },
    );
  }

  Widget _buildFollowedChannelsList(FollowedChannelsPostState state) {
    final allData = context
        .read<FollowedChannelsPostBloc>()
        .folloedPostData
        .expand((response) => response.data ?? [])
        .toList();


    if(allData.isEmpty){
      return EmptyStateWidget(
        title: '${AppLocalizations.of(context)!.fromChannelsYouFollowed} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
        customImage: Image.asset(
          'assets/img/empty.png',
          width: MediaQueryHelper.screenWidth(context) * 0.65,
        ),
        buttonText:AppLocalizations.of(context)!.retry,
        onButtonPressed: () {
          context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: context,initialValue: 1));
        },

      );
    }


    final bool showLoading =
        (state is FollowedChannelsPostLoadingMoreState) ||
            (state is FollowedChannelsPostSuccessState &&
                (state.hasMoreData ?? false));


    return ListView.builder(
      controller: _scrollController,
      itemCount: allData.length + (showLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == allData.length) {
          return _buildLoadingIndicator();
        }

        if(context
            .read<FollowedChannelsPostBloc>().isAdsFree == false){
          if (index > 0 && index % 4 == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: AdBannerWidget(),
            );
          }
        }
        final item = allData[index];
        return GestureDetector(
          onTap: () async {
            checkLimitAndNavigate(context, item.slug.toString());

          },
          child: Padding(
            padding: EdgeInsets.only(left: MediaQueryHelper.screenWidth(context) * 0.04,
                right: MediaQueryHelper.screenWidth(context) * 0.04),
            child: DisplayPopularNews(
              id: item.id ?? 0,
              viewCount: item.viewCount ?? 0,
              coverImg: item.image ?? '',
              title: item.title ?? '',
              channelSlug: item.channelSlug ?? '',
              logo: item.channelLogo ?? '',
              publisher: item.channelName ?? '',
              time: item.publishDate ?? '',
              slug: item.slug ?? '',
              postType: item.postType ?? "", videoThumb: item.videoThumb ?? "", video: item.videoUrl ?? "",
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(color: AppColors().primaryColor),
    );
  }
}

