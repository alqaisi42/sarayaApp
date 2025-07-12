

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:newsapp/config/api_routes.dart';


import '../../Model/popular_news_home_model.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';
import 'category_event.dart';
import 'category_state.dart';



class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  int page = 1;
  bool isLoading = false;
  List<PopularHomeResponse> categoryListArr = [];
  bool showAds =  false;

  ScrollController scrollController = ScrollController();
  String currentCategory = '';

  CategoryBloc() : super(CategoryInitialState()) {
    scrollController.addListener(_onScroll);
    on<FetchCategoryContent>(_onFetchCategoryContent);
    on<FetchMoreCategoryContent>(_onFetchMoreCategoryContent);

  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading) {
      add(FetchMoreCategoryContent());
    }
  }

  Future<void> _onFetchCategoryContent(
      FetchCategoryContent event, Emitter<CategoryState> emit) async {
    currentCategory = event.category;
    if (event.initialValue == 1) {
      page = 1;
      categoryListArr.clear();
    }
    if (event.refreshIndicator) {
      page = 1;
      categoryListArr.clear();
    }

    if (page == 1) emit(CategoryLoadingState(categoryListArr));

    try {
      List<PopularHomeResponse> categories = await GetapiRepo(
        url: "$categoryUrl$currentCategory?page=$page&per_page=10",
        fromJson: PopularHomeResponse.fromJson,
        isToken: true,
      ).getData();

      categoryListArr.addAll(categories);
      page++;

      categoryListArr[0].data?.forEach((item){
        if(item.isFavorite! == 1){

          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
        }else{
          event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
        }
      });

      showAds = categoryListArr[0].isAdsFree!;
      emit(CategorySuccessState(categoryList: categoryListArr));
    } catch (error) {
      emit(CategoryErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreCategoryContent(
      FetchMoreCategoryContent event, Emitter<CategoryState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(CategoryLoadingMoreState(categoryListArr));

    try {
      List<PopularHomeResponse> categories = await GetapiRepo(
        url: "$categoryUrl$currentCategory?page=$page&per_page=10",
        fromJson: PopularHomeResponse.fromJson,
        isToken: true,
      ).getData();

      categoryListArr.addAll(categories);
      page++;

      showAds = categoryListArr[0].isAdsFree!;

      emit(CategorySuccessState(categoryList: categoryListArr));
    } catch (error) {
      emit(CategoryErrorState(errorMessage: error.toString()));
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



