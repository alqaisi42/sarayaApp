


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class EditCommentEvent extends  Equatable {

  @override
  List<Object?> get props => [];
}

class PostEditComment extends EditCommentEvent {
  final String commentId;
  final String userComment;
  final BuildContext context;
  final String postId;
  final String cmtType;
  final String parentCommentId;

  PostEditComment( {required this.postId, required this.commentId, required this.userComment,required this.context,required this.cmtType,required this.parentCommentId});

  @override
  List<Object?> get props => [commentId,userComment,context];
}