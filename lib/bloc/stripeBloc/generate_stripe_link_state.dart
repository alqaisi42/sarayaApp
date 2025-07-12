import 'package:equatable/equatable.dart';


import '../../Model/stripe_model.dart';

abstract class GenerateStripeLinkState extends Equatable{
  const GenerateStripeLinkState();
  @override

  List<Object?> get props => [];
}

class GenerateStripeLinkInitial extends GenerateStripeLinkState{}

class GenerateStripeLinkLoading extends GenerateStripeLinkState{}

class GenerateStripeLinkSuccess extends GenerateStripeLinkState{
  final List<StripeResModel> generateStripeLinkData;
  const GenerateStripeLinkSuccess({required this.generateStripeLinkData});
  @override

  List<Object?> get props => [generateStripeLinkData];
}

class GenerateStripeLinkFailure extends GenerateStripeLinkState{
  final String errorMessage;

   const GenerateStripeLinkFailure({required this.errorMessage});

  @override

  List<Object?> get props => [errorMessage];
}