// lib/screens/videoNews/widgets/video_item_widget.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../config/colors.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/widgets/custome_dispay_newscard.dart';

class VideoItemWidget extends StatefulWidget {
  final dynamic item;
  final VideoPlayerController? videoController;
  final YoutubePlayerController? youtubeController;
  final bool isActive;
  final PageController pageController;
  final int index;


  const VideoItemWidget({
    super.key,
    required this.item,
    this.videoController,
    this.youtubeController,
    required this.isActive,
    required this.pageController,
    required this.index,
  });

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> with AutomaticKeepAliveClientMixin {
  bool _muted = false;
  Timer? _playbackDelayTimer;
  double _dragDistance = 0;
  bool _hasTriggeredSwipe = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _handlePlayback();
  }

  @override
  void didUpdateWidget(covariant VideoItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handlePlayback();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_hasTriggeredSwipe) return;

    final double dy = details.delta.dy;

    if (dy < -2) {
      // ⬆️ Swipe up: Next page
      _hasTriggeredSwipe = true;
      widget.pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else if (dy > 2) {
      // ⬇️ Swipe down: Previous page
      _hasTriggeredSwipe = true;
      widget.pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _hasTriggeredSwipe = false; // reset for next gesture
  }

  // void _handlePanEnd(DragEndDetails details) {
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   if (_dragDistance < -screenHeight * 0.25) {
  //     // 🟢 Swipe up: Go to next page
  //     widget.pageController.nextPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  //   _dragDistance = 0; // reset for next gesture
  // }


  void _handlePlayback() {
    _playbackDelayTimer?.cancel();

    if (widget.isActive) {
      _playbackDelayTimer = Timer(const Duration(milliseconds: 500), () {
        widget.videoController?.play();
        widget.youtubeController?.play();

        // 🧩 Add video end listener (for non-YouTube)
        widget.videoController?.removeListener(_checkVideoEnd);
        widget.videoController?.addListener(_checkVideoEnd);

        // 🧩 Add YouTube end listener
        widget.youtubeController?.removeListener(_checkYoutubeEnd);
        widget.youtubeController?.addListener(_checkYoutubeEnd);
      });
    } else {
      widget.videoController?.pause();
      widget.youtubeController?.pause();

      // 🧹 Cleanup listeners if not active
      widget.videoController?.removeListener(_checkVideoEnd);
      widget.youtubeController?.removeListener(_checkYoutubeEnd);
    }
  }


  void _checkVideoEnd() {
    final controller = widget.videoController;
    if (controller != null &&
        controller.value.position >= controller.value.duration &&
        controller.value.duration.inMilliseconds > 0) {
      controller.removeListener(_checkVideoEnd); // Prevent multiple triggers
      widget.pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }


  void _videoEndListener() {
    final controller = widget.videoController;
    if (controller != null && controller.value.position >= controller.value.duration) {
      // Scroll to next page
      if (widget.pageController.hasClients) {
        widget.pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }


  @override
  void dispose() {
    _playbackDelayTimer?.cancel();
    widget.videoController?.removeListener(_checkVideoEnd);
    super.dispose();
  }


  void _checkYoutubeEnd() {
    final ytController = widget.youtubeController;
    if (ytController != null && ytController.value.hasPlayed) {
      if (ytController.value.playerState == PlayerState.ended) {
        ytController.removeListener(_checkYoutubeEnd);
        widget.pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }


  Future<void> _handleReadMore() async {
    widget.videoController?.pause();
    widget.videoController?.dispose();
    widget.youtubeController?.pause();
    widget.youtubeController?.dispose();
    await checkLimitAndNavigate(context, widget.item.slug);
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
      widget.videoController?.setVolume(_muted ? 0.0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String videoUrl = widget.item.video ?? '';
    final isYouTube = videoUrl.contains("youtube.com") || videoUrl.contains("youtu.be");

    final bool isVideoReady = widget.videoController?.value.isInitialized ?? false;
    final bool isYouTubeReady = widget.youtubeController != null;

    return VisibilityDetector(
      key: Key('video-item-${widget.index}'),
      onVisibilityChanged: (info) {
        final visibleFraction = info.visibleFraction;
        if (visibleFraction >= 0.9 && widget.isActive) {
          widget.videoController?.play();
          widget.youtubeController?.play();
        } else {
          widget.videoController?.pause();
          widget.youtubeController?.pause();
        }
      },
      child: GestureDetector(
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child:Stack(
        children: [
          // 🎞 Video or YouTube player with fade-in
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: (isYouTube && isYouTubeReady) || (!isYouTube && isVideoReady) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: isYouTube
                  ? (widget.youtubeController != null
                  ? YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: widget.youtubeController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppColors().primaryColor,
                ),
                builder: (context, player) => player,
              )
                  : const Center(child: CircularProgressIndicator()))
                  : (isVideoReady
                  ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: widget.videoController!.value.size.width,
                  height: widget.videoController!.value.size.height,
                  child: VideoPlayer(widget.videoController!),
                ),
              )
                  : const Center(child: CircularProgressIndicator())),
            ),
          ),

          // 🎨 Gradient overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 230,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),
          ),

          // 📄 Title and read more
          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _handleReadMore,
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: Text((AppLocalizations.of(context)!.readMore), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 🏷 Channel info
          Positioned(
            bottom: 13,
            right: 16,
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    color: Colors.white,
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'assets/img/new_logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.item.channelName ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // 👁 View Count


          Positioned(
            bottom: 10,
            left: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.blue),
                  onPressed: _shareVideo,
                  tooltip: AppLocalizations.of(context)!.share,
                ),
                const SizedBox(width: 8),
                  ViewCountDisplay(
                    slug: widget.item.slug ?? '',
                    initialViewCount: widget.item.viewCount ?? 0,
                    postImg: widget.item.image ?? '',
                    isNeed: false,
                  ),

              ],
            ),
          ),



        ],
      )),
    );
  }



  void _shareVideo() {
    final String videoUrl = widget.item.video ?? '';
    final String title = widget.item.title ?? 'Untitled';
    final String description = widget.item.description ?? '';
    const String appName = 'وكالة سرايا الاخبارية';

    final String content = '''
$title

$description

📺 شاهد الآن:
$videoUrl

📱 بواسطة $appName
''';

    Share.share(content);
  }
}