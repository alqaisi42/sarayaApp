import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/recommendationNewsBloc/recommendation_event.dart';
import 'package:newsapp/bloc/recommendationNewsBloc/recommendation_state.dart';

import 'package:newsapp/config/api_routes.dart';

import '../../Model/recommendation_model.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';



class RecommendationBloc extends Bloc<RecommendationEvent, RecommendationState> {
  List<RecommedationResponse>? _cachedData;
  final page = 1;

  RecommendationBloc() : super(RecommendationInitialState()) {
    on<FetchRecommendation>(_fetchRecommendationNews);
    on<ClearRecommendation>(_clearRecommendation);
  }

  Future<void> _fetchRecommendationNews(FetchRecommendation event, Emitter<RecommendationState> emit) async {
    if (event.refreshIndicator || _cachedData == null || event.reFetch) {
      if(!event.reFetch){
        emit(RecommendationLoadingState());
      }
      try {

        final apiRepo = GetapiRepo(url: "$recommendationNewsURL/?page=$page", fromJson: RecommedationResponse.fromJson, isToken: true);
        final List<RecommedationResponse> response = await apiRepo.getData();
        _cachedData = response;
        _cachedData![0].data?.forEach((item){
          if(item.isFavorite! == 1){

            event.context?.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
          }else{
            event.context?.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
          }
        });
        emit(RecommendationSuccessState(recommendationNews: response));
      } catch (e) {
        emit(RecommendationErrorState(errorMessage: e.toString()));
      }
    } else {
      emit(RecommendationSuccessState(recommendationNews: _cachedData!));
    }
  }

  Future<void> _clearRecommendation(ClearRecommendation event, Emitter<RecommendationState> emit) async{
      emit(RecommendationSuccessState(recommendationNews: []));
  }

}


