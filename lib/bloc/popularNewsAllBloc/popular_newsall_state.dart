
 import 'package:equatable/equatable.dart';

import '../../Model/popular_news_home_model.dart';




 abstract class PopularNewsAllState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class PopularNewsAllInitialState extends PopularNewsAllState {}

 class PopularNewsAllLoadingState extends PopularNewsAllState {
   final List<PopularHomeResponse> popularNewsAll;

   PopularNewsAllLoadingState(this.popularNewsAll);

   @override
   List<Object?> get props => [popularNewsAll];
 }

 class PopularNewsAllLoadingMoreState extends PopularNewsAllState {
   final List<PopularHomeResponse> popularNewsAll;

   PopularNewsAllLoadingMoreState(this.popularNewsAll);

   @override
   List<Object?> get props => [popularNewsAll];
 }

 class PopularNewsAllSuccessState extends PopularNewsAllState {
   final List<PopularHomeResponse> popularNewsAll;

   PopularNewsAllSuccessState({required this.popularNewsAll});

   @override
   List<Object?> get props => [popularNewsAll];
 }

 class PopularNewsAllErrorState extends PopularNewsAllState {
   final String errorMessage;

   PopularNewsAllErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }