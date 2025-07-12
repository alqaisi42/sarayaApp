import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newsapp/bloc/editCommentBloc/edit_comment_bloc.dart';
import '../../../../Model/auth model/auth_response_model.dart';
import '../../../../Model/get_comment_model.dart';
import '../../../../bloc/commentsReplyBloc/comments_reply_bloc.dart';
import '../../../../bloc/commentsReplyBloc/comments_reply_event.dart';
import '../../../../bloc/deleteCommentBloc/delete_comment_bloc.dart';
import '../../../../bloc/deleteCommentBloc/delete_comment_state.dart';
import '../../../../bloc/editCommentBloc/edit_comment_event.dart';
import '../../../../bloc/editCommentBloc/edit_comment_state.dart';
import '../../../../bloc/getCommentsBloc/get_comments_bloc.dart';
import '../../../../bloc/getCommentsBloc/get_comments_event.dart';
import '../../../../bloc/getCommentsBloc/get_comments_state.dart';
import '../../../../bloc/postCommentsBloc/post_comments_bloc.dart';
import '../../../../bloc/postCommentsBloc/post_comments_event.dart';
import '../../../../bloc/postCommentsBloc/post_comments_state.dart';
import '../../../../config/colors.dart';
import '../../../../config/constants.dart';

import '../../../../config/helper/helper_functions.dart';
import '../../../../config/hiveLocalStorage/hive_storage.dart';
import '../../../../l10n/app_localizations.dart';
import '../../favorite_button.dart';
import 'display_comments.dart';


