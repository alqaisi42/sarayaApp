import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/userChannelFollowListBloc/user_channelfollow_event.dart';
import 'package:newsapp/bloc/userChannelFollowListBloc/user_channelfollow_state.dart';
import 'package:newsapp/config/api_routes.dart';
import '../../Model/user_channel_follow_list.dart';
import '../blocRepository/get_api_repo.dart';

class UserChannelfollowBloc extends Bloc<UserChannelfollowEvent, UserChannelfollowState> {
  int page = 1;
  bool isLoading = false;
  List<UserChannelFollowedListResponse> userChannlFollowData = [];

  ScrollController scrollController = ScrollController();

  UserChannelfollowBloc() : super(UserChannelfollowInitialState()) {
    scrollController.addListener(_onScroll);
    on<FetchUserChannelfollow>(_onFetchUserChannelfollow);
    on<FetchMoreUserChannelfollow>(_onFetchMoreUserChannelfollow);
  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading) {
      add(FetchMoreUserChannelfollow());
    }
  }

  Future<void> _onFetchUserChannelfollow(
      FetchUserChannelfollow event, Emitter<UserChannelfollowState> emit) async {
    if (event.initialValue == 1) {
      page = 1;
      userChannlFollowData.clear();
    }


    if (page == 1) emit(UserChannelfollowLoadingState([]));

    try {
      List<UserChannelFollowedListResponse> newsArr = await GetapiRepo(
        url: "$userChannelsFollowedListUrl?page=$page&per_page=10",
        fromJson: UserChannelFollowedListResponse.fromJson,
        isToken: true,
      ).getData();

      userChannlFollowData.addAll(newsArr);
      page++;

      emit(UserChannelfollowSuccessState(userChannelFollowList: userChannlFollowData));
    } catch (error) {
      emit(UserChannelfollowErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onFetchMoreUserChannelfollow(
      FetchMoreUserChannelfollow event, Emitter<UserChannelfollowState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(UserChannelfollowLoadingMoreState(userChannlFollowData));

    try {
      List<UserChannelFollowedListResponse> newsArr = await GetapiRepo(
        url: "$userChannelsFollowedListUrl?page=$page&per_page=10",
        fromJson: UserChannelFollowedListResponse.fromJson,
        isToken: true,
      ).getData();

      userChannlFollowData.addAll(newsArr);
      page++;

      emit(UserChannelfollowSuccessState(userChannelFollowList: userChannlFollowData));
    } catch (error) {
      emit(UserChannelfollowErrorState(errorMessage: error.toString()));
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


