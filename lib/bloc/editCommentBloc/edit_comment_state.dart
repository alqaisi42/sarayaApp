

import 'package:equatable/equatable.dart';

import '../../Model/edit_comment_model.dart';

abstract class EditCommentState extends Equatable {

  @override
  List<Object?> get props => [];
}


class EditCommentInitialState extends EditCommentState {}

class EditCommentSuccessState extends EditCommentState {
final List<EditCommentResponse> editCommentData;

EditCommentSuccessState({required this.editCommentData});

  @override
  List<Object?> get props => [editCommentData];
}

class EditCommentErrorState extends EditCommentState {
  final String errorMessage;

  EditCommentErrorState({required this.errorMessage});


  @override
  List<Object?> get props => [errorMessage];

}