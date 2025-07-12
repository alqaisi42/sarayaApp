import 'package:equatable/equatable.dart';

import '../../Model/react_emoji_model.dart';

abstract class EmojiPostState extends Equatable{
  @override
  List<Object?> get props => [];
}


class EmojiPostInitialState extends EmojiPostState{}

class EmojiPostLoadingState extends EmojiPostState{}

class EmojiPostSuccessState extends EmojiPostState{
 final List<ReactEmojiReponse> emojiDetail;


 EmojiPostSuccessState({required this.emojiDetail});
}

class EmojiPostErrorState extends EmojiPostState{
  final String errorMessage;

  EmojiPostErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}