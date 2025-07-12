
 import 'package:equatable/equatable.dart';

import '../../Model/search_result_model.dart';



 abstract class SearchResultState extends Equatable {
   @override
   List<Object?> get props => [];
 }

 class SearchResultInitialState extends SearchResultState {}

 class SearchResultLoadingState extends SearchResultState {
   final List<SearchResultResponse> searchResultData;

   SearchResultLoadingState(this.searchResultData);

   @override
   List<Object?> get props => [searchResultData];
 }

 class SearchResultLoadingMoreState extends SearchResultState {
   final List<SearchResultResponse> searchResultData;

   SearchResultLoadingMoreState(this.searchResultData);

   @override
   List<Object?> get props => [searchResultData];
 }

 class SearchResultSuccessState extends SearchResultState {
   final List<SearchResultResponse> searchResultData;

   SearchResultSuccessState({required this.searchResultData});

   @override
   List<Object?> get props => [searchResultData];
 }

 class SearchResultErrorState extends SearchResultState {
   final String errorMessage;

   SearchResultErrorState({required this.errorMessage});

   @override
   List<Object?> get props => [errorMessage];
 }