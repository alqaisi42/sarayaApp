
import 'package:equatable/equatable.dart';

abstract class ForgatePasswordEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class PostForgatePassword extends ForgatePasswordEvent {
  final String? userEmail;

  PostForgatePassword({required this.userEmail});

  @override
  List<Object?> get props => [userEmail];
}