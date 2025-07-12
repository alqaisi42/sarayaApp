


import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/totalReactionBloc/total_reaction_event.dart';

import 'package:newsapp/bloc/totalReactionBloc/total_reaction_state.dart';

import '../../utils/widgets/detailPage/reactionEmojiMain/reaction_data.dart';










class TotalReactionCountBloc extends Bloc<TotalReactionCountEvent, TotalReactionCountState> {
  TotalReactionCountBloc() : super(TotalReactionCountState(reactionData: [], userReaction: null)) {
    on<InitialTotalCount>(_onInitialTotalCount);
    on<UpdateTotalCount>(_onUpdateTotalCount);
  }

  String getEmojiPath(String reactionName) {
    switch (reactionName.toLowerCase()) {
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



  Future<void> _onInitialTotalCount(InitialTotalCount event, Emitter<TotalReactionCountState> emit) async {
    try {
      List<Map<String, dynamic>> processedData = [];
      int totalCount = 0;

      event.initialCountData?.forEach((key, reaction) {
        if (reaction.name != null && reaction.count != null) {
          totalCount += reaction.count!;
          processedData.add({
            'name': reaction.name,
            'count': reaction.count,
            'emojiPath': getEmojiPath(reaction.name!),
          });
        }
      });

      // Sort by count in descending order
      processedData.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

      emit(state.copyWith(
        reactionData: processedData,
        userReaction: event.userHasReacted ? processedData.first['name'] : null,
        totalCount: totalCount,
        userHasReacted: event.userHasReacted
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error in _onInitialTotalCount: ${e.toString()}');
      }
    }
  }

  Future<void> _onUpdateTotalCount(UpdateTotalCount event, Emitter<TotalReactionCountState> emit) async {


    try {
      List<Map<String, dynamic>> processedData = [];
      int totalCount = 0;

      event.updatedCountData.forEach((key, reaction) {
        if (reaction.name != null && reaction.count != null) {
          totalCount += reaction.count!;
          processedData.add({
            'name': reaction.name,
            'count': reaction.count,
            'emojiPath': getEmojiPath(reaction.name!),
          });
        }
      });

      processedData.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

      String? userReaction = event.userHasReacted && processedData.isNotEmpty ? processedData.first['name'] : null;

      emit(state.copyWith(
        reactionData: processedData,
        userReaction: userReaction,
        totalCount: totalCount,
          userHasReacted: event.userHasReacted
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error in onUpdateTotalCount: ${e.toString()}');
      }
    }
  }
}

