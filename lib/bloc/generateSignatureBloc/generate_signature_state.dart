

import 'package:equatable/equatable.dart';



import '../../Model/generate_signature_model.dart';

abstract class GenerateSignatureState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenerateSignatureInitialState extends GenerateSignatureState {}

class GenerateSignatureLoadingState extends GenerateSignatureState {}

class GenerateSignatureSuccessState extends GenerateSignatureState {
  final List<GenerateSignatureModel> generateSignatur;

  GenerateSignatureSuccessState({required this.generateSignatur});

  @override
  List<Object?> get props => [generateSignatur];

}

class GenerateSignatureErrorState extends GenerateSignatureState {
  final String errorMessage;

  GenerateSignatureErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
