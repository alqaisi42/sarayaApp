
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:newsapp/utils/widgets/detailPage/userComment/report_comment.dart';

import '../../../../bloc/deleteCommentBloc/delete_comment_bloc.dart';
import '../../../../bloc/deleteCommentBloc/delete_comment_event.dart';
import '../../../../config/constants.dart';


import '../../../../config/helper/helper_functions.dart';
import '../../../../l10n/app_localizations.dart';

class ReplyComment extends StatelessWidget {
  final dynamic reply;
  final BuildContext context;
  final dynamic userIds;
  final dynamic comment;
  final dynamic postId;
  final FocusNode focusNode;
  final Function(String p1, String p2, String p3, String p4) onEditTap;
  final dynamic userToken;

  const ReplyComment({
    super.key,
    required this.reply,
    required this.context,
    required this.userIds,
    required this.comment,
    required this.postId,
    required this.focusNode,
    required this.onEditTap,
    required this.userToken,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUserSame = reply.user?.id == userIds;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: ImageUtils.networkImage(
            reply.user?.profile,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: MediaQueryHelper.screenWidth(context) * 0.02),
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
                        reply.user?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: fontType,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reply.comment ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: fontType,
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEditTap(
                          reply.id.toString(),
                          reply.comment,
                          reply.user?.name,
                          "replyComment",
                        );
                      } else if (value == 'delete') {
                        BlocProvider.of<DeleteCommentBloc>(context).add(
                          PostDeleteComment(
                            commentId: reply.id,
                            context: context,
                            postId: postId.toString(),
                            commentType: 'replyComment',
                            onCommentDelete: () {
                              Future.delayed(const Duration(milliseconds: 100), () {
                                focusNode.requestFocus();
                              });
                            },
                          ),
                        );
                      } else if (value == 'report') {
                        if (userToken == null || userToken.isEmpty) {
                          Navigator.pop(context);
                          CustomFloatingSnackBar.showCustomSnackBar(
                            context,
                            AppLocalizations.of(context)!.youNeedToLoginToUseThisFeature,
                            0,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => ReportCommentPopup(commentId: reply.id),
                          );
                        }
                      }
                    },
                    icon: const Icon(HeroiconsOutline.ellipsisVertical, size: 22),
                    itemBuilder: (BuildContext context) {
                      List<PopupMenuItem<String>> menuItems = [];

                      if (isUserSame) {
                        menuItems.addAll([
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(Icons.edit, size: 17),
                                const SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(context)!.edit,
                                  style: const TextStyle(fontSize: 16, fontFamily: fontType),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(Icons.delete, size: 17),
                                const SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(context)!.delete,
                                  style: const TextStyle(fontSize: 16, fontFamily: fontType),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }

                      menuItems.add(
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Row(
                            children: [
                              const Icon(Icons.flag_outlined, size: 17),
                              const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!.report,
                                style: const TextStyle(fontSize: 16, fontFamily: fontType),
                              ),
                            ],
                          ),
                        ),
                      );

                      return menuItems;
                    },
                  ),
                ],
              ),
              const Divider(thickness: 0.10, height: 10),
              Row(
                children: [
                  Text(
                    reply.createdAt ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: fontType,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
