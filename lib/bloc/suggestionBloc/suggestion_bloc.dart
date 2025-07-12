import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/suggestionBloc/suggestion_event.dart';
import 'package:newsapp/bloc/suggestionBloc/suggestion_state.dart';

import 'package:newsapp/config/api_routes.dart';

import '../../Model/suggestion_model.dart';
import '../blocRepository/get_api_repo.dart';


class SuggestionBloc extends Bloc<SuggestionEvent, SuggestionState> {

  SuggestionBloc() : super(SuggestionInitialState()) {
    on<FetchSuggestion>(onFetchSuggestion);
  }

  Future<void> onFetchSuggestion(FetchSuggestion event, Emitter<SuggestionState> emit) async {
    emit(SuggestionLoadingState());
    try {
      final apiRepo = GetapiRepo<SuggestionResponse>(
        url: "$suggestionUrl?per_page=10&search=${event.suggestionVal}",
        fromJson: SuggestionResponse.fromJson,
        isToken: false,
      );
      final List<SuggestionResponse> suggestionData = await apiRepo.getData();

      emit(SuggestionSuccessState(suggestion: suggestionData));
    
    } catch (e) {
      emit(SuggestionErrorState("Error fetching suggestions: ${e.toString()}"));
    }
  }
}















