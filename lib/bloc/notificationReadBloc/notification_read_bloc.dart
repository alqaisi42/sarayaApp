import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_read_event.dart';
import 'notification_read_state.dart';


class NotificationReadBloc
    extends Bloc<NotificationReadEvent, NotificationReadState> {
  NotificationReadBloc()
      : super(NotificationReadState(isReadValues: {}, visitedSlugs: {})) {
    on<InitializeNotificationRead>(_onInitialize);
    on<UpdateNotificationRead>(_onUpdateNotificationRead);
  }

  void _onInitialize(InitializeNotificationRead event, Emitter<NotificationReadState> emit,) {
    emit(state.copyWith(isReadValues: event.initialData));
  }

  void _onUpdateNotificationRead(
      UpdateNotificationRead event,
      Emitter<NotificationReadState> emit,
      ) {

    final updatedIsReadValues = Map<String, int>.from(state.isReadValues);
    updatedIsReadValues[event.slug] = event.isReadVal ? 1 : 0;

    emit(state.copyWith(
      isReadValues: updatedIsReadValues,
      visitedSlugs: state.visitedSlugs,
    ));
  }
}
