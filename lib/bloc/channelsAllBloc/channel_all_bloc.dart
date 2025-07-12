import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newsapp/config/api_routes.dart';


import '../../Model/channel_response.dart';

import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';
import 'channel_all_event.dart';
import 'channel_all_state.dart';


class ChannelsAllBloc extends Bloc<ChannelAllEvent, ChannelsAllState> {
  int page = 1;
  bool isLoading = false;
  List<ChannelAllResponse> allChannels = [];



  ChannelsAllBloc() : super(ChannelsAllInitialState()) {
    on<FetchChannelAll>(_onFetchChannelsAll);
    on<FetchMoreChannelAll>(_onFetchMoreChannelsAll);
  }


  Future<void> _onFetchChannelsAll(FetchChannelAll event, Emitter<ChannelsAllState> emit) async {
    if (event.initialValue == 1) {
      page = 1;
      allChannels.clear();
    }
    if (event.refreshIndicator) {
      page = 1;
      allChannels.clear();
    }

    if (page == 1) emit(ChannelsAllLoadingState(allChannels));

    try {
      List<ChannelAllResponse> channels = await GetapiRepo(
        url: "$channelsUrl?page=$page&per_page=10",
        fromJson: ChannelAllResponse.fromJson,
        isToken: true,
      ).getData();

      allChannels.addAll(channels);
      page++;
      if(event.context.mounted){
        _updateFollowUnfollowChannel(event.context,channels);
      }
      emit(ChannelsAllSuccessState(channelsAll: allChannels));
    } catch (error) {
      emit(ChannelsAllErrorState(errorMessage: error.toString()));
    }
  }


  Future<void> _onFetchMoreChannelsAll(FetchMoreChannelAll event, Emitter<ChannelsAllState> emit) async {
    if (isLoading) return;

    isLoading = true;
    emit(ChannelsAllLoadingMoreState(allChannels));
    try {
      List<ChannelAllResponse> channels = await GetapiRepo(
        url: "$channelsUrl?page=$page&per_page=10",
        fromJson: ChannelAllResponse.fromJson,
        isToken: true,
      ).getData();

      allChannels.addAll(channels);
      page++;
     if(event.context.mounted){
       _updateFollowUnfollowChannel(event.context,channels);
     }
      emit(ChannelsAllSuccessState(channelsAll: allChannels));
    } catch (error) {
      emit(ChannelsAllErrorState(errorMessage: error.toString()));
    } finally {
      isLoading = false;
    }
  }

  void _updateFollowUnfollowChannel(BuildContext context, List<ChannelAllResponse> data) {
    data[0].data?.channels?.forEach((item) {
      if (item.isFollow == 1) {
        context.read<BookmarkArticleBloc>().add(
            BookmarkArticleSoftAdd(slug: item.slug!));
      } else {
        context.read<BookmarkArticleBloc>().add(
            BookmarkArticleSoftRemove(slug: item.slug!));
      }
    });
  }
}