class CommentsBottomSheet extends StatefulWidget {
  final String postId;
 final String slug;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    required this.slug
  });

  static void show(BuildContext context, String id, String slug) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: CommentsBottomSheet(postId: id,slug: slug,),
      ),
    );
  }

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  String? replyingToId;
  String? editingToId;
  String? replyingToName;
  String? editingToName;
  String? editCmtType;
  String? editingToUserText;
  int? userCmtCount;
  bool showReplyField = false;
  final FocusNode _focusNode = FocusNode();
  late int userId;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    context.read<CommentsReplyBloc>().add(CommentReplyInitial());
    getUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<String?> _loadToken() async {
    AuthResponse? fetchedToken = await HiveStorage().getToken();

    setState(() {
      token = fetchedToken?.data?.token;
    });

    return token;
  }

  void handleReply(String commentId, String userName) {
    setState(() {
      replyingToId = commentId;
      replyingToName = userName;
      editingToId = null;
      editingToName = null;
      editingToUserText = null;
      showReplyField = true;
    });

    // Use a single focus request with proper timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.canRequestFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  void handleEdit(String commentId, String commentText, String userName, String editCommentType) {
    setState(() {
      editingToId = commentId;
      editCmtType = editCommentType;
      editingToName = userName; // ← This should be set correctly
      editingToUserText = commentText;

      // IMPORTANT: Clear reply state when editing
      replyingToId = null;
      replyingToName = null;

      showReplyField = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.canRequestFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  // void handleReply(String commentId, String userName) {
  //
  //   if (showReplyField == false) {
  //     _focusNode.unfocus();
  //   }
  //
  //   setState(() {
  //     replyingToId = commentId;
  //     replyingToName = userName;
  //     editingToId = null;
  //     showReplyField = true;
  //   });
  //
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     _focusNode.requestFocus();
  //   });
  // }
  //
  // void handleEdit(String commentId, String commentText, String userName,editCommentType) {
  //
  //
  //   if (showReplyField == false) {
  //     _focusNode.unfocus();
  //   }
  //
  //   setState(() {
  //     editingToId = commentId;
  //     editCmtType = editCommentType;
  //     editingToName = userName;
  //     editingToUserText = commentText;
  //     replyingToId = null;
  //     replyingToName = userName;
  //     showReplyField = true;
  //   });
  //
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     _focusNode.requestFocus();
  //   });
  // }
  void clearReply() {
    setState(() {
      replyingToId = null;
      replyingToName = null;
      editingToId = null;
      editingToName = null;
      editingToUserText = null;
      editCmtType = null;
      showReplyField = false;
    });
    _focusNode.unfocus();
  }

  // void clearReply() {
  //   setState(() {
  //     replyingToId = null;
  //     editingToId = null;
  //     showReplyField = false;
  //   });
  //   _focusNode.unfocus();
  // }



  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetCommentsBloc()
        ..add(FetchGetComments(getPostId: widget.postId, context: context)),
      child: Column(
        children: [
          // Title Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha:0.2), width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.comments,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: fontType),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withValues(alpha:0.1)),
                    child: Icon(Icons.close, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Top Loading Bar (For Posting Comment)
          BlocBuilder<CommentsPostBloc, CommentsPostState>(
            builder: (context, state) {
              if (state is CommentsPostLoadingState) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  width: double.infinity,
                  color: Colors.grey.withValues(alpha:0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitThreeBounce(
                        color: AppColors().primaryColor,
                        size: 20.0,
                      ),
                      SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.postingComment,
                        style: TextStyle(fontFamily: fontType),
                      ),
                    ],
                  )
                );
              }
              return SizedBox.shrink();
            },
          ),


          Expanded(
            child: BlocBuilder<GetCommentsBloc, GetCommentsState>(
              builder: (context, state) {
                if (state is GetCommentsInitialState) {

                  return Center(child: CircularProgressIndicator(color: AppColors().primaryColor));
                } else if (state is GetCommentsSuccessState || state is GetCommentsLoadingMoreState) {
                  final isLoadingMore = state is GetCommentsLoadingMoreState;
                  final List<CommentsGetResponse> commentsData = isLoadingMore
                      ? (state).getCommentsData
                      : (state as GetCommentsSuccessState).getCommentsData;




                  final commentsResponse = commentsData[0];
                  userCmtCount = commentsResponse.data?.count ?? 0;

                  return SingleChildScrollView(
                    controller: context.read<GetCommentsBloc>().scrollController,
                    child: Column(
                      children: [
                        ...commentsData.map((comment) {
                          if (comment.data != null && comment.data!.comment != null) {
                            return Column(
                              children: comment.data!.comment!.map((commentData) {
                                return DisplayComments(
                                  comment: commentData,
                                  userToken: token ?? "",
                                  onReplyTap: handleReply,
                                  onEditTap: handleEdit,
                                  postId: widget.postId,
                                  getCommentContext: context,
                                  repltToIds: replyingToId,
                                  focusNode: _focusNode,
                                );
                              }).toList(),
                            );
                          }
                          return const SizedBox.shrink();
                        }),

                        // Pagination Loading Indicator (Shown at Bottom)
                        if (isLoadingMore)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors().primaryColor),
                            ),
                          ),
                      ],
                    ),
                  );
                } else if (state is GetCommentsErrorState) {
                  return Center(child: Text(state.errorMessage, style: TextStyle(fontFamily: fontType)));
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Reply Indicator (When Replying)
          // if (showReplyField)
          //   Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     color: Theme.of(context).colorScheme.surface,
          //     child: Row(
          //       children: [
          //         Text(
          //           editingToId != null
          //               ? '${AppLocalizations.of(context)!.editingComment} $replyingToName'
          //               : '${AppLocalizations.of(context)!.replyingTo} $replyingToName ${AppLocalizations.of(context)!.comments}',
          //           style: TextStyle(fontFamily: fontType),
          //         ),
          //         Spacer(),
          //         IconButton(icon: Icon(Icons.close, size: 20), onPressed: clearReply),
          //       ],
          //     ),
          //   ),
          if (showReplyField)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                children: [
                  Text(
                    editingToId != null
                        ? '${AppLocalizations.of(context)!.editingComment} $editingToName' // ← FIX: Use editingToName instead of replyingToName
                        : '${AppLocalizations.of(context)!.replyingTo} $replyingToName ${AppLocalizations.of(context)!.comments}',
                    style: TextStyle(fontFamily: fontType),
                  ),
                  Spacer(),
                  IconButton(icon: Icon(Icons.close, size: 20), onPressed: clearReply),
                ],
              ),
            ),

          // Add Comment Section
          AddComment(
            id: widget.postId,
            commentType: editCmtType,
            focusNode: _focusNode,
            textFieldFocus: true,
            replyToId: replyingToId,
            editingCommentId: editingToId,
            editingCommentText: editingToUserText,
            commentCount: userCmtCount,
            slug: widget.slug,
            onCommentPosted: () {
              clearReply();
              Future.delayed(Duration(milliseconds: 100), () {
                _focusNode.requestFocus();
              });
            },
            showReplyField: showReplyField,
          ),
        ],
      ),
    );
  }

}


