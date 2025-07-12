
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/constants.dart';
import 'package:video_player/video_player.dart';

import '../../../../bloc/fullScreenModeBloc/full_screen_mode_bloc.dart';
import '../../../../bloc/fullScreenModeBloc/full_screen_mode_state.dart';
import '../../../../config/colors.dart';
import '../../../../l10n/app_localizations.dart';





class NewsVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isFullscreen;
  final bool isPlaying;
  final bool isBuffering;
  final bool isSeeking;
  final bool showControls;
  final Duration position;
  final Duration duration;
  final Function toggleControls;
  final Function seekForward;
  final Function seekBackward;
  final Function togglePlayPause;
  final Function toggleFullscreen;
  final Function formatDuration;
  final Function startHideTimer;
  final Function onVideoComplete;
  final bool isVideoCompleted;
  final BuildContext context;

  const NewsVideoPlayer({
    super.key,
    required this.controller,
    required this.isFullscreen,
    required this.isPlaying,
    required this.isBuffering,
    required this.isSeeking,
    required this.showControls,
    required this.position,
    required this.duration,
    required this.toggleControls,
    required this.seekForward,
    required this.seekBackward,
    required this.togglePlayPause,
    required this.toggleFullscreen,
    required this.formatDuration,
    required this.startHideTimer,
    required this.onVideoComplete,
    required this.isVideoCompleted,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<FullScreenBloc, FullScreenState>(
        builder: (context, state) {
          return SizedBox(
            width: state.isFullScreen ? MediaQuery.of(context).size.width : null,
            height: state.isFullScreen ? MediaQuery.of(context).size.height : null,
            child: state.isFullScreen
                ? _buildPlayerContent()
                : AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildPlayerContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerContent() {
    return GestureDetector(
      onTap: () => toggleControls(),
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),
            if (showControls)
              Container( // Transparent black overlay
                color: Colors.black.withValues(alpha:0.4),
              ),
            if (showControls) _buildControls(),
            if (showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildProgressBarWithFullscreen(),
              ),
            if (showControls)
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.speed, color: Colors.white),
                  onPressed: () => showPlaybackSpeedSheet(context),
                ),
              ),
            // Added back button
            BlocBuilder<FullScreenBloc, FullScreenState>(
              builder: (context, state) {

                if (showControls && state.isFullScreen) {
                  return Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () => toggleFullscreen(),
                    ),
                  );
                }


                return const SizedBox.shrink();
              },
            )

          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    // Show loading only when actually buffering, not just seeking
    final bool showLoading = isBuffering && !controller.value.isInitialized ||
        (isSeeking && isBuffering);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
          onPressed: isSeeking ? null : () => seekBackward(),
        ),
        SizedBox(
          width: 56,
          height: 56,
          child: showLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : IconButton(
            icon: Icon(
              (isPlaying ? Icons.pause : Icons.play_arrow),
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              togglePlayPause();
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
          onPressed: isSeeking ? null : () => seekForward(),
        ),
      ],
    );
  }

  // Widget _buildControls() {
  //   final bool showLoading = isBuffering || isSeeking;
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       IconButton(
  //         icon: const Icon(Icons.replay_10, color: Colors.white,size: 40,),
  //         onPressed: showLoading ? null : () => seekBackward(),
  //       ),
  //       SizedBox(
  //         width: 56,
  //         height: 56,
  //         child: showLoading
  //             ?  Center(
  //           child: CircularProgressIndicator(
  //             color: Colors.white,
  //             strokeWidth: 2,
  //           ),
  //         )
  //             : IconButton(
  //           icon: Icon(
  //             (isPlaying ? Icons.pause : Icons.play_arrow),
  //             color: Colors.white,
  //             size: 40,
  //           ),
  //           onPressed: () {
  //             togglePlayPause();
  //           },
  //         ),
  //       ),
  //       IconButton(
  //         icon:  Icon(Icons.forward_10, color: Colors.white,size: 40,),
  //         onPressed: showLoading ? null : () => seekForward(),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildProgressBarWithFullscreen() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                formatDuration(position),
                style: const TextStyle(color: Colors.white,fontFamily: fontType),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 3,
                    activeTrackColor: AppColors().primaryColor,
                    thumbColor: AppColors.whiteColor,
                    inactiveTrackColor: AppColors.whiteColor.withValues(alpha:0.9),
                  ),
                  child: Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      controller.seekTo(Duration(seconds: value.toInt()));
                      startHideTimer();
                    },
                    onChangeEnd: (value) async {
                      await controller.seekTo(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
              ),
              Text(
                formatDuration(duration),
                style: const TextStyle(color: Colors.white,fontFamily: fontType),
              ),
              BlocBuilder<FullScreenBloc, FullScreenState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      state.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: () => toggleFullscreen(),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void showPlaybackSpeedSheet(BuildContext context) async {
    final speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    final selectedSpeed = controller.value.playbackSpeed;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>  Padding(
          padding:  EdgeInsets.all(0),
          child: Card(
            child: SingleChildScrollView(
              child: Column(

                children: [
                   Text(
                    AppLocalizations.of(context)!.playbackSpeed,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: fontType),
                  ),
                   Divider(thickness: 0.5, color: Colors.grey),
                  ...speeds.map(
                        (speed) => ListTile(
                      leading: Icon(
                        speed == selectedSpeed ? Icons.check : null,
                        color: Colors.blue,
                      ),
                      title: Text(speed == 1.0 ? AppLocalizations.of(context)!.normal : '${speed}x'),
                      onTap: () {
                        controller.setPlaybackSpeed(speed);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  }


}




