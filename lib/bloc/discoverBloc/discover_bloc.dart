import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Model/discover_model.dart';
import 'package:newsapp/bloc/bookmark/bookmark_article_bloc.dart';

import 'package:newsapp/config/api_routes.dart';

import '../blocRepository/get_api_repo.dart';
import 'discover_event.dart';
import 'discover_state.dart';



class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  List<DiscoverResponse> discoverAll = [];
  int currentPage = 1;
  static const int perPage = 10;
  bool hasMore = true;

  DiscoverBloc() : super(DiscoverNewsInitialState()) {
    on<FetchDiscover>(_onFetchDiscoverNews);
    on<FetchMoreDiscover>(_onFetchMoreDiscoverNews);
  }

  Future<void> _onFetchDiscoverNews(
      FetchDiscover event, Emitter<DiscoverState> emit) async {
    emit(DiscoverNewsLoadingState());
    try {
      currentPage = 1;
      discoverAll = [];

      List<DiscoverResponse> newData = await GetapiRepo(
        url: "$discoverNewsUrl?page=$currentPage&per_page=$perPage",
        fromJson: DiscoverResponse.fromJson,
        isToken: true,
      ).getData();

      discoverAll = newData;

      if(event.context.mounted){
        _updateBookmarks(event.context, newData);
      }

      hasMore = newData[0].data?.length == perPage;

      emit(DiscoverNewsSuccessState(
        discoverNews: discoverAll,
        hasMoreData: hasMore,
      ));
    } catch (error) {
      emit(DiscoverNewsErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreDiscoverNews(
      FetchMoreDiscover event, Emitter<DiscoverState> emit) async {
    if (!hasMore) return;

    emit(DiscoverNewsLoadingMoreState(discoverNews:discoverAll));
    try {
      currentPage++;

      List<DiscoverResponse> newData = await GetapiRepo(
        url: "$discoverNewsUrl?page=$currentPage&per_page=$perPage",
        fromJson: DiscoverResponse.fromJson,
        isToken: true,
      ).getData();

     if(event.context.mounted){
       _updateBookmarks(event.context, newData);
     }

      if (discoverAll.isNotEmpty && newData.isNotEmpty) {
        discoverAll[0].data?.addAll(newData[0].data ?? []);
      } else {
        discoverAll = newData;
      }

      hasMore = newData[0].data?.length == perPage;

      emit(DiscoverNewsSuccessState(
        discoverNews: discoverAll,
        hasMoreData: hasMore,
      ));
    } catch (error) {
      emit(DiscoverNewsErrorState(errorMessage: error.toString()));

    }
  }

  void _updateBookmarks(BuildContext context, List<DiscoverResponse> data) {
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
}