
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:remixicon/remixicon.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../Model/detail_page_model.dart';
import '../../../../bloc/emojiBloc/emojireact_user__event.dart';
import '../../../../bloc/emojiBloc/emojireact_user_bloc.dart';

import '../../../../bloc/fontSizeBloc/font_size_bloc.dart';
import '../../../../bloc/fontSizeBloc/font_size_state.dart';
import '../../../../bloc/fullScreenModeBloc/full_screen_mode_bloc.dart';
import '../../../../bloc/fullScreenModeBloc/full_screen_mode_state.dart';
import '../../../../bloc/languageBloc/language_switcher_bloc.dart';
import '../../../../bloc/totalReactionBloc/total_reaction_bloc.dart';
import '../../../../bloc/totalReactionBloc/total_reaction_event.dart';
import '../../../../bloc/viewCountBloc/view_count_bloc.dart';
import '../../../../bloc/viewCountBloc/view_count_event.dart';
import '../../../../config/colors.dart';
import '../../../../config/constants.dart';

import '../../../../config/googleAdMob/banner_ad.dart';
import '../../../../config/googleAdMob/interstitial_ad.dart';
import '../../../../config/helper/helper_functions.dart';
import '../../../../config/hiveLocalStorage/hive_storage.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../screens/profile/fontSizeSettings/font_size.dart';
import '../../fullscreen_image_viewer.dart';
import '../../favorite_button.dart';
import '../../webView/web_view.dart';
import '../../youtubevideos.dart';
import '../commentCount/commen_count_display.dart';

import '../relatedPost/related_post.dart';
import '../translator/translated_text.dart';

import '../userAction/user_action.dart';
import '../userReaction/reaction_emoji_user.dart';
import '../userReaction/user_reaction_display.dart';
import '../videoNews/video_news.dart';

final _interstitialAdKey = GlobalKey<InterstitialAdWidgetState>();

class DetailpageData extends StatefulWidget {
  final String title;
  final String channelName;
  final String channelLogo;
  final String description;
  final String image;
  final String? pubDate;
  final String? emojiType;
  final bool userHasReacted;
  final int commentCount;
  final int viewCount;
  final String id;
  final String channelSlug;
  final String slug;
  final String publishDate;
  final String resource;
  final String postType;
  final String videoUrl;
  final String newsLanguageCode;
  final String videoThumb;
  final Map<int, UserReaction>? userReactList;
  final VoidCallback? onAction;
  final Function(bool isFullscreen) onFullscreenChange;
  final List? realatedPost;
  final bool isFullscreenCheck;
  final bool isAdsFree;
  final VoidCallback onFullScreenToggle;

  const DetailpageData(
      {super.key,
        required this.title,
        required this.newsLanguageCode,
        required this.isAdsFree,
        required this.channelName,
        required this.channelLogo,
        required this.description,
        required this.image,
        required this.pubDate,
        required this.commentCount,
        required this.viewCount,
        required this.id,
        required this.channelSlug,
        required this.slug,
        required this.publishDate,
        required this.onAction,
        required this.resource,
        required this.emojiType,
        required this.userHasReacted,
        required this.userReactList,
        required this.videoThumb,
        required this.postType,
        required this.videoUrl,
        required this.realatedPost,
        required this.onFullscreenChange,
        required this.isFullscreenCheck,
        required this.onFullScreenToggle});

