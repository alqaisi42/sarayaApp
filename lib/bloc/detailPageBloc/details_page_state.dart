import 'package:equatable/equatable.dart';

import '../../Model/detail_page_model.dart';

abstract class DetailspageState extends Equatable{
  @override
  List<Object?> get props => [];
}


class DetailspageInitialState extends DetailspageState{}

class DetailspageLoadingState extends DetailspageState{}

class DetailspageSuccessState extends DetailspageState{
 final List<DetailPageResponse> detailPage;


  DetailspageSuccessState({required this.detailPage});
}

class DetailspageErrorState extends DetailspageState{
  final String errorMessage;

  DetailspageErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}