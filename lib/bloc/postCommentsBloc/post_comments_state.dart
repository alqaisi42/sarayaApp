

import 'package:equatable/equatable.dart';

import '../../Model/comment_post_model.dart';

abstract class CommentsPostState extends Equatable{

  @override
  List<Object?> get props => [];
}


class CommentsPostInitialState extends CommentsPostState{}

class CommentsPostLoadingState extends CommentsPostState{}

class CommentsPostSuccessState extends CommentsPostState{
final  List<CommentPostResponse>  commentsPostList;

  CommentsPostSuccessState({required this.commentsPostList});

  @override
  List<Object?> get props => [commentsPostList];
}

class CommentsPostErrorState extends CommentsPostState{
final  String errorMessage;

  CommentsPostErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

}

