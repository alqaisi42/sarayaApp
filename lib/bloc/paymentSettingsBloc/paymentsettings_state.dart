

import 'package:equatable/equatable.dart';

import '../../Model/payment_settings_model.dart';



abstract class PaymentSettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentSettingsInitialState extends PaymentSettingsState {}

class PaymentSettingsLoadingState extends PaymentSettingsState {}

class PaymentSettingsSuccessState extends PaymentSettingsState {
  final List<PaymentSettingsModel> paymentSettingData;

  PaymentSettingsSuccessState({required this.paymentSettingData});

  @override
  List<Object?> get props => [paymentSettingData];
}

class PaymentSettingsErrorState extends PaymentSettingsState {
  final String errorMessage;

  PaymentSettingsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}


