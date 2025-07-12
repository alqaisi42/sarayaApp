import 'package:equatable/equatable.dart';

import '../../Model/popular_news_home_model.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {
  final List<PopularHomeResponse> categoryList;

  CategoryLoadingState(this.categoryList);

  @override
  List<Object?> get props => [categoryList];
}

class CategoryLoadingMoreState extends CategoryState {
  final List<PopularHomeResponse> categoryList;

  CategoryLoadingMoreState(this.categoryList);

  @override
  List<Object?> get props => [categoryList];
}

class CategorySuccessState extends CategoryState {
  final List<PopularHomeResponse> categoryList;

  CategorySuccessState({required this.categoryList});

  @override
  List<Object?> get props => [categoryList];
}

class CategoryErrorState extends CategoryState {
  final String errorMessage;

  CategoryErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
