import 'package:flutter_bloc/flutter_bloc.dart';


import '../../Model/fevorites_model.dart';
import '../../config/api_routes.dart';

import '../blocRepository/post_api_repo.dart';
import 'fevorites_event.dart';
import 'fevorites_state.dart';



class FevoritesBloc extends Bloc<FevoritesEvent, FevoritesState> {
  final PostapiRepo<FevoriteResponse> _postapiRepo;

  FevoritesBloc()
      : _postapiRepo = PostapiRepo<FevoriteResponse>(fromJson: FevoriteResponse.fromJson, isToken: true),
        super(FevoritesInitialState()) {
    on<PostFevorites>(_postFevorites);
  }

  Future<void> _postFevorites(PostFevorites event, Emitter<FevoritesState> emit) async {
    emit(FevoritesLoadingState());

    try {
      final result = await _postapiRepo.postData(
        favoritesURL,
        id: event.id,
      );

      emit(FevoritesSuccessState(fevorites: result));
    } catch (e) {
      emit(FevoritesErrorState(errorMessage: e.toString()));
    }
  }

}

