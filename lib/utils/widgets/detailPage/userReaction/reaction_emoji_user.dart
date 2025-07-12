import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../bloc/emojiPostBloc/emoji_post_bloc.dart';
import '../../../../bloc/emojiPostBloc/emoji_post_event.dart';
import '../../../../config/constants.dart';
import '../../../../config/helper/helper_functions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../favorite_button.dart';
import '../detail_page.dart';


import '../reactionEmojiMain/flutter_animated_reaction.dart';

class ReactionEmoji extends StatefulWidget {
  final String slug;
  final String initialReaction;
  final bool initialIsLike;

  const ReactionEmoji({
    super.key,
    required this.slug,
    required this.initialReaction,
    required this.initialIsLike,
  });

  @override
  ReactionEmojiState createState() => ReactionEmojiState();
}

class ReactionEmojiState extends State<ReactionEmoji>
    with SingleTickerProviderStateMixin {
  late bool isLiked;
  late String emojiVal;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color? currentColor;

  final Map<String, String> reactionGifs = {
    'like': 'assets/img/reactionEmojiGIF/like.gif',
    'love': 'assets/img/reactionEmojiGIF/love.gif',
    'haha': 'assets/img/reactionEmojiGIF/haha.gif',
    'wow': 'assets/img/reactionEmojiGIF/wow.gif',
    'sad': 'assets/img/reactionEmojiGIF/sad.gif',
    'angry': 'assets/img/reactionEmojiGIF/angry.gif',
  };

  final Map<String, Color> reactionColors = {
    'like': Colors.blue,
    'love': Colors.red,
    'haha': Colors.yellow,
    'wow': Colors.yellow,
    'sad': Colors.yellow,
    'angry': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialReaction.isEmpty) {
      isLiked = false;
      emojiVal = 'like';
      currentColor = null;
    } else {
      isLiked = true;
      emojiVal = widget.initialReaction;
      currentColor = reactionColors[widget.initialReaction];
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() async {
    await _controller.forward();
    await _controller.reverse();
  }

  Widget _buildReactionImage() {
    // Show thumb icon if not liked or emoji not in list
    if (!isLiked || !reactionGifs.containsKey(emojiVal)) {
      return Icon(
        HeroiconsOutline.handThumbUp,
        size: 20,
      );
    }

    // Show reaction GIF if liked and valid emoji
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: 20,
        height: 20,
        child: Image.asset(
          reactionGifs[emojiVal]!,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  void toggleReaction() async {
    if (!await isLogged()) {
      if (mounted) {
        CustomFloatingSnackBar.showCustomSnackBar(
          context,
          AppLocalizations.of(context)!.youNeedToLoginToUseThisFeature,
          0,
        );
      }
      return;
    }

    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        emojiVal = 'like';
        currentColor = reactionColors['like'];
        _playAnimation();
      } else {
        currentColor = null;
      }
    });

    if (mounted) {
      context.read<EmojiPostBloc>().add(
        PostEmojiDetails(
          slug: widget.slug,
          type: emojiVal,
          context: context,
        ),
      );
    }
  }

  String getLocalizedReaction(BuildContext context, String emojiVal, bool isLiked) {
    final reactionTranslations = {
      "like": AppLocalizations.of(context)!.like.toString(),
      "liked": AppLocalizations.of(context)!.liked.toString(),
      "love": AppLocalizations.of(context)!.love.toString(),
      "haha": AppLocalizations.of(context)!.haha.toString(),
      "wow": AppLocalizations.of(context)!.wow.toString(),
      "sad": AppLocalizations.of(context)!.sad.toString(),
      "angry": AppLocalizations.of(context)!.angry.toString(),
    };


    if (emojiVal == "like" && isLiked) {
      return reactionTranslations["liked"] ?? "Liked";
    }


    if (emojiVal.isNotEmpty) {
      return reactionTranslations[emojiVal] ?? emojiVal;
    }

    return reactionTranslations["like"] ?? "Like";
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 60,
      ),
      child: GestureDetector(
        key: reactionGlobalKey,
        onTap: toggleReaction,
        onLongPress: () async {
          if (!await isLogged()) {
            if (context.mounted) {
              CustomFloatingSnackBar.showCustomSnackBar(
                context,
                AppLocalizations.of(context)!.youNeedToLoginToUseThisFeature,
                0,
              );
            }
            return;
          }
          AnimatedReaction().showOverlay(
            context: mounted ? context : context,
            onReaction: (val) {
              setState(() {
                String newEmoji;
                switch (val) {
                  case 0:
                    newEmoji = 'like';
                    break;
                  case 1:
                    newEmoji = 'love';
                    break;
                  case 2:
                    newEmoji = 'haha';
                    break;
                  case 3:
                    newEmoji = 'wow';
                    break;
                  case 4:
                    newEmoji = 'sad';
                    break;
                  case 5:
                    newEmoji = 'angry';
                    break;
                  default:
                    newEmoji = 'like';
                }

                if (emojiVal != newEmoji) {
                  emojiVal = newEmoji;
                  currentColor = reactionColors[newEmoji];
                  isLiked = true;
                  _playAnimation();
                }
              });

              context.read<EmojiPostBloc>().add(
                PostEmojiDetails(
                    slug: widget.slug, type: emojiVal, context: context),
              );
            },
            key: reactionGlobalKey,
          );
        },
        child: Column(
          children: [
            _buildReactionImage(),
            SizedBox(height: 4),
            Text(
              getLocalizedReaction(context, emojiVal, isLiked),

              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                fontFamily: fontType,
                color: currentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}