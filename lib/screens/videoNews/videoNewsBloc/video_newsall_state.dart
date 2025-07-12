
 import 'package:equatable/equatable.dart';

import '../../../Model/popular_news_home_model.dart';





 abstract class VideoNewsState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class VideoNewsInitialState extends VideoNewsState {}

 class VideoNewsLoadingState extends VideoNewsState {
   final List<PopularHomeResponse> videoNewsAll;

   VideoNewsLoadingState(this.videoNewsAll);

   @override
   List<Object?> get props => [videoNewsAll];
 }

 class VideoNewsLoadingMoreState extends VideoNewsState {
   final List<PopularHomeResponse> videoNewsAll;

   VideoNewsLoadingMoreState(this.videoNewsAll);

   @override
   List<Object?> get props => [videoNewsAll];
 }

 class VideoNewsSuccessState extends VideoNewsState {
   final List<PopularHomeResponse> videoNewsAll;

   VideoNewsSuccessState({required this.videoNewsAll});

   @override
   List<Object?> get props => [videoNewsAll];
 }

 class VideoNewsErrorState extends VideoNewsState {
   final String errorMessage;

   VideoNewsErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }
