


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/generate_signature_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import 'generate_signature_event.dart';
import 'generate_signature_state.dart';

class GenerateSignatureBloc extends Bloc<GenerateSignatureEvent, GenerateSignatureState> {
  final PostapiRepo<GenerateSignatureModel> postapiRepo;

  GenerateSignatureBloc()
      : postapiRepo = PostapiRepo<GenerateSignatureModel>(
    fromJson: (json) => GenerateSignatureModel.fromJson(json),
    isToken: true,
  ),
        super(GenerateSignatureInitialState()) {
    on<PostSingnatureDetails>(_onPostSignatureDetails);
  }

  Future<void> _onPostSignatureDetails(
      PostSingnatureDetails event,
      Emitter<GenerateSignatureState> emit,
      ) async {
    emit(GenerateSignatureLoadingState());

    try {
      final response = await postapiRepo.postData(
        generateSignatureUrl,
        planId: event.planId,
        planAmount: event.planAmount,
        tenureId: event.tenureId,
      );

      emit(GenerateSignatureSuccessState(generateSignatur: response));
    } catch (e) {
      emit(GenerateSignatureErrorState(errorMessage: e.toString()));
    }
  }
}
