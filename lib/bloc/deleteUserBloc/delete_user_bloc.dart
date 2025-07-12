import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/delete_user_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/delete_api_rapo.dart';
import 'delete_user_event.dart';
import 'delete_user_state.dart';

class DeleteUserBloc extends Bloc<DeleteUserEvent, DeleteUserState> {

  final DeleteUserRepository<DeleteUserResponse> repository = DeleteUserRepository<DeleteUserResponse>(
    fromJson: (json) => DeleteUserResponse.fromJson(json),
    isToken: true,
  );

  DeleteUserBloc() : super(DeleteUserInitialState()) {
    on<DeleteUser>((event, emit) async {
      emit(DeleteUserLoadingState());
      try {
        final List<DeleteUserResponse> response = await repository.deleteUser('$deleteUserUrl=${event.userDevice}');


        if (response.isNotEmpty) {


          emit(DeleteUserSuccess(userDeleteData: response.first));
        }
      } catch (e) {
        emit(DeleteUserErrorState(errorMessage: e.toString()));
      }
    });
  }
}

