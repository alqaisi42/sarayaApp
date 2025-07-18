// lib/bloc/breakingNewsBloc/breaking_news_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BreakingNewsEvent.dart';
import 'BreakingNewsState.dart';
import 'news_model.dart';
import 'news_repository.dart';

class BreakingNewsBloc extends Bloc<BreakingNewsEvent, BreakingNewsState> {
  final NewsRepository newsRepository;

  BreakingNewsBloc({required this.newsRepository}) : super(BreakingNewsInitial()) {
    on<FetchBreakingNews>(_onFetchBreakingNews);
  }

  Future<void> _onFetchBreakingNews(
      FetchBreakingNews event,
      Emitter<BreakingNewsState> emit,
      ) async {
    try {
      emit(BreakingNewsLoading());
      final List<NewsModel> newsList = await newsRepository.fetchBreakingNews();
      emit(BreakingNewsSuccess(newsList));
    } catch (e) {
      emit(BreakingNewsError(e.toString()));
    }
  }
}
