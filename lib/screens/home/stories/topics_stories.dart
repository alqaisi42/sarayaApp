import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';
import 'package:newsapp/screens/home/stories/topics_all_stories.dart';

import '../../../bloc/storiesTopicsBloc/stories_topics_bloc.dart';
import '../../../bloc/storiesTopicsBloc/stories_topics_event.dart';
import '../../../bloc/storiesTopicsBloc/stories_topics_state.dart';
import '../../../config/helper/empty_state_ui.dart';
import '../../../config/helper/helper_functions.dart';


import '../../../utils/widgets/custome_title.dart';
import '../../../l10n/app_localizations.dart';
import 'news_stories_ui.dart';

class TopicsStories extends StatefulWidget {
  const TopicsStories({super.key});

  @override
  State<TopicsStories> createState() => _TopicsStoriesState();
}

class _TopicsStoriesState extends State<TopicsStories> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<StoriesTopicsBloc>().add(FetchStoriesTopics());
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;

        context.read<StoriesTopicsBloc>().add(FetchStoriesMoreTopics());
        await Future.delayed(const Duration(seconds: 2));
        _isLoadingMore = false;
      }
    }
  }

  Future<void> _refreshContent() async {
    context.read<StoriesTopicsBloc>().add(FetchStoriesTopics());
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
          AppLocalizations.of(context)!.topicsStories,
          style: TextStyle(fontFamily: fontType),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: _refreshContent,
        child: BlocBuilder<StoriesTopicsBloc, StoriesTopicsState>(
          builder: (context, state) {
            if (state is StoriesTopicsLoadingState) {
              return const Center(child: StoryGridShimmer());
            }

            // Get stories data
            List<Widget> storiesTopicsData = [];
            if (state is StoriesTopicsSuccessState ||
                state is StoriesTopicsLoadingMoreState) {
              final data = state is StoriesTopicsSuccessState
                  ? state.storiesTopicsData
                  : (state as StoriesTopicsLoadingMoreState).currentStories;

              storiesTopicsData = data.expand((topicData) {
                return (topicData.data ?? []).map((topic) {
                  final stories = topic.stories ?? [];
                  final topicName = topic.name ?? '';
                  final topicSlug = topic.slug ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topic Header Section
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQueryHelper.screenHeight(context) * 0.02,
                          bottom: MediaQueryHelper.screenHeight(context) * 0.01,
                          left: MediaQueryHelper.screenWidth(context) * 0.04,
                          right: MediaQueryHelper.screenWidth(context) * 0.04,
                        ),
                        child: CustomeTitle(
                          title: topicName,
                          title2: AppLocalizations.of(context)!.seeAll,
                          onTap: () {
                            GoRouter.of(context)
                                .push("/topicsAllStories/$topicSlug");
                          },
                        ),
                      ),

                      // Stories List Section
                      SizedBox(
                        height: 180,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQueryHelper.screenWidth(context) * 0.02,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: stories.length,
                            itemBuilder: (context, index) {
                              final story = stories[index];

                              if (story.storySlides == null ||
                                  story.storySlides!.isEmpty ||
                                  story.storySlides!.first.image == null) {
                                return const SizedBox.shrink();
                              }

                              final firstSlideImage =
                                  story.storySlides!.first.image!;

                              return GestureDetector(
                                onTap: () async {


                                  checkStoryLimitAndNavigate(context,index,stories);


                                },
                                child: StoryCard(
                                  firstSlideImage: firstSlideImage,
                                  title: story.title ?? '',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList();
              }).toList();
            }

            if (state is StoriesTopicsErrorState) {
              return Center(
                  child: Text(
                ' ${state.errorMessage}',
                style: TextStyle(fontFamily: fontType),
              ));
            }

            if (storiesTopicsData.isEmpty) {
              return EmptyStateWidget(
                title:
                    '${AppLocalizations.of(context)!.topicsStories} ${AppLocalizations.of(context)!.isCurrentlyEmpty}',
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

            return ListView.builder(
              controller: _scrollController,
              itemCount: storiesTopicsData.length + 1,
              itemBuilder: (context, index) {
                if (index == storiesTopicsData.length) {
                  if (state is StoriesTopicsLoadingMoreState) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Center(
                          child: CircularProgressIndicator(color: Colors.red)),
                    );
                  }
                  return const SizedBox.shrink();
                }
                return storiesTopicsData[index];
              },
            );
          },
        ),
      ),
    );
  }
}
