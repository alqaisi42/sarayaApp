import 'package:equatable/equatable.dart';

abstract class GenerateStripeLinkEvent extends Equatable{
  const GenerateStripeLinkEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GenerateStripeLinkRequest extends GenerateStripeLinkEvent{
  final int tenureId;
  final double planAmount;
  final int planId;

  const GenerateStripeLinkRequest({required this.tenureId,required this.planId,required this.planAmount});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}