
import 'package:equatable/equatable.dart';


import '../../config/helper/helper_functions.dart';

abstract class FontSizeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFontSize extends FontSizeEvent {}

class ChangeFontSize extends FontSizeEvent {
  final FontSize fontSize;

  ChangeFontSize(this.fontSize);

  @override
  List<Object?> get props => [fontSize];
}