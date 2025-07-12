

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/constants.dart';
import '../../bloc/bookmark/bookmark_article_bloc.dart';

import '../../config/colors.dart';

import '../../l10n/app_localizations.dart';

import '../../config/helper/helper_functions.dart';

class FollowButton extends StatefulWidget {
  final String channelslug;
  final String? pageName;

  const FollowButton({
    super.key,
    required this.channelslug,
    this.pageName

  });
  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocListener<BookmarkArticleBloc, BookmarkArticleState>(
        listener: (context, state) {

    },
    child: BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(builder: (context,state) {
      state as BookmarkArticleAll;
      return SizedBox(
        height: MediaQueryHelper.screenHeight(context) * 0.034,
        width: MediaQueryHelper.screenWidth(context) * 0.3,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: MediaQueryHelper.screenHeight(context) * 0,
              horizontal: MediaQueryHelper.screenWidth(context) * 0.05,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: state.slugs.contains(widget.channelslug) ? Theme.of(context).colorScheme.primary  : AppColors().primaryColor,
            foregroundColor: state.slugs.contains(widget.channelslug) ? Theme.of(context).colorScheme.brightness == Brightness.light ? Colors.black : Colors.white : AppColors.lightColor,
            side: state.slugs.contains(widget.channelslug)
                ? BorderSide(color: AppColors().primaryColor, width:1)
                : BorderSide.none,
          ),
          onPressed: () async {

            if (state.slugs.contains(widget.channelslug)) {
              context.read<BookmarkArticleBloc>().add(BookmarkArticleRemove(context: context, slug: widget.channelslug,slugType: "channel"));
            } else {
              context.read<BookmarkArticleBloc>().add(BookmarkArticleAdd(slug: widget.channelslug, context: context,slugType: "channel"));
            }
            setState(() {});
            },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              state.slugs.contains(widget.channelslug) ? AppLocalizations.of(context)!.following : AppLocalizations.of(context)!.follow,
              style:  TextStyle(
                fontSize: 13,
                fontFamily: fontType
              ),
            ),
          ),
        ),
      );
    }));
      }

  }




