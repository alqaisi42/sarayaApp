

import 'package:equatable/equatable.dart';

import '../../Model/get_settings_model.dart';

abstract class GetSettingsState extends Equatable{

  @override
  List<Object?> get props => [];
}

class GetSettingsInitialState extends GetSettingsState{}

class GetSettingsLoadingState extends GetSettingsState{}

class GetSettingsSuccessState extends GetSettingsState{
  final List<GetSettingsResponse> getSettingsData;

  GetSettingsSuccessState({required this.getSettingsData});

  @override
  List<Object?> get props => [getSettingsData];
}

class GetSettingsErrorState extends GetSettingsState{
  final String errorMessage;

  GetSettingsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}