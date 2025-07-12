import 'package:flutter_bloc/flutter_bloc.dart';

import 'comment_count_event.dart';
import 'comment_count_state.dart';

class CommentCountBloc extends Bloc<CommentCountEvent, CommentCountState> {
  CommentCountBloc() : super(CommentCountState(commentCounts: {}, visitedSlugs: {})) {
    on<InitializeCommentCounts>(_onInitialize);
    on<UpdateCommentCount>(_onCommentCount);
  }

  void _onInitialize(InitializeCommentCounts event, Emitter<CommentCountState> emit) {
    emit(state.copyWith(commentCounts: event.initialCounts));
  }

  void _onCommentCount(UpdateCommentCount event, Emitter<CommentCountState> emit) {
    final currentCount = state.commentCounts[event.slug];


    if (currentCount == null || currentCount != event.apiCommentCount) {
      final newCounts = Map<String, int>.from(state.commentCounts);
      newCounts[event.slug] = event.apiCommentCount;


      final newVisited = Set<String>.from(state.visitedSlugs);
      newVisited.add(event.slug);

      emit(state.copyWith(
        commentCounts: newCounts,
        visitedSlugs: newVisited,
      ));
    }
  }
}
