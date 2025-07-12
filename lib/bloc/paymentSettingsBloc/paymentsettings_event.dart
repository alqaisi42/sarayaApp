

import 'package:equatable/equatable.dart';



abstract class PaymentSettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPaymentSettings extends PaymentSettingsEvent {}