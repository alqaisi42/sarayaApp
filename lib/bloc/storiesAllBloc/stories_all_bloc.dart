import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/storiesAllBloc/stories_all_event.dart';
import 'package:newsapp/bloc/storiesAllBloc/stories_all_state.dart';


import 'package:newsapp/config/api_routes.dart';

import '../../Model/stories_model.dart';
import '../blocRepository/get_api_repo.dart';





class StoriesAllBloc extends Bloc<StoriesAllEvent, StoriesAllState> {
  int page = 1;
  final int perPage = 10;
  bool isLoading = false;
  List<StoryResponse> allStories = [];
  String topicStoryName = '';

  StoriesAllBloc() : super(StoriesAllTopicsInitialState()) {
    on<FetchStoriesAllTopic>(_onFetchStoriesAllTopic);
    on<FetchStoriesAllMoreTopics>(_onFetchMoreStoriesAllTopics);
  }

  Future<void> _onFetchStoriesAllTopic(
      FetchStoriesAllTopic event,
      Emitter<StoriesAllState> emit,
      ) async {
    try {
      emit(StoriesAllTopicsLoadingState(storiesall: allStories));
      topicStoryName = event.storiesTopic;
      page = 1;
      allStories.clear();


      final newStories = await GetapiRepo<StoryResponse>(
        url: "$getStoriesUrl/topic/${event.storiesTopic}?per_page=$perPage&page=$page",
        fromJson: StoryResponse.fromJson,
        isToken: false,
      ).getData();

      if (newStories.isNotEmpty) {
        allStories = newStories;
        page++;
        emit(StoriesAllTopicsSuccessState(storiesall: allStories));
      } else {
        emit(StoriesAllTopicsSuccessState(storiesall: allStories));
      }
    } catch (e) {
      emit(StoriesAllTopicsErrorState(e.toString()));
    }
  }

  Future<void> _onFetchMoreStoriesAllTopics(FetchStoriesAllMoreTopics event, Emitter<StoriesAllState> emit,) async {

    if (isLoading) return;
    try {
      isLoading = true;
      emit(StoriesAllTopicsLoadingMoreState(storiesall: allStories));

      final newStories = await GetapiRepo<StoryResponse>(
        url: "$getStoriesUrl/topic/$topicStoryName?per_page=$perPage&page=$page",
        fromJson: StoryResponse.fromJson,
        isToken: false,
      ).getData();

      if (newStories.isNotEmpty) {
        allStories.addAll(newStories);
        page++;
        emit(StoriesAllTopicsSuccessState(storiesall: allStories));
      } else {
        // No more stories to load
        emit(StoriesAllTopicsSuccessState(storiesall: allStories));
      }
    } catch (e) {
      emit(StoriesAllTopicsErrorState(e.toString()));
    } finally {
      isLoading = false;
    }
  }
}















