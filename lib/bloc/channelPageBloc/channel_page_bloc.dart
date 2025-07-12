import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/channel_page_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import '../bookmark/bookmark_article_bloc.dart';
import 'channel_page_event.dart';
import 'channel_page_state.dart';

class ChannelPageBloc extends Bloc<ChannelPageEvent, ChannelPageState> {
  ChannelPageBloc() : super(ChannelPageInitialState()) {
    on<FetchChannelPage>(onFetchChannelsPage);
  }

  Future<void> onFetchChannelsPage(FetchChannelPage event, Emitter<ChannelPageState> emit) async {
    if (event.refreshIndicator) {
      emit(ChannelPageLoadingState());

      try {
        final apiRepo = GetapiRepo<ChannelPageResponse>(
          url: "$getChannelPageUrl/${event.channelSlug}",
          fromJson: ChannelPageResponse.fromJson,
          isToken: true,
        );
        final List<ChannelPageResponse> channelsData = await apiRepo.getData();

        if (event.context.mounted) {
          if (channelsData[0].data?.isFollowed == 1) {
            event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftAdd(slug: channelsData[0].data!.slug.toString()));
          } else {
            event.context.read<BookmarkArticleBloc>().add(BookmarkArticleSoftRemove(slug: channelsData[0].data!.slug.toString()));
          }
        }

        emit(ChannelPageSuccessState(channelsData));
      } catch (e) {
        emit(ChannelPageErrorState(e.toString()));
      }
    }
  }
}
