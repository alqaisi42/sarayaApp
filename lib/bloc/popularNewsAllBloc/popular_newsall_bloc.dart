
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/popularNewsAllBloc/popular_newsall_event.dart';
import 'package:newsapp/bloc/popularNewsAllBloc/popular_newsall_state.dart';

import 'package:newsapp/config/api_routes.dart';


import '../../Model/popular_news_home_model.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';

class PopularNewsAllBloc extends Bloc<PopularNewsAllEvent, PopularNewsAllState> {
  int page = 1;
  bool isLoading = false;
  List<PopularHomeResponse> allNews = [];
  bool showAds = false;

  PopularNewsAllBloc() : super(PopularNewsAllInitialState()) {

    on<FetchPopularNewsAll>(_onFetchPopularNewsAll);
    on<FetchMorePopularNewsAll>(_onFetchMorePopularNewsAll);
  }



  Future<void> _onFetchPopularNewsAll(
      FetchPopularNewsAll event, Emitter<PopularNewsAllState> emit) async {
    if (event.initialValue == 1) {
      page = 1;
      allNews.clear();
    }
    if (event.refreshIndicator) {
      page = 1;
      allNews.clear();
    }

    if (page == 1) emit(PopularNewsAllLoadingState(allNews));

    try {
      List<PopularHomeResponse> newsArr = await GetapiRepo(
        url: "$popularNewsAllUrl?page=$page&per_page=10",
        fromJson: PopularHomeResponse.fromJson, isToken: true,
      ).getData();

      allNews.addAll(newsArr);
      page++;
      allNews[0].data?.forEach((item){
        if(item.isFavorite! == 1){

          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
        }else{
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });
      showAds = allNews[0].isAdsFree!;
      emit(PopularNewsAllSuccessState(popularNewsAll: allNews));
    } catch (error) {
      emit(PopularNewsAllErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMorePopularNewsAll(
      FetchMorePopularNewsAll event, Emitter<PopularNewsAllState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(PopularNewsAllLoadingMoreState(allNews));

    try {
      List<PopularHomeResponse> newsArr = await GetapiRepo(
        url: "$popularNewsAllUrl?page=$page&per_page=10",
        fromJson: PopularHomeResponse.fromJson, isToken: true,
      ).getData();

      allNews.addAll(newsArr);
      page++;
      allNews[0].data?.forEach((item){
        if(item.isFavorite! == 1){

          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
        }else{
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });
      showAds = allNews[0].isAdsFree!;
      emit(PopularNewsAllSuccessState(popularNewsAll: allNews));
    } catch (error) {
      emit(PopularNewsAllErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }

}

