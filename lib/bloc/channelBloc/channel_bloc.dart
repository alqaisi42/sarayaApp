

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../../Model/channel_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';
import 'channel_event.dart';
import 'channel_state.dart';


class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  List<ChannelResponse>? cachedChannel;


  ChannelBloc() : super(ChannelInitialState()) {
    on<FetchChannels>(onFetchChannels);
    on<ClearChannelsData>(onClearChannelsData);
  }

  Future<void> onFetchChannels(FetchChannels event, Emitter<ChannelState> emit) async {
    if (event.refreshIndicator || cachedChannel == null || event.reFetch) {
      emit(ChannelLoadingState());
      try {
        final apiRepo = GetapiRepo<ChannelResponse>(
          url: channelsUrl,
          fromJson: ChannelResponse.fromJson, isToken: true,
        );
        final List<ChannelResponse> channelsData = await apiRepo.getData();
        cachedChannel = channelsData;
        if (event.context != null && event.context!.mounted) {
          _updateFollowUnfollowChannel(event.context!, channelsData);

        }

        emit(ChannelSuccessState(channelsData));

      } catch (e) {
        emit(ChannelErrorState(e.toString()));
      }
    } else {

      emit(ChannelSuccessState(cachedChannel!));
    }
  }

  Future<void>  onClearChannelsData(ClearChannelsData event, Emitter<ChannelState> emit) async {
    emit(ChannelSuccessState([]));
  }

  void _updateFollowUnfollowChannel(BuildContext context, List<ChannelResponse> data) {
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
