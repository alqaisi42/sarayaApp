// lib/screens/videoNews/video_news.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/screens/videoNews/widgets/VideoItemWidget.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../config/googleAdMob/banner_ad.dart';
import '../../config/helper/empty_state_ui.dart';
import '../../config/helper/helper_functions.dart';
import '../../config/shimmer.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/widgets/custome_dispay_newscard.dart';
import 'videoNewsBloc/video_news_all_event.dart';
import 'videoNewsBloc/video_newsall_bloc.dart';
import 'videoNewsBloc/video_newsall_state.dart';

class VideoNews extends StatefulWidget {
  const VideoNews({super.key});

  @override
  State<VideoNews> createState() => _VideoNewsState();
}

class _VideoNewsState extends State<VideoNews> {
  final PageController _pageController = PageController();
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, YoutubePlayerController> _youtubeControllers = {};
  bool _isReady = false;
  bool _hasPreloaded = false;

  int _currentIndex = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageScroll);

    context.read<VideoNewsBloc>().add(FetchVideoNews(
      initialValue: 1,
      context: context,
    ));


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bloc = context.read<VideoNewsBloc>();
      await Future.delayed(Duration(milliseconds: 50)); // Allow BLoC to populate
      // final allData = bloc.allNews.expand((e) => e.data ?? []).toList();
      //
      // if (allData.isNotEmpty) {
      //   for (int i = 0; i <= 6 && i < allData.length; i++) {
      //     await _initControllerFor(allData[i], i);
      //   }
      //   setState(() => _isReady = true); // 🔥 Trigger build only after controller is ready
      // }
    });
  }



  @override
  void dispose() {
    _pageController.dispose();
    _disposeAllControllers();
    super.dispose();
  }

  void _disposeAllControllers() {
    _videoControllers.values.forEach((c) => c.dispose());
    _videoControllers.clear();
    _youtubeControllers.values.forEach((c) => c.dispose());
    _youtubeControllers.clear();
  }

  void _onPageScroll() {
    if (_pageController.position.pixels == _pageController.position.maxScrollExtent) {
      context.read<VideoNewsBloc>().add(FetchMoreVideoNews(context: context));
    }
  }

  void _onPageChanged(int index, List<dynamic> data) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _currentIndex = index);

      for (int i = index - 7; i <= index + 7; i++) {
        if (i >= 0 && i < data.length) {
          await _initControllerFor(data[i], i);
        }
      }


      _disposeUnusedControllers();
    });
  }

  void _disposeUnusedControllers() {
    final safeRange = List.generate(7, (i) => _currentIndex - 3 + i);

    _videoControllers.keys
        .where((key) => !safeRange.contains(key))
        .toList()
        .forEach((key) {
      _videoControllers[key]?.dispose();
      _videoControllers.remove(key);
    });

    _youtubeControllers.keys
        .where((key) => !safeRange.contains(key))
        .toList()
        .forEach((key) {
      _youtubeControllers[key]?.dispose();
      _youtubeControllers.remove(key);
    });

  }

  Future<void> _initControllerFor(dynamic item, int index) async {
    final String videoUrl = item.video ?? '';
    if (videoUrl.contains("youtube.com") || videoUrl.contains("youtu.be")) {
      if (_youtubeControllers.containsKey(index)) return;
      final controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: false,
          useHybridComposition: true,
        ),
      );
      _youtubeControllers[index] = controller;
    } else {
      if (_videoControllers.containsKey(index)) return;
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();
      controller.setLooping(true);
      if (index == _currentIndex) controller.play();
      _videoControllers[index] = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors().primaryColor,
        title: Text(
          AppLocalizations.of(context)!.videoNews,
          style: const TextStyle(fontFamily: fontType,fontSize: 16,color: AppColors.whiteColor),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: () async {
          context.read<VideoNewsBloc>().add(
            FetchVideoNews(refreshIndicator: true, context: context),
          );
          setState(() {
            _isReady = false;
            _hasPreloaded = false;
            _disposeAllControllers();
          });
        },
        child: BlocBuilder<VideoNewsBloc, VideoNewsState>(
          builder: (context, state) {
            // 🌀 Loading shimmer for first fetch
            if (state is VideoNewsInitialState ||
                (state is VideoNewsLoadingState &&
                    state.videoNewsAll.isEmpty)) {
              return ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) => ShimmerWidget(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.zero,
                ),
              );
            }

            final allData = context
                .read<VideoNewsBloc>()
                .allNews
                .expand((e) => e.data ?? [])
                .toList();

            // 🧠 Preload controllers after BLoC populates data
            if (!_hasPreloaded && allData.isNotEmpty) {
              _hasPreloaded = true;

              Future.microtask(() async {
                for (int i = 0; i <= 6 && i < allData.length; i++) {
                  await _initControllerFor(allData[i], i);
                }
                setState(() => _isReady = true);
              });

              return const Center(child: CircularProgressIndicator());
            }

            // 🚫 Empty state fallback
            if (allData.isEmpty) {
              return EmptyStateWidget(
                title:
                '${AppLocalizations.of(context)!.videoNews} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
                customImage: Image.asset(
                  'assets/img/empty.png',
                  width: MediaQueryHelper.screenWidth(context) * 0.65,
                ),
                message: AppLocalizations.of(context)!.noContentAvailable,
                buttonText: AppLocalizations.of(context)!.retry,
                onButtonPressed: () => context.read<VideoNewsBloc>().add(
                  FetchVideoNews(initialValue: 1, context: context),
                ),
              );
            }

            // 🕒 Wait until controllers are ready
            if (!_isReady) {
              return const Center(child: CircularProgressIndicator());
            }

            // 🎞️ Final PageView
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) => _onPageChanged(index, allData),
              itemCount: allData.length,
              itemBuilder: (context, index) => VideoItemWidget(
                item: allData[index],
                videoController: _videoControllers[index],
                youtubeController: _youtubeControllers[index],
                isActive: index == _currentIndex,
                pageController: _pageController,
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }
}