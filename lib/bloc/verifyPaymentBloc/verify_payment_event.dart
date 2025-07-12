import 'package:equatable/equatable.dart';

abstract class VerifyPaymentEvent extends Equatable {
  const VerifyPaymentEvent();

  @override
  List<Object?> get props => [];
}

class VerifyPaymentRequest extends VerifyPaymentEvent {
  final int tenureId;
  final double planAmount;
  final int planId;
  final String razorpayPaymentId;
  final String razorpayOrderId;
  final String razorpaySignature;

  const VerifyPaymentRequest({
    required this.tenureId,
    required this.planId,
    required this.planAmount,
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    required this.razorpaySignature,
  });

  @override
  List<Object?> get props =>
      [tenureId, planAmount, planId, razorpayPaymentId, razorpayOrderId, razorpaySignature];
}
