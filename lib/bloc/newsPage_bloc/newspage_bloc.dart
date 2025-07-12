import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newsapp/config/api_routes.dart';
import '../../Model/news_page_model.dart';
import '../blocRepository/get_api_repo.dart';
import '../commentsCountBloc/comment_count_bloc.dart';
import '../commentsCountBloc/comment_count_event.dart';
import '../viewCountBloc/view_count_bloc.dart';
import '../viewCountBloc/view_count_event.dart';
import 'newspage_event.dart';
import 'newspage_state.dart';

class NewsPageBloc extends Bloc<NewsPageEvent, NewsPageState> {
  int page = 1;
  bool isLoading = false;
  bool hasMoreData = true;
  bool isAdsFree = false;
  List<NewsPageResponse> newsPage = [];
  final Map<String, int> viewCounts = {};
  final Map<String, int> commentCounts = {};
  String channelSlugVal = "";
  String channelSortValue = "";
  String channelCategoryValue = "";
  ScrollController scrollController = ScrollController();

  NewsPageBloc() : super(NewsPageInitialState()) {
    scrollController.addListener(_onScroll);
    on<FetchNewsPagesData>(_onFetchNewsPagesData);
    on<FetchMoreFetchNewsPagesData>(_onFetchMoreNewsPagesData);
  }

  void _onScroll() {

    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading) {

      add(FetchMoreFetchNewsPagesData());
    }
  }


  Future<void> _onFetchNewsPagesData(
      FetchNewsPagesData event, Emitter<NewsPageState> emit) async {
    channelSlugVal = event.channelSlug;
    channelSortValue =  event.sortValue;
    channelCategoryValue = event.channelCategory;
    if (event.initialValue == 1) {
      page = 1;
      newsPage.clear();
    }
    if (event.refreshIndicator) {
      page = 1;
      newsPage.clear();
      hasMoreData = true;
    }

    if (page == 1) emit(NewsPageStateLoadingState(newsPage));

    try {
      List<NewsPageResponse> newsArr = await GetapiRepo(
        url: "$channelPageDataUrl/${event.channelSlug}?page=$page&per_page=10&short=${event.sortValue}&category=${event.channelCategory}",
        fromJson: NewsPageResponse.fromJson, isToken: true,
      ).getData();



      if (newsArr.isEmpty) {
        hasMoreData = false;
      } else {
        newsPage.addAll(newsArr);
        page++;
      }


      newsPage[0].data?.forEach((element) {
        if (element.slug != null && element.viewCount != null) {
          viewCounts[element.slug!] = element.viewCount!;
          commentCounts[element.slug!] = element.comment!;
        }
      });

      if (event.context.mounted) {
        event.context.read<ViewCountBloc>().add(InitializeViewCounts(initialCounts: viewCounts));
        event.context.read<CommentCountBloc>().add(InitializeCommentCounts(initialCounts: commentCounts));
      }

      isAdsFree = newsPage[0].isAdsFree!;

      emit(NewsPageStateSuccessState(newsPageData: newsPage));
    } catch (error) {
      emit(NewsPageStateErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreNewsPagesData(
      FetchMoreFetchNewsPagesData event, Emitter<NewsPageState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(NewsPageStateLoadingMoreState(newsPage));

    try {
      List<NewsPageResponse> newsArr = await GetapiRepo(
        url: "$channelPageDataUrl/$channelSlugVal?page=$page&per_page=5&short=$channelSortValue&category=$channelCategoryValue",
        fromJson: NewsPageResponse.fromJson, isToken: true,
      ).getData();



      if (newsArr.isEmpty) {
        hasMoreData = false;
      } else {
        newsPage.addAll(newsArr);
        page++;
      }
      isAdsFree = newsPage[0].isAdsFree!;
      emit(NewsPageStateSuccessState(newsPageData: newsPage));
    } catch (error) {
      emit(NewsPageStateErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }




  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}