class AddComment extends StatefulWidget {
  final String id;
  final String slug;
  final bool textFieldFocus;
  final String? replyToId;
  final VoidCallback? onCommentPosted;
  final FocusNode focusNode;
  final bool showReplyField;
  final String? editingCommentId;
  final String? editingCommentText;
  final String? commentType;
  final int? commentCount;

  const AddComment({
    super.key,
    required this.id,
    required this.slug,
    required this.textFieldFocus,
    required this.focusNode,
    this.replyToId,
    this.onCommentPosted,
    this.commentType,
    this.commentCount,
    required this.showReplyField,
    this.editingCommentId,
    this.editingCommentText,
  });

  @override
  AddCommentState createState() => AddCommentState();
}

class AddCommentState extends State<AddComment> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateTextField();
  }
  //
  @override
  void didUpdateWidget(AddComment oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update text field when switching between edit/reply modes
    if (widget.editingCommentId != oldWidget.editingCommentId ||
        widget.editingCommentText != oldWidget.editingCommentText) {
      _updateTextField();
    }
  }



  void _updateTextField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.editingCommentId != null && widget.editingCommentText != null) {
        commentController.text = widget.editingCommentText!;
        // Move cursor to end
        commentController.selection = TextSelection.fromPosition(
          TextPosition(offset: commentController.text.length),
        );
      } else {
        commentController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return MultiBlocListener(
      listeners: [

        BlocListener<CommentsPostBloc, CommentsPostState>(
          listener: (context, state) {
            if (state is CommentsPostSuccessState) {
              // Refresh comments list
              context.read<GetCommentsBloc>().add(
                  FetchGetComments(
                      getPostId: widget.id,
                      context: context,
                      slug: widget.slug
                  )
              );


              if (widget.replyToId != null) {
                context.read<CommentsReplyBloc>().add(
                  FetchCommentsReply(
                    postId: widget.id,
                    parentCommentId: widget.replyToId!,
                    page: 1,
                  ),
                );
              }


              widget.onCommentPosted?.call();
            }

            if (state is CommentsPostErrorState){
              Navigator.pop(context);
              CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
            }

          },
        ),
        // Listen for successful edit comment
        BlocListener<EditCommentBloc, EditCommentState>(
          listener: (context, state) {
            if (state is EditCommentSuccessState) {
              widget.onCommentPosted?.call();
            }

            if (state is EditCommentErrorState){
              Navigator.pop(context);
              CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
            }
          },
        ),

        BlocListener<DeleteCommentBloc, DeleteCommentState>(
          listener: (context, state) {
            if (state is DeleteCommentErrorState){
              Navigator.pop(context);
              CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage.toString(), 0);
            }
          },
        )
      ],
      child: Padding(
        padding: EdgeInsets.only(
          bottom: viewInsets.bottom + bottomPadding,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 50,
                          maxHeight: 150,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: commentController,
                          focusNode: widget.focusNode,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.addComments,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          minLines: 1,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: AppColors().primaryColor),
                      onPressed: () => _handleSubmitComment(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmitComment() async {
    if (!(await isLogged())) {
      if (mounted) {
        CustomFloatingSnackBar.showCustomSnackBar(
            context,
            AppLocalizations.of(context)!.youNeedToLoginToUseThisFeature,
            0
        );
        Navigator.pop(context);
      }
      return;
    }

    final commentText = commentController.text.trim();
    if (commentText.isEmpty) return;

    // Clear the text field immediately
    commentController.clear();

    if (!mounted) return;

    // Post comment or edit comment
    if (widget.editingCommentId != null) {
      // Edit existing comment
      context.read<EditCommentBloc>().add(
        PostEditComment(
          commentId: widget.editingCommentId.toString(),
          userComment: commentText,
          context: context,
          postId: widget.id,
          cmtType: widget.commentType.toString(),
          parentCommentId: widget.replyToId.toString(),
        ),
      );
    } else {
      // Post new comment
      context.read<CommentsPostBloc>().add(
        PostComments(
          currentPostId: widget.id,
          postComments: commentText,
          replyPostId: widget.replyToId ?? "",
        ),
      );
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}








