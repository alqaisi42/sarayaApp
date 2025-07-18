
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
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
  final PageController _pageController = PageController();
  VideoPlayerController? _videoController;
  int _currentIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);
    context.read<VideoNewsBloc>().add(FetchVideoNews(initialValue: 1, context: context));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    if (_pageController.position.pixels == _pageController.position.maxScrollExtent) {
      context.read<VideoNewsBloc>().add(FetchMoreVideoNews(context: context));
    }
  }

  Future<void> _initializeVideo(List<dynamic> data, int index) async {
    if (index < 0 || index >= data.length) return;
    final url = data[index].video ?? '';
    if (url.isEmpty) return;

    final oldController = _videoController;
    final controller = VideoPlayerController.network(url);
    await controller.initialize();
    controller.setLooping(true);
    controller.play();

    setState(() {
      _videoController = controller;
      _isInitialized = true;
    });

    oldController?.dispose();
  }

  void _onPageChanged(int index, List<dynamic> data) {
    setState(() {
      _currentIndex = index;
      _isInitialized = false;
    });
    _initializeVideo(data, index);

    if (index >= data.length - 2) {
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

    if (_videoController == null && allData.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _initializeVideo(allData, 0);
        }
      });
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) => _onPageChanged(index, allData),
      itemCount: allData.length,
      itemBuilder: (context, index) {
        final item = allData[index];
        final bool active = index == _currentIndex;
        return GestureDetector(
          onTap: () async {
            checkLimitAndNavigate(context, item.slug);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: active && _isInitialized
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      )
                    : Image.network(
                        item.videoThumb ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
              Positioned(
                bottom: 80,
                left: 16,
                right: 16,
                child: Text(
                  item.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(item.channelLogo ?? ''),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.channelName ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 16,
                child: ViewCountDisplay(
                  slug: item.slug ?? '',
                  initialViewCount: item.viewCount ?? 0,
                  postImg: item.image ?? '',
                  isNeed: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}