// lib/bloc/breakingNewsBloc/breaking_news_state.dart
import 'package:equatable/equatable.dart';

import 'news_model.dart';

abstract class BreakingNewsState extends Equatable {
  const BreakingNewsState();

  @override
  List<Object?> get props => [];
}

class BreakingNewsInitial extends BreakingNewsState {}

class BreakingNewsLoading extends BreakingNewsState {}

class BreakingNewsSuccess extends BreakingNewsState {
  final List<NewsModel> breakingNews;

  const BreakingNewsSuccess(this.breakingNews);

  @override
  List<Object?> get props => [breakingNews];
}

class BreakingNewsError extends BreakingNewsState {
  final String message;

  const BreakingNewsError(this.message);

  @override
  List<Object?> get props => [message];
}
