
 import 'package:equatable/equatable.dart';

import '../../Model/news_page_model.dart';




 abstract class NewsPageState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class NewsPageInitialState extends NewsPageState {}

 class NewsPageStateLoadingState extends NewsPageState {
   final List<NewsPageResponse> newsPageData;

   NewsPageStateLoadingState(this.newsPageData);

   @override
   List<Object?> get props => [newsPageData];
 }

 class NewsPageStateLoadingMoreState extends NewsPageState {
   final List<NewsPageResponse> newsPageData;

   NewsPageStateLoadingMoreState(this.newsPageData);

   @override
   List<Object?> get props => [newsPageData];
 }

 class NewsPageStateSuccessState extends NewsPageState {
   final List<NewsPageResponse> newsPageData;

   NewsPageStateSuccessState({required this.newsPageData});

   @override
   List<Object?> get props => [newsPageData];
 }

 class NewsPageStateErrorState extends NewsPageState {
   final String errorMessage;

   NewsPageStateErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }