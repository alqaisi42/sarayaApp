import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/bookmark/bookmark_article_bloc.dart';
import '../../../bloc/channelsAllBloc/channel_all_bloc.dart';
import '../../../bloc/channelsAllBloc/channel_all_event.dart';
import '../../../bloc/channelsAllBloc/channel_all_state.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';

import '../../../l10n/app_localizations.dart';

import '../../../utils/widgets/follow_channel.dart';

class PublisherAll extends StatefulWidget {
 final String? pageName;
   const PublisherAll({super.key, this.pageName});

  @override
  State<PublisherAll> createState() => _PublisherAllState();
}

class _PublisherAllState extends State<PublisherAll> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController
        .addListener(_onScroll);
    context
        .read<ChannelsAllBloc>()
        .add(FetchChannelAll(initialValue: 1, context: context));
  }

  void _onScroll() {

    if (!_scrollController.hasClients) return;

    final bloc = context.read<ChannelsAllBloc>();
    if (bloc.isLoading) return;


    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent - 200) {
      bloc.add(FetchMoreChannelAll(context: context));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.channels,style: TextStyle(fontFamily: fontType),),
          centerTitle: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<ChannelsAllBloc>()
                .add(FetchChannelAll(refreshIndicator: true, context: context));
          },
          color: AppColors().primaryColor,
          child: BlocListener<BookmarkArticleBloc, BookmarkArticleState>(
            listener: (context, state) {
              setState(() {
                log("refresh button");
              });
            },
            child: BlocBuilder<ChannelsAllBloc, ChannelsAllState>(
              builder: (context, state) {
                if (state is ChannelsAllInitialState ||
                    (state is ChannelsAllLoadingState &&
                        state.channelsAll.isEmpty)) {
                  return _buildLoadingShimmer();
                } else if (state is ChannelsAllErrorState) {
                  return Center(
                      child: Text(
                          '${AppLocalizations.of(context)!.error}: ${state.errorMessage}'));
                } else {
                  return ChannelList(scrollController: _scrollController,pageName:widget.pageName);
                }
              },
            ),
          ),
        ));
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
        );
      },
    );
  }
}

class ChannelList extends StatelessWidget {
  final ScrollController scrollController;
  final String? pageName;
  const ChannelList({super.key, required this.scrollController, this.pageName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelsAllBloc, ChannelsAllState>(
      builder: (context, state) {
        final bloc = context.read<ChannelsAllBloc>();
        final allData =
            bloc.allChannels.expand((response) => response.data?.channels ?? []).toList();

        return ListView.builder(
          controller: scrollController,
          itemCount: allData.length + 1,
          itemBuilder: (context, index) {
            if (index == allData.length) {
              if (state is ChannelsAllLoadingMoreState) {
                return  Center(
                    child: CircularProgressIndicator(
                        color: AppColors().primaryColor));
              } else {
                return const SizedBox.shrink();
              }
            }

            final channel = allData[index];
            return GestureDetector(
              onTap: (){
                GoRouter.of(context)
                    .push("/customNewsPage/${channel.slug}");
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQueryHelper.screenHeight(context) * 0.01),
                child: ChannelItem(
                  channel: channel,
                  pageName:pageName
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChannelItem extends StatefulWidget {
  final dynamic channel;
  final String? pageName;

  const ChannelItem({
    super.key,
    required this.channel, this.pageName,
  });

  @override
  State<ChannelItem> createState() => _ChannelItemState();
}

class _ChannelItemState extends State<ChannelItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQueryHelper.screenWidth(context) * 0.03),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
              vertical: MediaQueryHelper.screenHeight(context) * 0.01),
          child: Row(
            children: [
              // Image and Name
              Expanded(
                child: Row(
                  children: [
                    // Channel Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ImageUtils.networkImage(widget.channel.logo,height: 50,width: 50,fit: BoxFit.cover)
                    ),
                    const SizedBox(width: 16.0),
                    // Channel Name
                    Expanded(
                      child: Text(
                        widget.channel.name ?? "Unnamed Channel",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Follow Button
              FollowButton(
                channelslug: widget.channel.slug,
                pageName: widget.pageName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
