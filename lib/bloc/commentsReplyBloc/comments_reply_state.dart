

import 'package:equatable/equatable.dart';

import '../../Model/comment_reply_model.dart';

abstract class CommentsReplyState extends Equatable {

  @override
  List<Object?> get props => [];
}

class CommentsReplyInitialState extends CommentsReplyState {}

class CommentsReplyLoadingState extends CommentsReplyState {
  final String parentCommentId;

  CommentsReplyLoadingState({required this.parentCommentId});

  @override
  List<Object> get props => [parentCommentId];
}

class CommentsReplySuccessState extends CommentsReplyState {
final List<CommentReplyResponse> commentReplyData;
final int currentPage;
final bool hasMorePages;
final String parentCommentId;


CommentsReplySuccessState( {required this.commentReplyData,required this.currentPage , required this.hasMorePages, required this.parentCommentId, });

@override
List<Object?> get props => [commentReplyData];
}


class CommentsReplyErrorState extends CommentsReplyState {
  final String? errorMessage;

  CommentsReplyErrorState({required this.errorMessage});


  @override
  List<Object?> get props => [errorMessage];
}