import 'package:equatable/equatable.dart';

abstract class FevoritesEvent extends Equatable{}

class PostFevorites extends FevoritesEvent{
  final String? id;

  PostFevorites({required this.id});
  @override
  List<Object?> get props => [id];
}

