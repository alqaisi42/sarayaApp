

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/paymentSettingsBloc/paymentsettings_event.dart';
import 'package:newsapp/bloc/paymentSettingsBloc/paymentsettings_state.dart';

import '../../Model/payment_settings_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';


class PaymentSettingsBloc extends Bloc<PaymentSettingsEvent, PaymentSettingsState> {
  PaymentSettingsBloc() : super(PaymentSettingsInitialState()) {
    on<FetchPaymentSettings>(_onFetchPaymentSettings);
  }

  Future<void> _onFetchPaymentSettings(FetchPaymentSettings event, Emitter<PaymentSettingsState> emit,) async {
    emit(PaymentSettingsLoadingState());

    try {
      final apiRepo = GetapiRepo<PaymentSettingsModel>(
        url: paymentSettingUrl,
        fromJson: PaymentSettingsModel.fromJson,
        isToken: true,
      );

      final List<PaymentSettingsModel> responseList = await apiRepo.getData();

      final List<PaymentSettingsModel> paymentData = responseList;

      emit(PaymentSettingsSuccessState(paymentSettingData: paymentData));
    } catch (e) {
      emit(PaymentSettingsErrorState(errorMessage: e.toString()));
    }
  }
}
