
import 'package:equatable/equatable.dart';

abstract class CommentCountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class InitializeCommentCounts extends CommentCountEvent {
  final Map<String, int> initialCounts;

  InitializeCommentCounts({required this.initialCounts});

  @override
  List<Object?> get props => [initialCounts];
}

class UpdateCommentCount extends CommentCountEvent {
  final String slug;
  final int apiCommentCount;

  UpdateCommentCount({
    required this.slug,
    required this.apiCommentCount,
  });

  @override
  List<Object?> get props => [slug, apiCommentCount];
}