

import 'package:equatable/equatable.dart';

abstract class CommentReplyEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCommentsReply extends CommentReplyEvent {
  final String postId;
  final String parentCommentId;
  final int page;

  FetchCommentsReply({
    required this.postId,
    required this.parentCommentId,
    required this.page,
  });

  @override
  List<Object?> get props => [postId, parentCommentId, page];
}

class CommentReplyInitial extends CommentReplyEvent{}