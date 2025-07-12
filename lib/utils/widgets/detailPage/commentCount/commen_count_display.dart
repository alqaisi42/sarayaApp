import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import '../../../../bloc/commentsCountBloc/comment_count_bloc.dart';
import '../../../../bloc/commentsCountBloc/comment_count_state.dart';
import '../../../../config/constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../userAction/user_action.dart';
import '../userComment/add_comments.dart';
class CommentCountDisplay extends StatelessWidget {
  final String slug;
  final String id;
  final int initialViewCount;
  final bool isShowCount;

  const CommentCountDisplay(
      {super.key,
        required this.slug,
        required this.initialViewCount,
        required this.id,
        required this.isShowCount});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCountBloc, CommentCountState>(
      builder: (context, state) {
        final commentCount = state.commentCounts[slug] ?? initialViewCount;

        return GestureDetector(
            onTap: () {
              CommentsBottomSheet.show(context, id, slug);
            },
            child: !isShowCount
                ? UserAction(
              actionIcon: HeroiconsOutline.chatBubbleBottomCenterText,
              txt: AppLocalizations.of(context)!.comments,
              numVal: 0,
            )
                : Row(
              children: [
                Text('$commentCount',style: TextStyle(fontFamily: fontType),),
                SizedBox(
                  width: 5,
                ),
                Text(AppLocalizations.of(context)!.comments,style: TextStyle(fontFamily: fontType),),
              ],
            ));
      },
    );
  }
}