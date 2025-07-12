

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLocationEvent extends LocationEvent {
  final BuildContext context;

  FetchLocationEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
