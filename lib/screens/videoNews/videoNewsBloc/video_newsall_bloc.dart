
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:newsapp/config/api_routes.dart';
import 'package:newsapp/screens/videoNews/videoNewsBloc/video_newsall_state.dart';
import 'package:newsapp/screens/videoNews/videoNewsBloc/video_news_all_event.dart';

import '../../../Model/popular_news_home_model.dart';
import '../../../bloc/blocRepository/get_api_repo.dart';
import '../../../bloc/bookmark/bookmark_article_bloc.dart';




class VideoNewsBloc extends Bloc<VideoNewsEvent, VideoNewsState> {
  int page = 1;
  bool isLoading = false;
  List<PopularHomeResponse> allNews = [];
  bool showAds = false;

  VideoNewsBloc() : super(VideoNewsInitialState()) {
    on<FetchVideoNews>(_onFetchVideoNews);
    on<FetchMoreVideoNews>(_onFetchMoreVideoNews);
  }

  Future<void> _onFetchVideoNews(
      FetchVideoNews event, Emitter<VideoNewsState> emit) async {
    if (event.initialValue == 1 || event.refreshIndicator) {
      page = 1;
      allNews.clear();
    }

    if (page == 1) emit(VideoNewsLoadingState(allNews));

    try {
      List<PopularHomeResponse> newsArr = await GetapiRepo(
        url: "$getVideoNews?page=$page&per_page=10",
        fromJson: PopularHomeResponse.fromJson,
        isToken: true,
      ).getData();

      allNews.addAll(newsArr);
      page++;

      allNews[0].data?.forEach((item) {
        if (item.isFavorite! == 1) {
          event.context.read<BookmarkArticleBloc>().add(
              BookmarkArticleSoftAdd(slug: item.slug!));
        } else {
          event.context.read<BookmarkArticleBloc>().add(
              BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });

      showAds = allNews[0].isAdsFree!;
      emit(VideoNewsSuccessState(videoNewsAll: allNews));
    } catch (error) {
      emit(VideoNewsErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreVideoNews(
      FetchMoreVideoNews event, Emitter<VideoNewsState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(VideoNewsLoadingMoreState(allNews));

    try {
      List<PopularHomeResponse> newsArr = await GetapiRepo(
        url: "$getVideoNews?page=$page&per_page=10",
        fromJson: PopularHomeResponse.fromJson,
        isToken: true,
      ).getData();

      allNews.addAll(newsArr);
      page++;

      allNews[0].data?.forEach((item) {
        if (item.isFavorite! == 1) {
          event.context.read<BookmarkArticleBloc>().add(
              BookmarkArticleSoftAdd(slug: item.slug!));
        } else {
          event.context.read<BookmarkArticleBloc>().add(
              BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });
      showAds = allNews[0].isAdsFree!;
      emit(VideoNewsSuccessState( videoNewsAll: allNews));
    } catch (error) {
      emit(VideoNewsErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }
}


