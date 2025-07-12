
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Model/bookmark_model.dart';
import 'package:newsapp/bloc/bookmark/bookmark_article_bloc.dart';

import 'package:newsapp/config/api_routes.dart';


import '../blocRepository/get_api_repo.dart';

import 'bookmakr_event.dart';
import 'bookmark_state.dart';



class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  int page = 1;
  bool isLoading = false;
  List<BookmarkResponse> bookmarks = [];


  BookmarkBloc() : super(BookmarkInitialState()) {
    on<FetchBookmark>(_onFetchBookmark);
    on<FetchMoreBookmark>(_onFetchMoreBookmark);
  }

  Future<void> _onFetchBookmark(
      FetchBookmark event, Emitter<BookmarkState> emit) async {
    if (event.initialValue == 1) {
      page = 1;
      bookmarks.clear();
    }
    if (event.refreshIndicator) {
      page = 1;
      bookmarks.clear();
    }

    if (page == 1) emit(BookmarkLoadingState(bookmarks));

    try {
      List<BookmarkResponse> bookmarkArr = await GetapiRepo(
        url: "$bookmarkUrl?page=$page&per_page=10",
        fromJson: BookmarkResponse.fromJson,
        isToken: true,
      ).getData();

      bookmarks.addAll(bookmarkArr);
      page++;


      bookmarks[0].data?.forEach((item){
        if(item.isFavorit == "1"){
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
        }else {
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });

      // bookmarks[0].data?.forEach((item) {
      //   if (item.isFavorit == 1) {
      //     print("vdvxcdzvxcz");
      //     event.context.read<BookmarkArticleBloc>().add(
      //         BookmarkArticleSoftAdd(slug: item.slug!));
      //   } else {
      //     event.context.read<BookmarkArticleBloc>().add(
      //         BookmarkArticleSoftRemove(slug: item.slug!));
      //   }
      // });


      emit(BookmarkSuccessState(bookmarkAll: bookmarks));
    } catch (error) {
      emit(BookmarkErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreBookmark(
      FetchMoreBookmark event, Emitter<BookmarkState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(BookmarkLoadingMoreState(bookmarks));

    try {
      List<BookmarkResponse> bookmarkArr = await GetapiRepo(
        url: "$bookmarkUrl?page=$page&per_page=10",
        fromJson: BookmarkResponse.fromJson,
        isToken: true,
      ).getData();

      bookmarks.addAll(bookmarkArr);
      page++;

      bookmarks[0].data?.forEach((item){
        if(item.isFavorit == "1"){
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
        }else {
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });

      emit(BookmarkSuccessState(bookmarkAll: bookmarks));
    } catch (error) {
      emit(BookmarkErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }
}