

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/channel_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';
import 'channel_preference_event.dart';
import 'channel_preference_state.dart';


class ChannelsPreferenceBloc extends Bloc<ChannelsPreferenceEvent, ChannelsPreferenceState> {
  List<ChannelResponse>? cachedChannels;

  ChannelsPreferenceBloc() : super(ChannelsPreferenceInitialState()) {
    on<FetchChannelsPreference>(onFetchChannelsPreference);
    on<ClearChannelsPreferenceData>(onClearChannelsPreferenceData);
  }

  Future<void> onFetchChannelsPreference(FetchChannelsPreference event, Emitter<ChannelsPreferenceState> emit) async {

    if (event.refreshIndicator || cachedChannels == null || event.reFetch) {
      emit(ChannelsPreferenceLoadingState());
      try {
        final apiRepo = GetapiRepo<ChannelResponse>(
          url: '$channelsUrl?page=1&per_page=25',
          fromJson: ChannelResponse.fromJson, isToken: true,
        );
        final List<ChannelResponse> channelsData = await apiRepo.getData();
        cachedChannels = channelsData;
        if (event.context != null && event.context!.mounted) {
          _updateFollowUnfollowChannels(event.context!, channelsData);
        }
        emit(ChannelsPreferenceSuccessState(channelsData));

      } catch (e) {
        emit(ChannelsPreferenceErrorState(e.toString()));
      }
    } else {

      emit(ChannelsPreferenceSuccessState(cachedChannels!));
    }
  }

  Future<void> onClearChannelsPreferenceData(ClearChannelsPreferenceData event, Emitter<ChannelsPreferenceState> emit) async {
    emit(ChannelsPreferenceSuccessState([]));
  }

  void _updateFollowUnfollowChannels(BuildContext context, List<ChannelResponse> data) {
    data[0].data!.channels?.forEach((item) {
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