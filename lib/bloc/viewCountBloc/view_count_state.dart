

class ViewCountState {
  final Map<String, int> viewCounts;
  final Set<String> visitedSlugs;

  ViewCountState({
    required this.viewCounts,
    required this.visitedSlugs,
  });

  ViewCountState copyWith({
    Map<String, int>? viewCounts,
    Set<String>? visitedSlugs,
  }) {
    return ViewCountState(
      viewCounts: viewCounts ?? this.viewCounts,
      visitedSlugs: visitedSlugs ?? this.visitedSlugs,
    );
  }
}