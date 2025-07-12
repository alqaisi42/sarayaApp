import 'package:flutter_bloc/flutter_bloc.dart';



import 'package:newsapp/bloc/storiesBloc/stories_event.dart';
import 'package:newsapp/bloc/storiesBloc/stories_state.dart';

import 'package:newsapp/config/api_routes.dart';

import '../../Model/stories_model.dart';
import '../blocRepository/get_api_repo.dart';



class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  List<StoryResponse>? cachedStories;

  StoriesBloc() : super(StoriesInitialState()) {
    on<FetchStories>(onFetchStories);
  }

  Future<void> onFetchStories(FetchStories event, Emitter<StoriesState> emit) async {
    if (event.refreshIndicator || cachedStories == null || event.reFetch) {

        emit(StoriesLoadingState());

      try {
        final apiRepo = GetapiRepo<StoryResponse>(
          url: "$getStoriesUrl/home?story_limit=10&topic_limit=0",
          fromJson: StoryResponse.fromJson, isToken: false,
        );
        final List<StoryResponse> storiesdatas = await apiRepo.getData();
        cachedStories = storiesdatas;

        emit(StoriesSuccessState( storiesData: storiesdatas));
      } catch (e) {
        emit(StoriesErrorState(e.toString()));
      }
    } else {
      emit(StoriesSuccessState(storiesData: cachedStories!));
    }
  }
}














