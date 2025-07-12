import 'package:equatable/equatable.dart';

abstract class SliderEvent extends Equatable{}

class FetchSlider extends SliderEvent{
  final bool refreshIndicator;
  final bool reFetch;

  FetchSlider({this.refreshIndicator = false,this.reFetch = false});


  @override
  List<Object?> get props => [];
}

class ClearSliderData extends SliderEvent {
  @override
  List<Object?> get props => [];
}