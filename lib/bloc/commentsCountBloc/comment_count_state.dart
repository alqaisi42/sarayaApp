

class CommentCountState {
  final Map<String, int> commentCounts;
  final Set<String> visitedSlugs;

  CommentCountState({
    required this.commentCounts,
    required this.visitedSlugs,
  });

  CommentCountState copyWith({
    Map<String, int>? commentCounts,
    Set<String>? visitedSlugs,
  }) {
    return CommentCountState(
      commentCounts: commentCounts ?? this.commentCounts,
      visitedSlugs: visitedSlugs ?? this.visitedSlugs,
    );
  }
}