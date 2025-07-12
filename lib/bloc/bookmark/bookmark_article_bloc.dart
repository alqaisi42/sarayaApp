
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Model/fevorites_model.dart';
import 'package:newsapp/bloc/blocRepository/post_api_repo.dart';

import 'package:newsapp/config/api_routes.dart';
import 'package:newsapp/utils/widgets/favorite_button.dart';


import '../../config/helper/helper_functions.dart';
import '../../../l10n/app_localizations.dart';
import '../bookmarkBloc/bookmakr_event.dart';
import '../bookmarkBloc/bookmark_bloc.dart';
import '../followedChannelsPostBloc/followed_channels_post_bloc.dart';
import '../followedChannelsPostBloc/followed_channels_post_event.dart';
import '../recommendationNewsBloc/recommendation_bloc.dart';
import '../recommendationNewsBloc/recommendation_event.dart';

part 'bookmark_article_event.dart';
part 'bookmark_article_state.dart';





class BookmarkArticleBloc extends Bloc<BookmarkArticleEvent, BookmarkArticleState> {
  BookmarkArticleBloc() : super(BookmarkArticleAll(slugs: [])) {
    on<BookmarkArticleSoftAdd>(_onSoftAdd);
    on<BookmarkArticleSoftRemove>(_onSoftRemove);
    on<BookmarkArticleAdd>(_onAdd);
    on<BookmarkArticleRemove>(_onRemove);
    on<EmptyBookmarkDetails>(_onEmpty);
  }

  Future<void> _onSoftAdd(BookmarkArticleSoftAdd event, Emitter<BookmarkArticleState> emit) async {
    if (state is BookmarkArticleAll) {
      var currentState = state as BookmarkArticleAll;
      if (!currentState.slugs.contains(event.slug)) {
        emit(BookmarkArticleAll(slugs: [...currentState.slugs, event.slug]));
      }
    }
  }

  Future<void> _onSoftRemove(BookmarkArticleSoftRemove event, Emitter<BookmarkArticleState> emit) async {
    if (state is BookmarkArticleAll) {
      var currentState = state as BookmarkArticleAll;
      if (currentState.slugs.contains(event.slug)) {
        emit(BookmarkArticleAll(
          slugs: currentState.slugs.where((slug) => slug != event.slug).toList(),
        ));
      }
    }
  }

  Future<void> _onAdd(BookmarkArticleAdd event, Emitter<BookmarkArticleState> emit) async {
    if (state is BookmarkArticleAll) {
      if (!await isLogged()) {
        if(event.context.mounted){
          CustomFloatingSnackBar.showCustomSnackBar(
            event.context,
            AppLocalizations.of(event.context)!.youNeedToLoginToUseThisFeature,0
          );
        }
        return;
      }

      var currentState = state as BookmarkArticleAll;
      if (!currentState.slugs.contains(event.slug)) {
        if (event.slugType == "bookmark") {
          final PostapiRepo postapiRepo = PostapiRepo(fromJson: FevoriteResponse.fromJson, isToken: true);
          await postapiRepo.postData(favoritesAddURL, slug: event.slug);
          if(event.context.mounted){
            event.context.read<BookmarkBloc>().add(FetchBookmark(initialValue: 1,context: event.context));
            event.context.read<RecommendationBloc>().add(FetchRecommendation(refreshIndicator: true,context: event.context));
          }
        } else {
          final PostapiRepo postapiRepo = PostapiRepo(fromJson: FevoriteResponse.fromJson, isToken: true);
          await postapiRepo.postData("$followChannelUrl/${event.slug}");
         if(event.context.mounted){
           event.context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: event.context,));
           event.context.read<RecommendationBloc>().add(FetchRecommendation(reFetch: true,context: event.context));
         }
        }
        emit(BookmarkArticleAll(slugs: [...currentState.slugs, event.slug]));
      }
    }
  }

  Future<void> _onRemove(BookmarkArticleRemove event, Emitter<BookmarkArticleState> emit) async {
    if (!await isLogged()) {
      if(event.context.mounted){
        CustomFloatingSnackBar.showCustomSnackBar(
          event.context,
          AppLocalizations.of(event.context)!.youNeedToLoginToUseThisFeature,0
        );
      }
      return;
    }

    if (state is BookmarkArticleAll) {
      var currentState = state as BookmarkArticleAll;
      if (currentState.slugs.contains(event.slug)) {
        if (event.slugType == "bookmark") {
          final PostapiRepo postapiRepo = PostapiRepo(fromJson: FevoriteResponse.fromJson, isToken: true);

          await postapiRepo.postData(favoritesRemoveURL, slug: event.slug);
          if(event.context.mounted){
            event.context.read<BookmarkBloc>().add( FetchBookmark(initialValue: 1,context: event.context));
          }
        } else {
          // for follow and Unfollow channels
          final PostapiRepo postapiRepo = PostapiRepo(fromJson: FevoriteResponse.fromJson, isToken: true);
          await postapiRepo.postData("$unFollowChannelUrl/${event.slug}");
          if(event.context.mounted){
          event.context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: event.context,));
          event.context.read<RecommendationBloc>().add(FetchRecommendation(reFetch: true,context: event.context));
          }
        }
        emit(BookmarkArticleAll(
          slugs: currentState.slugs.where((slug) => slug != event.slug).toList(),
        ));
      }
    }
  }

  Future<void> _onEmpty(EmptyBookmarkDetails event, Emitter<BookmarkArticleState> emit) async {
    emit(BookmarkArticleAll(slugs: []));
  }

}
