import 'package:equatable/equatable.dart';



import '../../Model/verify_payment_model.dart';

abstract class VerifyPaymentState extends Equatable {
  const VerifyPaymentState();

  @override
  List<Object?> get props => [];
}

class VerifyPaymentInitial extends VerifyPaymentState {}

class VerifyPaymentLoading extends VerifyPaymentState {}

class VerifyPaymentSuccess extends VerifyPaymentState {
  final List<VerifyPaymentModel> verifyPaymentData;

  const VerifyPaymentSuccess({required this.verifyPaymentData});

  @override
  List<Object?> get props => [verifyPaymentData];
}

class VerifyPaymentFailure extends VerifyPaymentState {
  final String errorMessage;

  const VerifyPaymentFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
