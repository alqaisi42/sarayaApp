


// class TotalReactionCountState {
//   final List<Map<String, dynamic>> reactionData;
//   final String? userReaction;
//   final int totalCount;
//
//   TotalReactionCountState({
//     required this.reactionData,
//     this.userReaction,
//     this.totalCount = 0,
//   });
//
//   TotalReactionCountState copyWith({
//     List<Map<String, dynamic>>? reactionData,
//     String? userReaction,
//     int? totalCount,
//   }) {
//     return TotalReactionCountState(
//       reactionData: reactionData ?? this.reactionData,
//       userReaction: userReaction ?? this.userReaction,
//       totalCount: totalCount ?? this.totalCount,
//     );
//   }
// }

class TotalReactionCountState {
  final List<Map<String, dynamic>> reactionData;
  final String? userReaction;
  final int totalCount;
  final bool userHasReacted;

  TotalReactionCountState({
    required this.reactionData,
    this.userReaction,
    this.totalCount = 0,
    this.userHasReacted = false,
  });

  TotalReactionCountState copyWith({
    List<Map<String, dynamic>>? reactionData,
    String? userReaction,
    int? totalCount,
    bool? userHasReacted,
  }) {
    return TotalReactionCountState(
      reactionData: reactionData ?? this.reactionData,
      userReaction: userReaction ?? this.userReaction,
      totalCount: totalCount ?? this.totalCount,
      userHasReacted: userHasReacted ?? this.userHasReacted,
    );
  }
}