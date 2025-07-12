

import 'package:equatable/equatable.dart';

abstract class CommentsPostEvent extends Equatable{

  @override
  List<Object?> get props => [];
}

class PostComments extends CommentsPostEvent {
  final String currentPostId;
  final String postComments;
  final String? replyPostId;

  PostComments({
    required this.currentPostId,
    required this.postComments,
    this.replyPostId,
  });

  @override
  List<Object?> get props => [currentPostId, postComments, replyPostId];
}

