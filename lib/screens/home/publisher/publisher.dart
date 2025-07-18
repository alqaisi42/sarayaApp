import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import 'package:newsapp/config/shimmer.dart';


import '../../../bloc/bookmark/bookmark_article_bloc.dart';
import '../../../bloc/channelBloc/channel_bloc.dart';
import '../../../bloc/channelBloc/channel_event.dart';
import '../../../bloc/channelBloc/channel_state.dart';

import '../../../config/constants.dart';


import '../../../config/helper/helper_functions.dart';
import '../../../utils/widgets/custome_title.dart';
import '../../../l10n/app_localizations.dart';

import '../../../utils/widgets/follow_channel.dart';

class Publisher extends StatefulWidget {
  const Publisher({super.key});

  @override
  State<Publisher> createState() => _PublisherState();
}

class _PublisherState extends State<Publisher> {
  @override
  void initState() {
    context.read<ChannelBloc>().add(FetchChannels(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookmarkArticleBloc, BookmarkArticleState>(
        listener: (context, state) {

    },
    child: Container(
      margin:
          EdgeInsets.only(left: MediaQueryHelper.screenWidth(context) * 0.04,top: MediaQueryHelper.screenHeight(context) * 0.03),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQueryHelper.screenWidth(context) * 0.02),
            child: CustomeTitle(
              title: AppLocalizations.of(context)!.channelsYouMayLike,
              title2: AppLocalizations.of(context)!.seeAll,
              onTap: () {
                GoRouter.of(context).push("/channelsAll");
              },
            ),
          ),
          SizedBox(
            height: MediaQueryHelper.screenHeight(context) * 0.01,
          ),
          BlocBuilder<ChannelBloc, ChannelState>(
            builder: (context, state) {
              if (state is ChannelLoadingState) {
                return SizedBox(
                  height: MediaQueryHelper.screenHeight(context) * 0.06,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ShimmerWidget(
                        width: MediaQueryHelper.screenWidth(context) * 0.3,
                        height: MediaQueryHelper.screenHeight(context) * 0,
                        margin: EdgeInsets.only(
                            right:
                                MediaQueryHelper.screenWidth(context) * 0.04),
                      );
                    },
                  ),
                );

              } else if (state is ChannelSuccessState) {
                final channelsData = state.channels.first.data;

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.19,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: channelsData!.channels!.length >= 5 ? 5 : channelsData.channels!.length,
                    itemBuilder: (context, index) {
                      final channelData = channelsData.channels![index];
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context)
                              .push("/customNewsPage/${channelData.slug}");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          margin: EdgeInsets.only(
                            right: MediaQueryHelper.screenWidth(context) * 0.04,
                          ),
                          padding:  EdgeInsets.all(8.0),
                          width: MediaQueryHelper.screenWidth(context) * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 60,
                                  height: 60,
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.white, // Background color
                                      width: 60,
                                      height: 60,
                                      child: Image.asset(
                                        'assets/img/new_logo.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  )
                              ),
                              SizedBox(
                                  height:
                                      MediaQueryHelper.screenHeight(context) *
                                          0.01),
                              Text(
                                channelData.name ?? "",
                                style:  TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontType
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center, // Center the text
                              ),
                              SizedBox(
                                  height:
                                      MediaQueryHelper.screenHeight(context) *
                                          0.01),
                            FollowButton(
                                  channelslug: channelData.slug.toString(),
                                ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is ChannelErrorState) {
                return Text('${AppLocalizations.of(context)!.error}: ${state.errorMessage}',style: TextStyle(fontFamily: fontType),);
              } else {
                return const Text('');
              }
            },
          ),
        ],
      ),
    ));
  }
}


