
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/recommendation_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';
import 'followed_channels_post_event.dart';
import 'followed_channels_post_state.dart';

class FollowedChannelsPostBloc extends Bloc<FollowedChannelsPostEvent, FollowedChannelsPostState> {
  int page = 1;
  bool isLoading = false;
  bool hasMoreData = true;
  List<RecommedationResponse> folloedPostData = [];
  bool isAdsFree = false;

  FollowedChannelsPostBloc() : super(FollowedChannelsPostInitialState()) {
    on<FetchFollowedChannelsPost>(_onFetchFollowedChannelsPost);
    on<FetchMoreFollowedChannelsPost>(_onFetchMoreFollowedChannelsPost);
  }

  Future<void> _onFetchFollowedChannelsPost(
      FetchFollowedChannelsPost event, Emitter<FollowedChannelsPostState> emit) async {
    if (event.initialValue == 1) {
      page = 1;
      folloedPostData.clear();
      hasMoreData = true;
    }
    if (event.refreshIndicator) {
      page = 1;
      folloedPostData.clear();
      hasMoreData = true;
    }

    if (page == 1) emit(FollowedChannelsPostLoadingState(folloedPostData));

    try {
      List<RecommedationResponse> recommendationsArr = await GetapiRepo(
        url: "$followedChannelsPostUrl?page=$page&per_page=10",
        fromJson: RecommedationResponse.fromJson,
        isToken: true,
      ).getData();

      // Check if there's more data
      if (recommendationsArr.isEmpty || (recommendationsArr[0].data?.isEmpty ?? true)) {
        hasMoreData = false;
      } else {
        folloedPostData.addAll(recommendationsArr);
        page++;

        // Only process bookmarks if we have data
        if (folloedPostData.isNotEmpty && folloedPostData[0].data != null) {
          folloedPostData[0].data?.forEach((item) {
            if (item.isFavorite! == 1) {
              event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
            } else {
              event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
            }
          });
        }
      }

      isAdsFree = folloedPostData[0].isAdsFree!;

      emit(FollowedChannelsPostSuccessState(
          followedChannelPostData: folloedPostData,
          hasMoreData: hasMoreData
      ));
    } catch (error) {
      emit(FollowedChannelsPostErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreFollowedChannelsPost(
      FetchMoreFollowedChannelsPost event, Emitter<FollowedChannelsPostState> emit) async {
    if (isLoading || !hasMoreData) return; // Don't fetch more if there's no more data

    isLoading = true;
    emit(FollowedChannelsPostLoadingMoreState(folloedPostData));

    try {
      List<RecommedationResponse> recommendationsArr = await GetapiRepo(
        url: "$followedChannelsPostUrl?page=$page&per_page=10",
        fromJson: RecommedationResponse.fromJson,
        isToken: true,
      ).getData();

      // Check if there's more data
      if (recommendationsArr.isEmpty || (recommendationsArr[0].data?.isEmpty ?? true)) {
        hasMoreData = false;
      } else {
        folloedPostData.addAll(recommendationsArr);
        page++;

        // Process bookmarks for the new data
        int lastIndex = folloedPostData.length - 1;
        if (lastIndex >= 0 && folloedPostData[lastIndex].data != null) {
          folloedPostData[lastIndex].data?.forEach((item) {
            if (item.isFavorite! == 1) {
              event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: item.slug!));
            } else {
              event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: item.slug!));
            }
          });
        }
      }
      isAdsFree = folloedPostData[0].isAdsFree!;
      emit(FollowedChannelsPostSuccessState(
          followedChannelPostData: folloedPostData,
          hasMoreData: hasMoreData
      ));
    } catch (error) {
      emit(FollowedChannelsPostErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }
}


