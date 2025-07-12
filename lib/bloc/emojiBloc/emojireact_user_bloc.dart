

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newsapp/bloc/emojiBloc/emojireact_user__event.dart';
import 'package:newsapp/bloc/emojiBloc/emojireact_user__state.dart';

import '../../Model/detail_page_model.dart';
import '../../Model/react_emoji_model.dart';




class EmojiReactUserBloc extends Bloc<EmojireactuserEvent, EmojiReactUserState> {
  EmojiReactUserBloc() : super(EmojiReactUserState(emojiReactionUserData: [])) {
    on<InitialUserEmoji>(_onInitialUserEmoji);
    on<UpdateUserEmoji>(_onUpdateUserEmoji);
  }

  final userReactDataArr = [];

  Future<void> _onInitialUserEmoji(
      InitialUserEmoji event, Emitter<EmojiReactUserState> emit) async {
    try {
      userReactDataArr.clear();
      updateTabData(event.initialUserReactData);

      emit(EmojiReactUserState(emojiReactionUserData: userReactDataArr));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> _onUpdateUserEmoji(
      UpdateUserEmoji event, Emitter<EmojiReactUserState> emit) async {
    try {
      userReactDataArr.clear();
      updateUserTabData(event.updateUserReactData);
      emit(state.copyWith(emojiReactionUserData: userReactDataArr));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void updateUserTabData(Map<int, UpdateReactionsData> userReactData) {
    userReactDataArr.clear();

    int totalCount = 0;
    userReactData.forEach((key, value) {
      totalCount += (value.count ?? 0).toInt();
    });

    userReactDataArr.add({
      'name': 'All',
      'count': totalCount
    });

    userReactData.forEach((key, value) {
      userReactDataArr.add({
        'name': value.name,
        'count': (value.count ?? 0).toInt()
      });
    });
  }

  void updateTabData(Map<int, UserReaction>? userReactData) {
    userReactDataArr.clear();

    int totalCount = 0;
    userReactData?.forEach((key, value) {
      totalCount += (value.count ?? 0).toInt();
    });

    userReactDataArr.add({
      'name': 'All',
      'count': totalCount
    });

    userReactData?.forEach((key, value) {
      userReactDataArr.add({
        'name': value.name,
        'count': (value.count ?? 0).toInt()
      });
    });
  }
}
















