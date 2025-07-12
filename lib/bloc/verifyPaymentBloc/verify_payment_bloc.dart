import 'package:flutter_bloc/flutter_bloc.dart';



import '../../Model/verify_payment_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';
import 'verify_payment_event.dart';
import 'verify_payment_state.dart';



class VerifyPaymentBloc extends Bloc<VerifyPaymentEvent, VerifyPaymentState> {
  final PostapiRepo<VerifyPaymentModel> postapiRepo;

  VerifyPaymentBloc()
      : postapiRepo = PostapiRepo<VerifyPaymentModel>(
    fromJson: (json) => VerifyPaymentModel.fromJson(json),
    isToken: true,
  ),
        super(VerifyPaymentInitial()) {
    on<VerifyPaymentRequest>(_onVerifyPaymentRequest);
  }

  Future<void> _onVerifyPaymentRequest(
      VerifyPaymentRequest event, Emitter<VerifyPaymentState> emit) async {
    emit(VerifyPaymentLoading());

    try {
      final response = await postapiRepo.postData(
        verifyPaymentUrl,
        tenureId: event.tenureId.toString(),
        planId: event.planId.toString(),
        planAmount: event.planAmount.toString(),
        razorpayPaymentId: event.razorpayPaymentId.toString(),
        razorpayOrderId: event.razorpayOrderId.toString(),
        razorpaySignature: event.razorpaySignature.toString(),
      );

      emit(VerifyPaymentSuccess(verifyPaymentData: response));
    } catch (e) {
      emit(VerifyPaymentFailure(errorMessage: e.toString()));
    }
  }
}

