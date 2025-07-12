
import 'package:equatable/equatable.dart';

import '../../Model/delete_comment_model.dart';

abstract class DeleteCommentState extends Equatable{

  @override
  List<Object?> get props => [];
}

class DeleteCommentInitialState extends DeleteCommentState {}


class DeleteCommentSuccessState extends DeleteCommentState {
  final List<DeleteCommentResponse> commentDeleteData;
  DeleteCommentSuccessState({required this.commentDeleteData});

  @override
  List<Object> get props => [commentDeleteData];
}

class DeleteCommentErrorState extends DeleteCommentState {
  final String? errorMessage;

  DeleteCommentErrorState({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}