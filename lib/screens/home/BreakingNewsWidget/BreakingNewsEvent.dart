// lib/bloc/breakingNewsBloc/breaking_news_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BreakingNewsEvent extends Equatable {
  const BreakingNewsEvent();
}

class FetchBreakingNews extends BreakingNewsEvent {
  final BuildContext context;

  const FetchBreakingNews({required this.context});

  @override
  List<Object?> get props => [context];
}
