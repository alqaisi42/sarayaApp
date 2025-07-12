



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/transactionBloc/transaction_event.dart';
import 'package:newsapp/bloc/transactionBloc/transaction_state.dart';

import '../../Model/transaction_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitialState()) {
    on<FetchTransaction>(_onFetchTransaction);
  }

  Future<void> _onFetchTransaction(
      FetchTransaction event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final apiRepo = GetapiRepo(
        url: transactionHistoryUrl, // Your API endpoint
        fromJson: TransactionModel.fromJson,
        isToken: true,
      );

      final List<TransactionModel> transactions = await apiRepo.getData();

      emit(TransactionSuccessState(transactionData: transactions));
    } catch (e) {
      emit(TransactionErrorState(errorMessasge: e.toString()));
    }
  }
}