
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/recommendationNewAllBloc/recommendation_newsall_state.dart';
import 'package:newsapp/bloc/recommendationNewAllBloc/recommendation_newsall_event.dart';

import '../../Model/recommendation_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';

class RecommendationAllBloc extends Bloc<RecommendationAllEvent, RecommendationAllState> {
  int page = 1;
  bool isLoading = false;
  List<RecommedationResponse> allRecommendations = [];
   bool showAds = false;

  RecommendationAllBloc() : super(RecommendationAllInitialState()) {
    on<FetchRecommendationAll>(_onFetchRecommendationAll);
    on<FetchMoreRecommendationAll>(_onFetchMoreRecommendationAll);
  }

  Future<void> _onFetchRecommendationAll(
      FetchRecommendationAll event, Emitter<RecommendationAllState> emit) async {
    if (event.initialValue == 1) {
      page = 1;
      allRecommendations.clear();
    }
    if (event.refreshIndicator) {
      page = 1;
      allRecommendations.clear();
    }

    if (page == 1) emit(RecommendationAllLoadingState(allRecommendations));

    try {
      List<RecommedationResponse> recommendationsArr = await GetapiRepo(
        url: "$recommendationNewsURL?page=$page&per_page=10&",
        fromJson: RecommedationResponse.fromJson,
        isToken: true,
      ).getData();

      allRecommendations.addAll(recommendationsArr);
      page++;
      allRecommendations[0].data?.forEach((item) {
        if (item.isFavorite! == 1) {
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
        } else {
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });

      showAds = recommendationsArr[0].isAdsFree!;
      emit(RecommendationAllSuccessState(recommendations: allRecommendations));
    } catch (error) {
      emit(RecommendationAllErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreRecommendationAll(
      FetchMoreRecommendationAll event, Emitter<RecommendationAllState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(RecommendationAllLoadingMoreState(allRecommendations));

    try {
      List<RecommedationResponse> recommendationsArr = await GetapiRepo(
        url: "$recommendationNewsURL?page=$page&per_page=10&",
        fromJson: RecommedationResponse.fromJson,
        isToken: true,
      ).getData();

      allRecommendations.addAll(recommendationsArr);
      page++;
      allRecommendations[0].data?.forEach((item) {
        if (item.isFavorite! == 1) {
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
        } else {
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });
      showAds = recommendationsArr[0].isAdsFree!;
      emit(RecommendationAllSuccessState(recommendations: allRecommendations));
    } catch (error) {
      emit(RecommendationAllErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }
}
