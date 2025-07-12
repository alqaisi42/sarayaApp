import 'package:equatable/equatable.dart';

import '../../Model/fevorites_model.dart';

abstract class FevoritesState extends Equatable{
  @override
  List<Object?> get props => [];
}


class FevoritesInitialState extends FevoritesState{}

class FevoritesLoadingState extends FevoritesState{}

class FevoritesSuccessState extends FevoritesState{
final  List<FevoriteResponse> fevorites;


  FevoritesSuccessState({required this.fevorites});
}

class FevoritesErrorState extends FevoritesState{
  final String errorMessage;

  FevoritesErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