  @override
  State<DetailpageData> createState() => _DetailpageDataState();
}

  class _DetailpageDataState extends State<DetailpageData> {
    late bool isReading = false;
    late double textSize = 17;

    String postTitle = "";

    bool isUserLogged = false;
    late VideoPlayerController _controller;
    bool _isPlaying = false;

    Duration _duration = Duration.zero;
    Duration _position = Duration.zero;
    bool _showControls = true;
    Timer? _hideTimer;
    bool _isBuffering = true;
    bool _isSeeking = false;
    bool _isVideoCompleted = false;



    @override
    void initState() {
      super.initState();
      isLogged();
      postTitle = widget.title;

      storeDetailPageLanguage();

      _initializeVideo();

      context.read<ViewCountBloc>().add(
          UpdateViewCount(slug: widget.slug, apiViewCount: widget.viewCount));
      Future.delayed(Duration(seconds: 20), () {
        _interstitialAdKey.currentState?.showAd();
      });

      context.read<EmojiReactUserBloc>().add(InitialUserEmoji(initialUserReactData: widget.userReactList));
      context.read<TotalReactionCountBloc>().add(InitialTotalCount(
          initialCountData: widget.userReactList,
          userHasReacted: widget.userHasReacted));
    }


    Future<void> storeDetailPageLanguage() async {
      final hiveStorage = HiveStorage();


      if(widget.newsLanguageCode.isNotEmpty){
        await hiveStorage.storeLanguageCode(widget.newsLanguageCode);
      } else {
        await hiveStorage.storeLanguageCode('en');
      }
    }
    void _initializeVideo() {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          setState(() {
            _duration = _controller.value.duration;
            _isBuffering = false;
            _controller.play();
            _isPlaying = true;
            _isVideoCompleted = false;
            _startHideTimer();
          });
        })
        ..addListener(() {
          final bool isEndOfVideo = _controller.value.position >= _controller.value.duration;

          if (isEndOfVideo && !_isVideoCompleted) {
            setState(() {
              _isVideoCompleted = true;
              _isPlaying = false;
              _showControls = true;
            });
          }

          // Update position and buffering state
          final newPosition = _controller.value.position;
          final newBuffering = _controller.value.isBuffering;

          // Only update if there's a significant change or if we're not seeking
          if (!_isSeeking || (_position != newPosition || _isBuffering != newBuffering)) {
            setState(() {
              _position = newPosition;
              _isBuffering = newBuffering;

              // If we were seeking and buffering is done, reset seeking state
              if (_isSeeking && !newBuffering) {
                _isSeeking = false;
              }
            });
          }
        });
    }
    // void _initializeVideo() {
    //   _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
    //     ..initialize().then((_) {
    //       setState(() {
    //         _duration = _controller.value.duration;
    //         _isBuffering = false;
    //         _controller.play();
    //         _isPlaying = true;
    //         _isVideoCompleted = false;
    //         _startHideTimer();
    //       });
    //     })
    //     ..addListener(() {
    //       final bool isEndOfVideo = _controller.value.position >= _controller.value.duration;
    //
    //       if (isEndOfVideo && !_isVideoCompleted) {
    //         setState(() {
    //           _isVideoCompleted = true;
    //           _isPlaying = false;
    //           _showControls = true;
    //         });
    //       }
    //
    //       setState(() {
    //         _position = _controller.value.position;
    //         _isBuffering = _controller.value.isBuffering;
    //       });
    //     });
    // }

    void _onVideoComplete(bool completed) {
      setState(() {
        _isVideoCompleted = completed;
      });
    }

    void _startHideTimer() {
      _hideTimer?.cancel();
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }

    void _toggleControls() {
      setState(() {
        _showControls = !_showControls;
      });
      if (_showControls && _isPlaying) {
        _startHideTimer();
      }
    }

    // void _seekForward() async {
    //   setState(() {
    //     _isSeeking = true;
    //   });
    //   final newPosition = _position + const Duration(seconds: 10);
    //   await _controller.seekTo(newPosition);
    //   setState(() {
    //     _isSeeking = false;
    //   });
    // }

    void _seekForward() async {
      if (_isSeeking) return; // Prevent multiple seek operations

      setState(() {
        _isSeeking = true;
      });

      try {
        final newPosition = _position + const Duration(seconds: 10);
        final maxPosition = _duration;
        final seekPosition = newPosition > maxPosition ? maxPosition : newPosition;

        await _controller.seekTo(seekPosition);

        // Add a small delay to ensure the seek operation is complete
        await Future.delayed(const Duration(milliseconds: 100));

      } catch (e) {
        log('Error seeking forward: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isSeeking = false;
          });
        }
      }
    }
    void _seekBackward() async {
      if (_isSeeking) return; // Prevent multiple seek operations

      setState(() {
        _isSeeking = true;
      });

      try {
        final newPosition = _position - const Duration(seconds: 10);
        final seekPosition = newPosition < Duration.zero ? Duration.zero : newPosition;

        await _controller.seekTo(seekPosition);


        await Future.delayed(const Duration(milliseconds: 100));

      } catch (e) {
        log('Error seeking backward: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isSeeking = false;
          });
        }
      }
    }

    // void _seekBackward() async {
    //   setState(() {
    //     _isSeeking = true;
    //   });
    //   final newPosition = _position - const Duration(seconds: 10);
    //   await _controller.seekTo(newPosition);
    //   setState(() {
    //     _isSeeking = false;
    //   });
    // }

    String _formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$seconds";
    }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      final route = ModalRoute.of(context);
      if (route != null && !route.isCurrent) {
        _controller.pause();
        _isPlaying = false;
      }
    }

    @override
    void dispose() {
      TextToSpeechHelper.dispose();
      _controller.pause();
      _hideTimer?.cancel();
      _controller.dispose();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);

      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final selectedFontSize = context.read<FontSizeBloc>().state;

    final double customTextSize = (selectedFontSize is FontSizeLoaded)
        ? selectedFontSize.fontSize.size
        : 16.0;


    return Column(
      children: [
        if (widget.isAdsFree == false)
          InterstitialAdWidget(
            key: _interstitialAdKey,
            onAdDismissed: () {
              log('Ad was dismissed');
            },
          ),
        widget.postType == "video" && widget.videoUrl.isNotEmpty
            ? isYouTubeLink(widget.videoUrl)
            ? SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 9 / 16, // 16:9 ratio
          child: YoutubePlayerDemoApp(
            videoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
          ),
        )
            : NewsVideoPlayer(
          controller: _controller,
          isFullscreen: widget.isFullscreenCheck,
          isPlaying: _isPlaying,
          isBuffering: _isBuffering,
          isSeeking: _isSeeking,
          showControls: _showControls,
          position: _position,
          duration: _duration,
          toggleControls: _toggleControls,
          seekForward: _seekForward,
          seekBackward: _seekBackward,
          togglePlayPause: () {
            setState(() {
              _isPlaying = !_isPlaying;
              _isPlaying ? _controller.play() : _controller.pause();
              if (_isPlaying) {
                _startHideTimer();
              }
            });
          },
          toggleFullscreen: widget.onFullScreenToggle,
          formatDuration: _formatDuration,
          startHideTimer: _startHideTimer,
          onVideoComplete: _onVideoComplete,
          isVideoCompleted: _isVideoCompleted,
          context: context,
        )
            : GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(

                builder: (context) => FullScreenImageViewer(
                  imageUrl: widget.postType == "video"
                      ? widget.videoThumb
                      : widget.image,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(
              left: MediaQueryHelper.screenWidth(context) * 0.02,
              right: MediaQueryHelper.screenWidth(context) * 0.02,
              top: MediaQueryHelper.screenHeight(context) * 0.01,
            ),
            width: double.infinity,
            height: MediaQueryHelper.screenHeight(context) * 0.28,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageUtils.networkImage(
                widget.postType == "video"
                    ? widget.videoThumb
                    : widget.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),

        //===============================================================  Content Details

        BlocBuilder<FullScreenBloc, FullScreenState>(
            builder: (context, state) {
              return state.isFullScreen
                  ?  SizedBox.shrink()
                  : Column(
                children: [
                  SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.023),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
                    ),
                    child: Column(
                      children: [
                        TranslatedText(
                          style:  TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: fontType,
                          ), text: widget.title,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.023),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context)
                                .push("/customNewsPage/${widget.channelSlug}");
                          },
                          child: Row(
                            children: [
                              // SizedBox(
                              //   height: MediaQueryHelper.screenHeight(context) *
                              //       0.037,
                              //   width: MediaQueryHelper.screenWidth(context) *
                              //       0.17,
                              //   // clipBehavior: Clip.hardEdge,
                              //   child: ClipRRect(
                              //       borderRadius: BorderRadius.circular(
                              //           5), // Match radius here
                              //       child: ImageUtils.networkImage(
                              //           widget.channelLogo,
                              //           fit: BoxFit.cover)),
                              // ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: ImageUtils.networkImageProvider(widget.channelLogo),
                                    alignment: Alignment.center,
                                  ),
                                  color: Colors.grey[200],
                                ),
                                child: ClipOval(
                                  child: Image(
                                    image: ImageUtils.networkImageProvider(widget.channelLogo),
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,


                                  ),
                                ),
                              ),


                              SizedBox(
                                  width: MediaQueryHelper.screenWidth(context) *
                                      0.02),
                              Text(
                                '${AppLocalizations.of(context)!.by} ${widget.channelName}',
                                style:  TextStyle(
                                  fontSize: 16,
                                  color:  AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
                                  fontFamily: fontType,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          widget.publishDate,
                          style:  TextStyle(
                            fontSize: 16,
                            color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
                            fontFamily: fontType,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.023),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQueryHelper.screenWidth(context) * 0.04,
                        left: MediaQueryHelper.screenWidth(context) * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReactionDisplay(
                          slug: widget.slug,
                        ),

                        CommentCountDisplay(
                          slug: widget.slug,
                          initialViewCount: widget.commentCount,
                          id: widget.id,
                          isShowCount: true,
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.023),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CommentCountDisplay(
                          slug: widget.slug,
                          initialViewCount: widget.commentCount,
                          id: widget.id,
                          isShowCount: false,
                        ),
                        ReactionEmoji(
                          slug: widget.slug,
                          initialReaction: widget.emojiType.toString(),
                          initialIsLike: widget.userHasReacted,
                        ),
                        UserAction(
                          actionIcon: HeroiconsOutline.eye,
                          txt: AppLocalizations.of(context)!.view,
                          numVal: widget.viewCount,
                        ),
                        GestureDetector(
                          onTap: () {
                            showFontSizePopup(context);
                          },
                          child: UserAction(
                            actionIcon: Remix.text_snippet,
                            txt: AppLocalizations.of(context)!.textSize,
                            numVal: 0,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isReading = !isReading;
                            });
                            if (isReading) {
                              final languageCode = context.read<LanguageBloc>().state.locale.languageCode;
                              String fullText =
                                  "$postTitle. ${widget.description}";
                              TextToSpeechHelper.setLanguage(languageCode);

                              TextToSpeechHelper.speak(
                                fullText,
                                    (newState) {
                                  if (mounted) {
                                    setState(() {
                                      isReading = newState;
                                    });
                                  }
                                },
                              );
                            } else {
                              TextToSpeechHelper.stop();
                            }
                          },
                          child: UserAction(
                            actionIcon: isReading
                                ? HeroiconsSolid.stop
                                : HeroiconsOutline.speakerWave,
                            txt: AppLocalizations.of(context)!.speakLoud,
                            numVal: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // PostReactButton(),
                  SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.023),
                  if (widget.isAdsFree == false) ...[
                    AdBannerWidget(),
                  ],


                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
                    ),
                    child: TranslatedText(
                      style:  TextStyle(
                        fontSize: customTextSize,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontType,
                      ), text: widget.description,
                    ),
                  ),
                  SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.023),


                  if(widget.resource.isNotEmpty)...[
                    Container(
                      height: 36,
                      width: 240 ,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          final String resource = widget.resource;
                          final String video = widget.videoUrl;
                          final String normalizedUrl = normalizeUrl(video);
                          final bool isYouTube = normalizedUrl.contains('youtube.com') || normalizedUrl.contains('youtu.be');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(
                                url: isYouTube ? normalizedUrl : widget.resource,
                                title: widget.channelName,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.clickHereToReadMore,
                              style: TextStyle(fontFamily: fontType),
                            ),
                            SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.01),
                            Icon(HeroiconsSolid.arrowTopRightOnSquare,color: AppColors.whiteColor,),
                          ],
                        ),
                      ),
                    )
                  ]
                  ,



                  RelatedPostDisplay(
                    realtedPost: widget.realatedPost,
                    currentPostslug: widget.slug,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              );

            })
      ],
    );
  }

    bool isYouTubeLink(String url) {
      return url.contains("youtube.com") || url.contains("youtu.be");
    }


  }