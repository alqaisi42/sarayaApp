


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DeleteCommentEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class PostDeleteComment extends DeleteCommentEvent{
final int commentId;
final BuildContext context;
final String postId;
final String commentType;
final VoidCallback? onCommentDelete;

PostDeleteComment({required this.commentType,required this.commentId,required this.context,required this.postId,required this.onCommentDelete});


  @override
  List<Object?> get props => [commentId];
}