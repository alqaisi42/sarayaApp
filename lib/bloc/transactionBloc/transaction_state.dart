
import 'package:equatable/equatable.dart';

import '../../Model/transaction_model.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccessState extends TransactionState {
  final List<TransactionModel> transactionData;

  TransactionSuccessState({required this.transactionData});


  @override
  List<Object?> get props => [transactionData];

}


class TransactionErrorState extends TransactionState {
  final String errorMessasge;

  TransactionErrorState({required this.errorMessasge});

  @override
  List<Object?> get props => [errorMessasge];
}