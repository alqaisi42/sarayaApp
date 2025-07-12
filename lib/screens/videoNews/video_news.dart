
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/screens/videoNews/videoNewsBloc/video_news_all_event.dart';
import 'package:newsapp/screens/videoNews/videoNewsBloc/video_newsall_bloc.dart';
import 'package:newsapp/screens/videoNews/videoNewsBloc/video_newsall_state.dart';
import 'package:newsapp/screens/videoNews/widgets/video_news_card.dart';

import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../config/googleAdMob/banner_ad.dart';
import '../../config/helper/empty_state_ui.dart';
import '../../config/helper/helper_functions.dart';
import '../../l10n/app_localizations.dart';

import '../../config/shimmer.dart';

class VideoNews extends StatefulWidget {
  const VideoNews({super.key});

  @override
  State<VideoNews> createState() => _VideoNewsState();
}

class _VideoNewsState extends State<VideoNews> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<VideoNewsBloc>().add(FetchVideoNews(initialValue: 1, context: context));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<VideoNewsBloc>().add(FetchMoreVideoNews(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.videoNews,

          style: TextStyle(fontFamily: fontType),
        ),

      ),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: () async {
          context.read<VideoNewsBloc>().add(FetchVideoNews(refreshIndicator: true, context: context));
        },
        child: BlocBuilder<VideoNewsBloc, VideoNewsState>(
          builder: (context, state) {
            if (state is VideoNewsInitialState ||
                (state is VideoNewsLoadingState && state.videoNewsAll.isEmpty)) {
              return _buildLoadingShimmer();
            } else if (state is VideoNewsErrorState && context.read<VideoNewsBloc>().allNews.isEmpty) {
              return Center(
                child: Text(
                  '${AppLocalizations.of(context)!.error}: ${state.errorMessage}',
                  style: TextStyle(fontFamily: fontType),
                ),
              );
            } else {
              return _buildVideoNewsList(state);
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25, // Taller for video cards
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
        );
      },
    );
  }

  Widget _buildVideoNewsList(VideoNewsState state) {
    final allData = context.read<VideoNewsBloc>().allNews.expand((response) => response.data ?? []).toList();

    if (allData.isEmpty) {
      return EmptyStateWidget(
        title: '${AppLocalizations.of(context)!.videoNews} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
        customImage: Image.asset(
          'assets/img/empty.png',
          width: MediaQueryHelper.screenWidth(context) * 0.65,
        ),
        message: AppLocalizations.of(context)!.noContentAvailable,
        buttonText: AppLocalizations.of(context)!.retry,
        onButtonPressed: () {
          context.read<VideoNewsBloc>().add(FetchVideoNews(initialValue: 1, context: context));
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: allData.length + 1,
      itemBuilder: (context, index) {
        if (index == allData.length) {
          if (state is VideoNewsLoadingMoreState) {
            return Center(child: CircularProgressIndicator(color: AppColors().primaryColor));
          } else {
            return const SizedBox.shrink();
          }
        }

        // Add banner ads every 4 items
        if ( context.read<VideoNewsBloc>().showAds == false) {
          if (index > 0 && index % 4 == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: AdBannerWidget(),
            );
          }
        }

        final dataIndex = index - (index ~/ 4);
        if (dataIndex >= allData.length) return const SizedBox.shrink();

        final item = allData[dataIndex];
        return GestureDetector(
          onTap: () async {

            checkLimitAndNavigate(context, item.slug);
          },
          child: VideoNewsCard(
            id: item.id ?? 0,
            viewCount: item.viewCount ?? 0,
            coverImg: item.image ?? '',
            title: item.title ?? '',
            channelSlug: item.channelSlug ?? '',
            logo: item.channelLogo ?? '',
            publisher: item.channelName ?? '',
            time: item.publishDate ?? '',
            slug: item.slug ?? '',
            postType: item.type ?? "",
            videoThumb: item.videoThumb ?? "",
            video: item.video ?? "",
          ),
        );
      },
    );
  }
}