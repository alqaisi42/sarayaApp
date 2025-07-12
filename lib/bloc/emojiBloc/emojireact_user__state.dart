


class EmojiReactUserState {
  final List emojiReactionUserData;

  EmojiReactUserState({
    required this.emojiReactionUserData,

  });

  EmojiReactUserState copyWith({required List emojiReactionUserData,}) {
    return EmojiReactUserState(emojiReactionUserData: emojiReactionUserData);
  }
}

