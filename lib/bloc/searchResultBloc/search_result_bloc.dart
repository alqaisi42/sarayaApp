import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/searchResultBloc/search_result_event.dart';
import 'package:newsapp/bloc/searchResultBloc/search_result_state.dart';

import 'package:newsapp/config/api_routes.dart';
import '../../Model/search_result_model.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';



class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  int page = 1;
  bool isLoading = false;
  List<SearchResultResponse> searchResultList = [];


  String currentSearchQuery = '';

  SearchResultBloc() : super(SearchResultInitialState()) {

    on<FetchSearchResult>(_onFetchSearchResult);
    on<FetchMoreSearchResult>(_onFetchMoreSearchResult);
    on<EmptySearchResult>(_onEmptySearchResult);
  }
  Future<void> _onFetchSearchResult(FetchSearchResult event, Emitter<SearchResultState> emit,) async {
    page = 1;
    searchResultList.clear();
    currentSearchQuery = event.suggestionText;

    emit(SearchResultLoadingState([]));

    try {
      final response = await GetapiRepo(
        url: "$searchUrl?page=$page&per_page=10&search=$currentSearchQuery",
        fromJson: SearchResultResponse.fromJson,
        isToken: true,
      ).getData();

      searchResultList = response.toList();
      page++;

      if(event.context.mounted){
        _updateBookmarks(event.context,response);
      }
      emit(SearchResultSuccessState(searchResultData: searchResultList));
    } catch (error) {
      emit(SearchResultErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreSearchResult(FetchMoreSearchResult event, Emitter<SearchResultState> emit,) async {
    if (isLoading) return;

    isLoading = true;
    emit(SearchResultLoadingMoreState(List.from(searchResultList)));

    try {
      final response = await GetapiRepo(
        url: "$searchUrl?page=$page&per_page=10&search=$currentSearchQuery",
        fromJson: SearchResultResponse.fromJson,
        isToken: true,
      ).getData();

      searchResultList.addAll(response);
      page++;

      if(event.context.mounted){
        _updateBookmarks(event.context,response);
      }

      emit(SearchResultSuccessState(searchResultData: searchResultList));
    } catch (error) {
      emit(SearchResultErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }

  void _updateBookmarks(BuildContext context, List<SearchResultResponse> data) {
    data[0].data?.forEach((item) {
      if (item.isFavorite == 1) {
        context.read<BookmarkArticleBloc>().add(
            BookmarkArticleSoftAdd(slug: item.slug!));
      } else {
        context.read<BookmarkArticleBloc>().add(
            BookmarkArticleSoftRemove(slug: item.slug!));
      }
    });
  }

  void _onEmptySearchResult(EmptySearchResult event, Emitter<SearchResultState> emit,) {
    page = 1;
    searchResultList.clear();

    currentSearchQuery = '';

    emit(SearchResultInitialState());
  }


}