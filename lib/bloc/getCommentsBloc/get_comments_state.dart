
 import 'package:equatable/equatable.dart';

import '../../Model/get_comment_model.dart';




 abstract class GetCommentsState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class GetCommentsInitialState extends GetCommentsState {}

 class GetCommentsSuccessState extends GetCommentsState {
   final List<CommentsGetResponse> getCommentsData;

   GetCommentsSuccessState(this.getCommentsData);

   @override
   List<Object?> get props => [getCommentsData];
 }

 class GetCommentsLoadingMoreState extends GetCommentsState {
   final List<CommentsGetResponse> getCommentsData;

   GetCommentsLoadingMoreState(this.getCommentsData);

   @override
   List<Object?> get props => [getCommentsData];
 }

 class GetCommentsLoadingState extends GetCommentsState {
   final List<CommentsGetResponse> getCommentsData;

   GetCommentsLoadingState(this.getCommentsData);

   @override
   List<Object?> get props => [getCommentsData];
 }


 class GetCommentsErrorState extends GetCommentsState {
   final String errorMessage;

   GetCommentsErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }

