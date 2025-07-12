


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Model/forgote_password_model.dart';


import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';


class ForgatePasswordBloc extends Bloc<ForgatePasswordEvent, ForgatePasswordState> {
  final PostapiRepo<ForgatePasswordResponse> _postapiRepo;

  ForgatePasswordBloc()
      : _postapiRepo = PostapiRepo<ForgatePasswordResponse>(
    fromJson: ForgatePasswordResponse.fromJson,
    isToken: true,
  ),
        super(ForgatePasswordInitialState()) {
    on<PostForgatePassword>(_onPostForgatePassword);
  }

  Future<void> _onPostForgatePassword(PostForgatePassword event, Emitter<ForgatePasswordState> emit,) async {
    emit(ForgatePasswordLoadingState());


    try {
      final result = await _postapiRepo.postData(
        forgatePasswordUrl,
        email: event.userEmail,
      );

      emit(ForgatePasswordSuccessState(forgatePasswordData: result.first));
    } catch (e) {
      emit(ForgatePasswordErrorState(errorMessage: e.toString()));
    }
  }
}
