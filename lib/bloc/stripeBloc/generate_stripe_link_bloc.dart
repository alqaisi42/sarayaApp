import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Model/stripe_model.dart';


import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import 'generate_stripe_link_event.dart';
import 'generate_stripe_link_state.dart';



class GenerateStripeLinkBloc extends Bloc<GenerateStripeLinkEvent, GenerateStripeLinkState> {
  final PostapiRepo<StripeResModel> postapiRepo;

  GenerateStripeLinkBloc()
      : postapiRepo = PostapiRepo<StripeResModel>(
    fromJson: (json) => StripeResModel.fromJson(json),
    isToken: true,
  ),
        super(GenerateStripeLinkInitial()) {
    on<GenerateStripeLinkRequest>(_onGenerateStripeLinkRequest);
  }

  Future<void> _onGenerateStripeLinkRequest(
      GenerateStripeLinkRequest event, Emitter<GenerateStripeLinkState> emit) async {
    emit(GenerateStripeLinkLoading());

    try {
      final response = await postapiRepo.postData(
        createStripeUrl,
        tenureId: event.tenureId.toString(),
        planId: event.planId.toString(),
        planAmount: event.planAmount.toString()
      );

      emit(GenerateStripeLinkSuccess(generateStripeLinkData: response));
    } catch (e) {
      emit(GenerateStripeLinkFailure(errorMessage: e.toString()));
    }
  }
}

