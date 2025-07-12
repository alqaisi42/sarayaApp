

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DiscoverEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchDiscover extends DiscoverEvent{

  final BuildContext context;

  FetchDiscover({required this.context});

  @override
  List<Object?> get props => [context];
}

class FetchMoreDiscover extends DiscoverEvent {
  final BuildContext context;
  FetchMoreDiscover({required this.context});

  @override
  List<Object?> get props => [context];
}

