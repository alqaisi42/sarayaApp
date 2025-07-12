import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/bookmark/bookmark_article_bloc.dart';
import 'package:newsapp/bloc/popularHomeNewsBloc/popular_news_home_event.dart';
import 'package:newsapp/bloc/popularHomeNewsBloc/popular_news_home_state.dart';

import 'package:newsapp/config/api_routes.dart';

import '../../Model/popular_news_home_model.dart';
import '../blocRepository/get_api_repo.dart';
import '../viewCountBloc/view_count_bloc.dart';
import '../viewCountBloc/view_count_event.dart';





class PopularBloc extends Bloc<PopularEvent, PopularState> {
  List<PopularHomeResponse>? _cachedPopularNews;
  late Map<String, String> isFavoritesStatus = {};
  bool reFetchApi = false;

  PopularBloc() : super(PopularInitialState()) {
    on<FetchPopular>(_fetchPopularNews);
    on<ClearPopularsData>(_clearPopularsData);
  }


  Future<void> _fetchPopularNews(FetchPopular event, Emitter<PopularState> emit) async {

    reFetchApi = event.reFetch;
    if (event.refreshIndicator || _cachedPopularNews == null || event.reFetch) {


      if(!event.reFetch){
        emit(PopularLoadingState());
      }

      try {
        final apiRepo = GetapiRepo(url: popularNewsAllUrl, fromJson: PopularHomeResponse.fromJson, isToken: true);
        final List<PopularHomeResponse> response = await apiRepo.getData();
        _cachedPopularNews = List<PopularHomeResponse>.from(response);
        var data = List<PopularHomeResponse>.from(_cachedPopularNews ?? []);


        final Map<String, int> viewCounts = {};

        data[0].data?.forEach((element){

          if (element.slug != null && element.viewCount != null) {
            viewCounts[element.slug!] = element.viewCount!;
          }

          if(element.isFavorite == 1){
            event.context?.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: element.slug!));
          }else{
            event.context?.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: element.slug!));
          }


        });
        event.context?.read<ViewCountBloc>().add(InitializeViewCounts(initialCounts: viewCounts));

        emit(PopularSuccessState(
          popularNews: List<PopularHomeResponse>.from(_cachedPopularNews ?? []),
        ));
      } catch (e) {
        emit(PopularErrorState(errorMessage: e.toString()));
      }
    } else {
      emit(PopularSuccessState(
        popularNews: List<PopularHomeResponse>.from(_cachedPopularNews ?? []),
      ));
    }
  }

  Future<void>  _clearPopularsData(ClearPopularsData event, Emitter<PopularState> emit) async {
    emit(PopularInitialState());
  }


}