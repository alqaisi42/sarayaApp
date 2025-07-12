import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/storiesTopicsBloc/stories_topics_event.dart';
import 'package:newsapp/bloc/storiesTopicsBloc/stories_topics_state.dart';

import 'package:newsapp/config/api_routes.dart';

import '../../Model/stories_model.dart';
import '../blocRepository/get_api_repo.dart';







class StoriesTopicsBloc extends Bloc<StoriesTopicsEvent, StoriesTopicsState> {
  int page = 1;
  static const int perPage = 5;
  bool isLoading = false;
  List<StoryResponse> allTopicsStories = [];

  StoriesTopicsBloc() : super(StoriesTopicsInitialState()) {
    on<FetchStoriesTopics>(_onFetchStoriesTopics);
    on<FetchStoriesMoreTopics>(_onFetchMoreStoriesTopics);
  }

  Future<void> _onFetchStoriesTopics(
      FetchStoriesTopics event,
      Emitter<StoriesTopicsState> emit,
      ) async {
    try {
      page = 1;
      allTopicsStories = [];
      emit(StoriesTopicsLoadingState(currentStories: allTopicsStories));

      final newStories = await GetapiRepo<StoryResponse>(
        url: "$getStoriesUrl/all-stories?per_page=$perPage&page=$page",
        fromJson: StoryResponse.fromJson,
        isToken: false,
      ).getData();

      if (newStories.isNotEmpty) {
        allTopicsStories = newStories;
        page++;
        emit(StoriesTopicsSuccessState(storiesTopicsData: allTopicsStories));
      } else {
        emit(StoriesTopicsSuccessState(storiesTopicsData: []));
      }
    } catch (e) {
      emit(StoriesTopicsErrorState(e.toString()));
    }
  }

  Future<void> _onFetchMoreStoriesTopics(
      FetchStoriesMoreTopics event,
      Emitter<StoriesTopicsState> emit,
      ) async {
    if (isLoading) return;

    try {
      isLoading = true;
      emit(StoriesTopicsLoadingMoreState(currentStories: allTopicsStories));

      final newStories = await GetapiRepo<StoryResponse>(
        url: "$getStoriesUrl/all-stories?per_page=$perPage&page=$page",
        fromJson: StoryResponse.fromJson,
        isToken: false,
      ).getData();

      if (newStories.isNotEmpty) {
        allTopicsStories = [...allTopicsStories, ...newStories];
        page++;
        emit(StoriesTopicsSuccessState(storiesTopicsData: allTopicsStories));
      }
    } catch (e) {
      emit(StoriesTopicsErrorState(e.toString()));
    } finally {
      isLoading = false;
    }
  }
}













