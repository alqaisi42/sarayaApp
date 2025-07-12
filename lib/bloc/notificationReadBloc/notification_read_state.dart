

class NotificationReadState {
  final Map<String, int> isReadValues;
  final Set<String> visitedSlugs;

  NotificationReadState({
    required this.isReadValues,
    required this.visitedSlugs,
  });

  NotificationReadState copyWith({
    Map<String, int>? isReadValues,
    Set<String>? visitedSlugs,
  }) {
    return NotificationReadState(
      isReadValues: isReadValues ?? this.isReadValues,
      visitedSlugs: visitedSlugs ?? this.visitedSlugs,
    );
  }
}
