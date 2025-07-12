



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/utils/widgets/detailPage/userComment/reply_comment.dart';
import 'package:newsapp/utils/widgets/detailPage/userComment/report_comment.dart';

import '../../../../bloc/commentsReplyBloc/comments_reply_bloc.dart';
import '../../../../bloc/commentsReplyBloc/comments_reply_event.dart';
import '../../../../bloc/commentsReplyBloc/comments_reply_state.dart';
import '../../../../bloc/deleteCommentBloc/delete_comment_bloc.dart';
import '../../../../bloc/deleteCommentBloc/delete_comment_event.dart';
import '../../../../config/colors.dart';
import '../../../../config/constants.dart';

import '../../../../config/helper/helper_functions.dart';
import '../../../../l10n/app_localizations.dart';



class DisplayComments extends StatelessWidget {
  final dynamic comment;
  final String postId;
  final String userToken;
  final Function(String, String) onReplyTap;
  final Function(String, String, String,String) onEditTap;
  final BuildContext getCommentContext;
  final FocusNode focusNode;

  const DisplayComments(
      {super.key,
        required this.comment,
        required this.onReplyTap,
        required this.userToken,
        required this.onEditTap,
        required this.postId,
        required this.getCommentContext,
        required this.focusNode, required String? repltToIds});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsReplyBloc, CommentsReplyState>(
      builder: (context, replyState) {
        final bool showReplies = replyState is CommentsReplySuccessState && replyState.parentCommentId == comment.id.toString();
        final isUserSame = comment.user.id == userID;

        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                  child: ImageUtils.networkImage(comment.user?.profile,width: 30,height: 30,fit: BoxFit.cover)
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.user?.name ?? 'Unknown',
                              style: TextStyle(fontWeight: FontWeight.bold,fontFamily: fontType),
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment.text ?? '',
                              style:  TextStyle(color: Colors.grey,fontFamily: fontType),
                            ),
                          ],
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEditTap(
                                  comment.id.toString(),
                                  comment.text ?? '',
                                  comment.user?.name ?? 'User',
                                  "parentComment"
                              );
                            } else if (value == 'delete') {
                              context.read<DeleteCommentBloc>().add(
                                PostDeleteComment(
                                  commentId: comment.id,
                                  context: getCommentContext,
                                  postId: postId.toString(),
                                  commentType: 'parentComment',
                                  onCommentDelete: () {},
                                ),
                              );
                            } else if(value == 'report'){

                              if(userToken.isEmpty){
                                Navigator.pop(context);
                                CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.youNeedToLoginToUseThisFeature, 0);
                              }else {
                                showDialog(
                                  context: context,
                                  builder: (context) => ReportCommentPopup(commentId: comment.id),
                                );
                              }


                            }
                          },
                          icon: Icon(HeroiconsOutline.ellipsisVertical,size: 22,),
                          itemBuilder: (BuildContext context) {
                            List<PopupMenuItem<String>> menuItems = [];

                            if (isUserSame == true) {
                              menuItems.addAll([
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 17),
                                      SizedBox(width: 10),
                                      Text(AppLocalizations.of(context)!.edit, style: TextStyle(fontSize: 16,fontFamily: fontType))
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 17),
                                      SizedBox(width: 10),
                                      Text(AppLocalizations.of(context)!.delete, style: TextStyle(fontSize: 16,fontFamily: fontType))
                                    ],
                                  ),
                                ),
                              ]);
                            }

                            menuItems.add( PopupMenuItem<String>(
                              value: 'report',
                              child: Row(
                                children: [
                                  Icon(Icons.flag_outlined, size: 17),
                                  SizedBox(width: 10),
                                  Text(AppLocalizations.of(context)!.report, style: TextStyle(fontSize: 16,fontFamily: fontType))
                                ],
                              ),
                            ));

                            return menuItems;
                          },
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.10, height: 10),
                    Row(
                      children: [
                        Text(
                          comment.createdAt ?? '',
                          style:  TextStyle(color: Colors.grey, fontSize: 12,fontFamily: fontType),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                            width: MediaQueryHelper.screenWidth(context) * 0.02
                        ),
                        GestureDetector(
                          onTap: () => onReplyTap(
                              comment.id.toString(),
                              comment.user?.name
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.reply,
                            style: TextStyle(
                                color: AppColors().primaryColor,
                                fontSize: 12,
                                fontFamily: fontType
                            ),
                          ),
                        ),
                        if (comment.replies > 0) ...[
                          SizedBox(
                              width: MediaQueryHelper.screenWidth(context) * 0.02
                          ),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                              width: MediaQueryHelper.screenWidth(context) * 0.02
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!showReplies) {
                                context.read<CommentsReplyBloc>().add(
                                  FetchCommentsReply(
                                    postId: postId.toString(),
                                    parentCommentId: comment.id.toString(),
                                    page: 1,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "${AppLocalizations.of(context)!.viewReply} (${comment.replies})",
                              style: TextStyle(
                                  color: AppColors().primaryColor,
                                  fontSize: 12,
                                  fontFamily: fontType
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (showReplies) ...[
                      SizedBox(height: 8),
                      if (replyState is CommentsReplyLoadingState)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (replyState.commentReplyData.isNotEmpty) ...[
                        ...(replyState.commentReplyData[0].data ?? []).map(
                              (reply) => Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.005,
                            ),
                            child: ReplyComment(
                              reply: reply,
                              context: context,
                              userIds: userID,
                              comment: comment,
                              postId: postId,
                              focusNode: focusNode,
                              onEditTap: onEditTap,
                              userToken: userToken,
                            ),
                          ),
                        ),
                        if (replyState.hasMorePages)
                          TextButton(
                            onPressed: () {
                              context.read<CommentsReplyBloc>().add(
                                FetchCommentsReply(
                                  postId: postId.toString(),
                                  parentCommentId: comment.id.toString(),
                                  page: replyState.currentPage + 1,
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.viewMore,
                              style: TextStyle(color: AppColors().primaryColor,fontFamily: fontType),
                            ),
                          ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}