

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/constants.dart';


import '../../../bloc/followedChannelsPostBloc/followed_channels_post_bloc.dart';
import '../../../bloc/followedChannelsPostBloc/followed_channels_post_event.dart';
import '../../../bloc/followedChannelsPostBloc/followed_channels_post_state.dart';

import '../../../config/googleAdMob/banner_ad.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';


import '../../../utils/widgets/custome_dispay_newscard.dart';
import '../../../utils/widgets/custome_title.dart';

import '../../../l10n/app_localizations.dart';
class UserFollowedChannelNews extends StatefulWidget {
  const UserFollowedChannelNews({super.key});

  @override
  UserFollowedChannelNewsState createState() => UserFollowedChannelNewsState();
}

class UserFollowedChannelNewsState extends State<UserFollowedChannelNews> {

  bool isError = false;

  @override
  void initState() {
    super.initState();
    context.read<FollowedChannelsPostBloc>().add(FetchFollowedChannelsPost(context: context,));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowedChannelsPostBloc, FollowedChannelsPostState>(
      builder: (context, state) {
        if (state is FollowedChannelsPostLoadingState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
                ),
                child: Column(
                  children: List.generate(5, (index) {
                    return ShimmerWidget(
                      width: MediaQueryHelper.screenWidth(context),
                      height: MediaQueryHelper.screenHeight(context) * 0.1,
                      margin: EdgeInsets.only(
                        bottom: MediaQueryHelper.screenWidth(context) * 0.04,
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        } else if (state is FollowedChannelsPostSuccessState &&
            state.followedChannelPostData.isNotEmpty &&
            state.followedChannelPostData[0].data != null &&
            state.followedChannelPostData[0].data!.isNotEmpty) {

          isError = state.followedChannelPostData[0].error == true;

          final userChannelsFollowed = state.followedChannelPostData[0].data!.length > 5
              ? 5
              : state.followedChannelPostData[0].data!.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: MediaQueryHelper.screenWidth(context) * 0.04,
                  top: MediaQueryHelper.screenHeight(context) * 0.03,
                  right: MediaQueryHelper.screenWidth(context) * 0.04,
                ),
                child: CustomeTitle(
                  title: AppLocalizations.of(context)!.fromChannelsYouFollowed,
                  title2: AppLocalizations.of(context)!.seeAll,
                  onTap: () {
                    GoRouter.of(context).push("/userFollowedChannelNewsAll");
                  },
                ),
              ),
              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
              SizedBox(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userChannelsFollowed + (userChannelsFollowed ~/ 4),
                  itemBuilder: (context, index) {
                    if (state.followedChannelPostData[0].isAdsFree == false) {
                      if (index > 0 && index % 4 == 0) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: AdBannerWidget(),
                        );
                      }
                    }

                    final dataIndex = index - (index ~/ 4);

                    if (dataIndex >= state.followedChannelPostData[0].data!.length) {
                      return const SizedBox.shrink();
                    }

                    final item = state.followedChannelPostData[0].data![dataIndex];

                    return GestureDetector(
                      onTap: () async {
                        checkLimitAndNavigate(context, item.slug.toString());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
                        ),
                        child: DisplayPopularNews(
                          id: item.id ?? 0,
                          viewCount: item.viewCount ?? 0,
                          coverImg: item.image ?? '',
                          title: item.title ?? '',
                          channelSlug: item.channelSlug ?? '',
                          logo: item.channelLogo ?? '',
                          publisher: item.channelName ?? '',
                          time: item.publishDate ?? '',
                          slug: item.slug ?? '',
                          postType: item.postType ?? "",
                          videoThumb: item.videoThumb ?? "",
                          video: item.videoUrl ?? "",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is FollowedChannelsPostErrorState && isError)  {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(color: Colors.red, fontFamily: fontType),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

}
