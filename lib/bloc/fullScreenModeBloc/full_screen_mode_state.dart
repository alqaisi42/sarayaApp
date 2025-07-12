

import 'package:equatable/equatable.dart';

abstract class FullScreenMode extends Equatable{


  @override
  List<Object?> get props => [];
}

class FullScreenState extends FullScreenMode {
  final bool isFullScreen;
  FullScreenState({required this.isFullScreen});

  @override
  List<Object?> get props => [isFullScreen];
}