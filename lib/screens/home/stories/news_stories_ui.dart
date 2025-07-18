import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';

import 'package:story/story_page_view.dart';
import '../../../Model/stories_model.dart';
import '../../../bloc/getSettingsBloc/get_settings_bloc.dart';
import '../../../bloc/subscriptionCountBloc/subscription_count_bloc.dart';
import '../../../bloc/subscriptionCountBloc/subscription_count_event.dart';
import '../../../bloc/subscriptionCountBloc/subscription_count_state.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/hiveLocalStorage/hive_storage.dart';


class StoryCard extends StatelessWidget {
  final String firstSlideImage;
  final String title;
  final String? topic;

  const StoryCard({
    super.key,
    required this.firstSlideImage,
    required this.title,
    this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:  EdgeInsets.all(4),
        child: SizedBox(
          width: MediaQueryHelper.screenWidth(context) * 0.29,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Story Image
                if (firstSlideImage.isNotEmpty)
                 ImageUtils.networkImage(firstSlideImage),

                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha:0.7),
                      ],
                    ),
                  ),
                ),

                // Topic Name (Top Left)
                if (topic != null && topic!.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,

                    child: Container(
                      width: MediaQueryHelper.screenWidth(context) * 0.18,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors().primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        topic!,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                // Story title (Bottom)
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

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

String extractFinalUrl(String inputUrl) {
  final regex = RegExp(r'(https?:\/\/[^\s]+)', caseSensitive: false);
  final matches = regex.allMatches(inputUrl);

  // Return the second match if it exists
  if (matches.length > 1) {
    return inputUrl.substring(matches.elementAt(1).start);
  }

  // Otherwise return original if only one valid URL is found
  return inputUrl;
}

class StoryPage extends StatefulWidget {
  final int initialPage;
  final List<Stories> stories;

  const StoryPage({
    super.key,
    required this.initialPage,
    required this.stories,
  });

  @override
  StoryPageState createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  late ValueNotifier<bool> _showContent;
  int _currentPageIndex = 0;
  int _currentStoryIndex = 0;


  late AnimationController _dismissAnimationController;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
    _showContent = ValueNotifier<bool>(true);
    _currentPageIndex = widget.initialPage;

    _dismissAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }



  void handlePageChange(int pageIndex) async {
    // final getSettingsBloc = context.read<GetSettingsBloc>();
    // final String? freeTrialStoryLimit = getSettingsBloc.freeTrialStoryLimit();

    // if(freeTrialStoryLimit != "-1"){
    //   final features = await HiveStorage().getFreePlanFeatures();
    //   final userToken = await HiveStorage().getToken();

    //   // Check if user has an active plan
    //   final bool isActivePlan = features?['isActivePlan'] ?? false;

    //   if (userToken != null && userToken.data != null && userToken.data!.token != null) {
    //     if (isActivePlan) {
    //       if (mounted) {
    //         context.read<SubscriptionCountBloc>().add(PostSubscriptionCount(countType: 'story'));
    //       }
    //     }
    //   }

    //   if (isActivePlan) {
    //     // For users with active subscription
    //     final String? maxStories = features?['storyLimit'];
    //     final String? usedStories = features?['storyCount'];

    //     if (maxStories != null && usedStories != null) {
    //       final int maxLimit = int.parse(maxStories);
    //       final int usedCount = int.parse(usedStories);

    //       if (usedCount >= maxLimit) {
    //         // User has reached their plan's story limit
    //         if (mounted) {
    //           Navigator.pop(context);
    //           showDialog(
    //             context: context,
    //             barrierDismissible: false,
    //             builder: (BuildContext context) {
    //               return LimitReachedPopup(
    //                 context: context,
    //                 type: 'story',
    //                 hasActivePlan: true,
    //               );
    //             },
    //           );
    //         }
    //         return;
    //       }
    //     }

    //     _currentPageIndex = pageIndex;
    //     _currentStoryIndex = 0;
    //     _triggerAnimation();
    //     return;
    //   } else {
    //     // For free users - keeping your existing logic
    //     final String? articleLimitStr = features?['storyLimit'];

    //     if (articleLimitStr == null || int.parse(articleLimitStr) <= 0) {
    //       void showArticleLimitPopup(BuildContext context) {
    //         showDialog(
    //           context: context,
    //           barrierDismissible: false,
    //           builder: (BuildContext context) {
    //             return LimitReachedPopup(
    //               context: context,
    //               type: 'storyLimit',
    //               onActionPressed: () {},
    //             );
    //           },
    //         );
    //       }

    //       if(mounted){
    //         Navigator.pop(context);
    //         showArticleLimitPopup(context);
    //       }
    //       return;
    //     }

    //     final updateVal = int.parse(articleLimitStr) - 1;

    //     await HiveStorage().updateFreePlanFeatures({
    //       'storyLimit': updateVal.toString(),
    //     });

    //     _currentPageIndex = pageIndex;
    //     _currentStoryIndex = 0;
    //     _triggerAnimation();
    //   }
    // }

    // Directly allow page change without restriction
    _currentPageIndex = pageIndex;
    _currentStoryIndex = 0;
    _triggerAnimation();
  }



  void _handleStoryChange(int pageIndex, int storyIndex) {
    if (pageIndex == _currentPageIndex && storyIndex != _currentStoryIndex) {

      _currentStoryIndex = storyIndex;
      _triggerAnimation();
    }
  }

  void _triggerAnimation() {
    _showContent.value = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _showContent.value = true;
      }
    });
  }

  void _resetPosition() {
    _dismissAnimationController.reverse().then((_) {
      setState(() {
        _dragOffset = 0;
      });
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionCountBloc, SubscriptionCountState>(
      listener: (context, state) {
        if (state is SubscriptionCountError) {

          CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragOffset += details.primaryDelta!;
          });
        },
        onVerticalDragEnd: (details) {
          if (_dragOffset.abs() > 200 || details.primaryVelocity! > 500) {
            _dismissAnimationController.forward().then((_) {
              Navigator.pop(context);
            });
          } else {
            _resetPosition();
          }
        },
        child: AnimatedBuilder(
          animation: _dismissAnimationController,
          builder: (context, child) {
            double dragPercentage = (_dragOffset / 500).clamp(-1.0, 1.0);
            double scaleValue = 1.0 - (dragPercentage.abs() * 0.2);
            double opacityValue = 1.0 - (dragPercentage.abs() * 0.3);

            return Transform.translate(
              offset: Offset(0, _dragOffset * 0.5),
              child: Transform.scale(
                scale: scaleValue, // Shrinking effect
                child: Opacity(
                  opacity: opacityValue.clamp(0.6, 1.0),
                  child: child,
                ),
              ),
            );
          },
          child: StoryPageView(
            itemBuilder: (context, pageIndex, storyIndex) {
              final story = widget.stories[pageIndex];
              if (story.storySlides == null || storyIndex >= story.storySlides!.length) {
                return const SizedBox.shrink();
              }

              final currentSlide = story.storySlides![storyIndex];

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleStoryChange(pageIndex, storyIndex);
              });

              return Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: Colors.black),
                  ),
                  if (currentSlide.image != null)
                    Positioned.fill(
                      child: ClipRect(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _showContent,
                          builder: (context, isVisible, _) {
                            return AnimatedImageStoryContent(
                              isVisible: isVisible,
                              imageProvider: NetworkImage(extractFinalUrl(currentSlide.image!)),
                              duration: currentSlide.animationDetails?.image?.duration,
                              delay: currentSlide.animationDetails?.image?.delay,
                              animationType: currentSlide.animationDetails?.image?.type,
                            );
                          },
                        ),
                      ),
                    ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 150,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha:  0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 700,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha:  0.9),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                  if (currentSlide.description != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _showContent,
                          builder: (context, isVisible, _) {
                            return Column(
                              children: [
                                AnimatedTextContent(
                                  text: currentSlide.title!,
                                  isVisible: isVisible,
                                  duration: currentSlide.animationDetails?.title?.duration,
                                  delay: currentSlide.animationDetails?.title?.delay,
                                  animationType: currentSlide.animationDetails?.title?.type,
                                  fontSizeVal: 17,
                                  colorVal: AppColors().storiesTitle,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(
                                  height: MediaQueryHelper.screenHeight(context) * 0.02,
                                ),
                                AnimatedTextContent(
                                  text: currentSlide.description!,
                                  isVisible: isVisible,
                                  duration: currentSlide.animationDetails?.description?.duration,
                                  delay: currentSlide.animationDetails?.description?.delay,
                                  animationType: currentSlide.animationDetails?.description?.type,
                                  fontSizeVal: 15,
                                  colorVal: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
            onPageChanged: (pageIndex) {
              handlePageChange(pageIndex);


            },
            indicatorAnimationController: indicatorAnimationController,
            initialPage: widget.initialPage,
            initialStoryIndex: (pageIndex) => 0,
            pageLength: widget.stories.length,
            storyLength: (pageIndex) {
              final story = widget.stories[pageIndex];
              return story.storySlides?.length ?? 0;
            },
            onPageLimitReached: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    indicatorAnimationController.dispose();
    _showContent.dispose();
    _dismissAnimationController.dispose();
    super.dispose();
  }
}



class AnimatedImageStoryContent extends StatefulWidget {
  final ImageProvider? imageProvider;
  final bool isVisible;
  final String? duration;
  final String? delay;
  final String? animationType;

  const AnimatedImageStoryContent({
    super.key,
    this.imageProvider,
    required this.isVisible,
    this.duration,
    this.delay,
    this.animationType,
  });

  @override
  State<AnimatedImageStoryContent> createState() =>
      AnimatedImageStoryContentState();
}

class AnimatedImageStoryContentState extends State<AnimatedImageStoryContent>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;

  late Duration animationDuration;
  late Duration animationDelay;

  @override
  void initState() {
    super.initState();

    try {
      animationDuration =
          Duration(milliseconds: int.parse(widget.duration ?? '1000')) * 1000;

      animationDelay = Duration(
          milliseconds: (double.parse(widget.delay ?? '0.3') * 1000).toInt());
    } catch (e) {
      animationDuration = Duration(milliseconds: 1000);
      animationDelay = Duration(milliseconds: 300);
    }

    controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    scaleAnimation = _createScaleAnimation();

    slideAnimation = _createSlideAnimation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isVisible) {
        Future.delayed(animationDelay, () {
          controller.forward();
        });
      }
    });
  }

  Animation<double> _createScaleAnimation() {
    late double begin;
    const double end = 1.0;

    switch (widget.animationType) {
      case 'zoom-in':
        begin = 0.85;
        break;
      default:
        begin = 0.95;
    }

    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
  }

  Animation<Offset> _createSlideAnimation() {
    late Offset begin;
    final end = Offset.zero;

    switch (widget.animationType) {
      case 'slide-in':
        begin = const Offset(0.3, 0.0);
        break;
      default:
        begin = const Offset(0.3, 0.0);
    }

    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(AnimatedImageStoryContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        Future.delayed(animationDelay, () {
          controller.forward(from: 0.0);
        });
      } else {
        controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageProvider == null) {
      return Container(
        color: Colors.grey.shade800,
        child: const Center(
            child: Icon(Icons.image_not_supported,
                color: Colors.white54, size: 48)),
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (widget.animationType) {
          case 'fade-in':
            return FadeTransition(
              opacity: opacityAnimation,
              child: child,
            );

          case 'zoom-in':
            return FadeTransition(
              opacity: opacityAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );

          case 'slide-in':
            return FadeTransition(
              opacity: opacityAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );

          default:
            return FadeTransition(
              opacity: opacityAnimation,
              child: child,
            );
        }
      },
      child: Image(
        image: widget.imageProvider!,
        fit: BoxFit.cover,
      ),
    );
  }
}

class AnimatedTextContent extends StatefulWidget {
  final String? text;
  final bool isVisible;
  final String? duration;
  final String? delay;
  final String? animationType;
  final int? fontSizeVal;
  final Color? colorVal;
  final FontWeight fontWeight;

  const AnimatedTextContent(
      {super.key,
      required this.text,
      required this.isVisible,
      required this.duration,
      required this.delay,
      required this.animationType,
      required this.fontSizeVal,
      this.colorVal,
      required this.fontWeight});

  @override
  State<AnimatedTextContent> createState() => AnimatedTextContentState();
}

class AnimatedTextContentState extends State<AnimatedTextContent>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Duration animationDuration;
  late Duration animationDelay;

  @override
  void initState() {
    super.initState();

    try {
      animationDuration =
          Duration(milliseconds: int.parse(widget.duration ?? '1000')) * 1000;
      animationDelay = Duration(milliseconds: int.parse(widget.delay ?? '0.3'));
    } catch (e) {
      animationDuration = Duration(milliseconds: 1000);
      animationDelay = Duration(milliseconds: 0);
    }

    controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    slideAnimation = _createSlideAnimation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isVisible) {
        controller.forward();
      }
    });
  }

  Animation<Offset> _createSlideAnimation() {
    late Offset begin;
    final end = Offset.zero;

    switch (widget.animationType) {
      case 'slide-up':
        begin = const Offset(0.0, 1.0);
        break;
      case 'slide-down':
        begin = const Offset(0.0, -1.0);
        break;
      default:
        begin = const Offset(1.0, 0.0);
    }

    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(AnimatedTextContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        controller.forward(from: 0.0);
      } else {
        controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (widget.animationType) {
          case 'fade-in':
            return FadeTransition(
              opacity: opacityAnimation,
              child: child,
            );
          case 'slide-down':
          case 'slide-up':
            return FadeTransition(
              opacity: opacityAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );

          default:
            return FadeTransition(
              opacity: opacityAnimation,
              child: child,
            );
        }
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: null,
        child: Text(
          widget.text.toString(),
          style: TextStyle(
              fontSize: widget.fontSizeVal?.toDouble(),
              fontFamily: fontType,
              color: widget.colorVal,
              decoration: TextDecoration.none,
              fontWeight: widget.fontWeight),
        ),
      ),
    );
  }
}
