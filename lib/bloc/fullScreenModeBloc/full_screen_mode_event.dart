import 'package:equatable/equatable.dart';

abstract class FullScreenEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class ToggleFullScreen extends FullScreenEvent {
  final bool? isFullScreenCheck;

  ToggleFullScreen({this.isFullScreenCheck});

  @override
  List<Object?> get props => [isFullScreenCheck];

}