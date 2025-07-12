

import 'package:flutter_bloc/flutter_bloc.dart';

import 'full_screen_mode_event.dart';
import 'full_screen_mode_state.dart';

class FullScreenBloc extends Bloc<FullScreenEvent, FullScreenState> {
  FullScreenBloc() : super(FullScreenState(isFullScreen: false)) {
    on<ToggleFullScreen>((event, emit) {
      emit(FullScreenState(isFullScreen: !state.isFullScreen));
    });
  }
}