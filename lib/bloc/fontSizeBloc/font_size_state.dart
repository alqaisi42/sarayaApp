

import 'package:equatable/equatable.dart';


import '../../config/helper/helper_functions.dart';

abstract class FontSizeState extends Equatable{
  @override
  List<Object?> get props => [];
}

class FontSizeInitial extends FontSizeState {}

class FontSizeLoading extends FontSizeState {}

class FontSizeLoaded extends FontSizeState {
  final FontSize fontSize;

  FontSizeLoaded(this.fontSize);
}

class FontSizeError extends FontSizeState {
  final String message;

  FontSizeError(this.message);
}