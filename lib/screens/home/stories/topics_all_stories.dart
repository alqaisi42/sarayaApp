import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/storiesAllBloc/stories_all_event.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';

import '../../../Model/stories_model.dart';
import '../../../bloc/storiesAllBloc/stories_all_bloc.dart';
import '../../../bloc/storiesAllBloc/stories_all_state.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';


import 'news_stories_ui.dart';
import '../../../l10n/app_localizations.dart';
class TopicsAllStories extends StatefulWidget {
  final String topicName;
  const TopicsAllStories({super.key, required this.topicName});

  @override
  State<TopicsAllStories> createState() => _TopicsAllStoriesState();
}

class _TopicsAllStoriesState extends State<TopicsAllStories> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<StoriesAllBloc>().add(
        FetchStoriesAllTopic(storiesTopic: widget.topicName.toLowerCase()));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<StoriesAllBloc>().add(FetchStoriesAllMoreTopics());
    }
  }

  Future<void> _refreshContent() async {
    context.read<StoriesAllBloc>().add(
        FetchStoriesAllTopic(storiesTopic: widget.topicName.toLowerCase()));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topicName,
          style: TextStyle(fontFamily: fontType),
        ),
      ),
      body: BlocBuilder<StoriesAllBloc, StoriesAllState>(
        builder: (context, state) {
          // Show full screen loader only on initial load
          if (state is StoriesAllTopicsLoadingState) {
            return StoryGridShimmer();
          }

          List<Stories> stories = [];
          if (state is StoriesAllTopicsSuccessState) {
            final successState = state;

            for (var storyResponse in successState.storiesall) {
              if (storyResponse.data != null &&
                  storyResponse.data!.isNotEmpty &&
                  storyResponse.data!.first.stories != null) {
                stories.addAll(storyResponse.data!.first.stories!);
              }
            }

            if (stories.isEmpty) {
              return EmptyStateWidget(
                title:
                    '${widget.topicName} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
                customImage: Image.asset(
                  'assets/img/empty.png',
                  width: MediaQueryHelper.screenWidth(context) * 0.65,
                ),
                buttonText: AppLocalizations.of(context)!.retry,
                onButtonPressed: () {
                  _refreshContent();
                },
              );
            }
          } else if (state is StoriesAllTopicsLoadingMoreState) {
            final loadingState = state;
            for (var storyResponse in loadingState.storiesall) {
              if (storyResponse.data != null &&
                  storyResponse.data!.isNotEmpty &&
                  storyResponse.data!.first.stories != null) {
                stories.addAll(storyResponse.data!.first.stories!);
              }
            }
          }

          if (state is StoriesAllTopicsErrorState) {
            return Center(
                child: Text(
              state.errorMessage,
              style: TextStyle(fontFamily: fontType),
            ));
          }

          return RefreshIndicator(
            color: AppColors().primaryColor,
            onRefresh: _refreshContent,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= stories.length) return null;

                        final story = stories[index];
                        final firstSlideImage = story.storySlides!.isNotEmpty
                            ? story.storySlides!.first.image
                            : null;

                        if (story.storySlides!.isEmpty) {
                          return Container();
                        }

                        return GestureDetector(
                          onTap: () async {

                            checkStoryLimitAndNavigate(context,index,stories);

                          },
                          child: StoryCard(
                            firstSlideImage: firstSlideImage ?? '',
                            title: story.title ?? '',
                          ),
                        );
                      },
                      childCount: stories.length,
                    ),
                  ),
                ),
                // Show bottom loader only during pagination
                if (state is StoriesAllTopicsLoadingMoreState)
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                      ))
              ],
            ),
          );
        },
      ),
    );
  }
}

class StoryGridShimmer extends StatelessWidget {
  const StoryGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate screen width to determine item size
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 32) / 3;
    final itemHeight = itemWidth / 0.7;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: itemWidth,
          height: itemHeight,
          borderRadius: 12.0, // Match your StoryCard border radius
          margin: EdgeInsets.all(4.0),
        );
      },
    );
  }
}
