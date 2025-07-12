

import 'package:equatable/equatable.dart';

abstract class MultiNewsPostEvent extends Equatable{

  @override
  List<Object?> get props => [];
}


class PostNewsLanguageId extends MultiNewsPostEvent {
  final String newsLanguageId;

  PostNewsLanguageId({required this.newsLanguageId});

  @override
  List<Object?> get props => [newsLanguageId];
}