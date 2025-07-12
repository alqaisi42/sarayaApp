


import 'package:equatable/equatable.dart';

abstract class GenerateSignatureEvent extends Equatable {

  @override
  List<Object?> get props => [];
}


class PostSingnatureDetails extends GenerateSignatureEvent {
  final String planAmount;
  final String planId;
  final String tenureId;

  PostSingnatureDetails({required this.planId,required this.planAmount,required this.tenureId});


  @override
  List<Object?> get props => [planAmount,planId,tenureId];

}