import 'package:equatable/equatable.dart';

import '../../Model/slider_model.dart';

abstract class SliderState extends Equatable{
  @override
  List<Object?> get props => [];
}

class SliderInitialState extends SliderState{}

class SliderLoadingState extends SliderState{}

class SliderSuccessState extends SliderState{
final List<BannerPostsResponse> slider;

SliderSuccessState({required this.slider});

@override
  List<Object?> get props => [slider];
}

class SliderErrorState extends SliderState{
  final String errorMessage;

  SliderErrorState(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}


