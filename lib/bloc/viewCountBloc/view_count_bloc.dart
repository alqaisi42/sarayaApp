import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/viewCountBloc/view_count_event.dart';
import 'package:newsapp/bloc/viewCountBloc/view_count_state.dart';

class ViewCountBloc extends Bloc<ViewCountEvent, ViewCountState> {
  ViewCountBloc() : super(ViewCountState(viewCounts: {}, visitedSlugs: {})) {
    on<InitializeViewCounts>(_onInitialize);
    on<UpdateViewCount>(_onUpdateViewCount);
  }

  void _onInitialize(InitializeViewCounts event, Emitter<ViewCountState> emit,) {
    emit(state.copyWith(viewCounts: event.initialCounts));
  }

  void _onUpdateViewCount(UpdateViewCount event, Emitter<ViewCountState> emit,) {
    final currentCount = state.viewCounts[event.slug];
    if (!state.visitedSlugs.contains(event.slug) &&
        (currentCount == null || currentCount != event.apiViewCount)) {

      final newCounts = Map<String, int>.from(state.viewCounts);
      newCounts[event.slug] = event.apiViewCount;

      final newVisited = Set<String>.from(state.visitedSlugs);
      newVisited.add(event.slug);

      emit(state.copyWith(viewCounts: newCounts, visitedSlugs: newVisited,));
    }
  }
}