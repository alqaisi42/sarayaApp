

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/constants.dart';

import '../../../Model/stories_model.dart';
import '../../../bloc/storiesBloc/stories_bloc.dart';
import '../../../bloc/storiesBloc/stories_event.dart';
import '../../../bloc/storiesBloc/stories_state.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';


import '../../../utils/widgets/custome_title.dart';
import 'news_stories_ui.dart';
import '../../../l10n/app_localizations.dart';



class HomepageStories extends StatefulWidget {
  const HomepageStories({super.key});

  @override
  State<HomepageStories> createState() => _HomepageStoriesState();
}

class _HomepageStoriesState extends State<HomepageStories> {
  @override
  void initState() {
    super.initState();

    context.read<StoriesBloc>().add(FetchStories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, StoriesState>(
      builder: (context, state) {
        if (state is StoriesLoadingState) {
          return StoryRowShimmer();
        }

        if (state is StoriesErrorState) {
          return Center(child: Text(state.errorMessage, style: TextStyle(fontFamily: fontType),));
        }

        if (state is StoriesSuccessState) {
          final dataItems = state.storiesData[0].data;
          if (dataItems == null || dataItems.isEmpty) {
            return const SizedBox.shrink();
          }

          // Get all stories with valid slides from all topics
          final List<Stories> allStories = [];

          for (var dataItem in dataItems) {
            if (dataItem.stories != null && dataItem.stories!.isNotEmpty) {
              for (var story in dataItem.stories!) {
                // Check if story has valid slides
                if (story.storySlides != null &&
                    story.storySlides!.isNotEmpty &&
                    story.storySlides!.first.image != null) {
                  // Ensure topic name is set
                  story.topicName ??= dataItem.name;
                  allStories.add(story);
                }
              }
            }
          }

          if (allStories.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQueryHelper.screenHeight(context) * 0.01,
                  left: MediaQueryHelper.screenWidth(context) * 0.04,
                  right: MediaQueryHelper.screenWidth(context) * 0.04,
                ),
                child: CustomeTitle(
                  title: AppLocalizations.of(context)!.stories,
                  title2: AppLocalizations.of(context)!.seeAll,
                  onTap: () {
                    GoRouter.of(context).push("/topicsStories");
                  },
                ),
              ),
              SizedBox(
                height: 180,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQueryHelper.screenWidth(context) * 0.02
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allStories.length,
                    itemBuilder: (context, index) {
                      final story = allStories[index];
                      final firstSlideImage = story.storySlides!.first.image;

                      return GestureDetector(

                        onTap: () async {
                          checkStoryLimitAndNavigate(context,index,allStories);
                        }
                        ,
                        child: StoryCard(
                          firstSlideImage: firstSlideImage!,
                          title: story.title ?? '',
                          topic: story.topicName ?? '',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

}


class StoryRowShimmer extends StatelessWidget {
  const StoryRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 32) / 3;
    final itemHeight = itemWidth / 0.7;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: List.generate(
          4,
              (index) => ShimmerWidget(
            width: itemWidth,
            height: itemHeight,
            borderRadius: 12.0,
            margin: const EdgeInsets.all(4.0),
          ),
        ),
      ),
    );
  }
}