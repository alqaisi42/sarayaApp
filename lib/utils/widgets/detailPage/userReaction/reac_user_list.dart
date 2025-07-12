



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';


import '../../../../Model/reactors_user_model.dart';
import '../../../../bloc/emojiBloc/emojireact_user_bloc.dart';
import '../../../../bloc/emojiBloc/emojireact_user__state.dart';
import '../../../../bloc/getReacUserDataBloc/get_react_user_data_bloc.dart';
import '../../../../bloc/getReacUserDataBloc/get_react_user_data_event.dart';
import '../../../../bloc/getReacUserDataBloc/get_react_user_data_state.dart';
import '../../../../config/shimmer.dart';

import '../../../../l10n/app_localizations.dart';
import '../reactionEmojiMain/reaction_data.dart';



class CustomBottomSheet extends StatefulWidget {
  final String slug;
  const CustomBottomSheet({super.key, required this.slug});

  @override
  CustomBottomSheetState createState() => CustomBottomSheetState();
}

class CustomBottomSheetState extends State<CustomBottomSheet> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  Widget _buildTabWithCount(String name, int count) {
    if (name == 'All') {
      return Tab(
        child: Text(
          '${AppLocalizations.of(context)!.all} ($count)',
          style: const TextStyle(fontSize: 14,fontFamily: fontType),
        ),
      );
    } else {
      String? emojiAsset;
      switch (name.toLowerCase()) {
        case 'like':
          emojiAsset = ReactionData.facebookReactionIcon[0];
          break;
        case 'love':
          emojiAsset = ReactionData.facebookReactionIcon[1];
          break;
        case 'haha':
          emojiAsset = ReactionData.facebookReactionIcon[2];
          break;
        case 'wow':
          emojiAsset = ReactionData.facebookReactionIcon[3];
          break;
        case 'sad':
          emojiAsset = ReactionData.facebookReactionIcon[4];
          break;
        case 'angry':
          emojiAsset = ReactionData.facebookReactionIcon[5];
          break;
      }

      return Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emojiAsset != null)
              Image.asset(
                emojiAsset,
                width: 20,
                height: 20,
              ),
            SizedBox(width: 4),
            Text(
              '($count)',
              style: TextStyle(fontSize: 14,fontFamily: fontType),
            ),
          ],
        ),
      );
    }
  }

  String _getEmojiAssetForReaction(String reactionType) {
    switch (reactionType.toLowerCase()) {
      case 'like':
        return ReactionData.facebookReactionIcon[0];
      case 'love':
        return ReactionData.facebookReactionIcon[1];
      case 'haha':
        return ReactionData.facebookReactionIcon[2];
      case 'wow':
        return ReactionData.facebookReactionIcon[3];
      case 'sad':
        return ReactionData.facebookReactionIcon[4];
      case 'angry':
        return ReactionData.facebookReactionIcon[5];
      default:
        return ReactionData.facebookReactionIcon[0];
    }
  }

  Widget _buildTabContent(String emojiType) {
    return BlocBuilder<GetReactUserDataBloc, GetReactUserDataState>(
      builder: (context, state) {
        if (state is GetReactUserDataInitialState ||
            (state is GetReactUserDataLoadingState &&
                state.reactorsDataList.isEmpty)) {
          return _buildLoadingShimmer();
        }

        if (state is GetReactUserDataSuccessState ||
            state is GetReactUserDataLoadingMoreState) {
          final List<ReactorsUserModel> dataList = state is GetReactUserDataSuccessState
              ? state.reactorsDataList
              : (state as GetReactUserDataLoadingMoreState).reactorsDataList;

          final allReactors = dataList.isNotEmpty
              ? dataList[0].data ?? []
              : [];

          if (allReactors.isEmpty) {
            return const Center(
              child: Text(
                '',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return ListView.builder(
            controller: context.read<GetReactUserDataBloc>().scrollController,
            itemCount: allReactors.length + 1,
            itemBuilder: (context, index) {
              if (index == allReactors.length) {
                if (state is GetReactUserDataLoadingMoreState) {
                  return  Center(
                    child: CircularProgressIndicator(
                      color: AppColors().primaryColor,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final reactor = allReactors[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(reactor.profile ?? ''),
                        radius: 24,
                      ),
                      Positioned(
                        bottom: -1,
                        right: 2,
                        child: Container(
                          decoration: BoxDecoration(


                          ),
                          child: Image.asset(
                            _getEmojiAssetForReaction(reactor.reactionName),
                            width: 16,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    reactor.userName ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: fontType
                    ),
                  ),
                ),
              );
            },
          );
        }

        if (state is GetReactUserDataErrorState) {
          return Center(child: Text(state.errorMessage,style: TextStyle(fontFamily: fontType),));
        }

        return _buildLoadingShimmer();
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.05,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmojiReactUserBloc, EmojiReactUserState>(
      builder: (context, state) {
        final emojiData = state.emojiReactionUserData;

        List<Widget> tabContents = emojiData.map((data) {
          final emojiType = (data['name'] as String).toLowerCase();
          return BlocProvider(
            create: (context) => GetReactUserDataBloc()
              ..add(FetchReactUserData(
                  emojiType: emojiType,
                  slug: widget.slug,
                  initialValue: 1
              )),
            child: _buildTabContent(emojiType),
          );
        }).toList();

        if (tabController == null || tabController!.length != emojiData.length) {
          tabController?.dispose();
          tabController = TabController(
            length: emojiData.length,
            vsync: this,
          );
        }

        return Column(
          children: [
            TabBar(
              controller: tabController!,
              indicatorColor: AppColors().primaryColor,
              labelColor: AppColors().primaryColor,
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: emojiData.map((data) {
                return _buildTabWithCount(
                  data['name'] as String,
                  data['count'] as int,
                );
              }).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController!,
                children: tabContents,
              ),
            ),
          ],
        );
      },
    );
  }
}











