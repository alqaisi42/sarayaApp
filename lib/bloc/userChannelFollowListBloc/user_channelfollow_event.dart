
import 'package:equatable/equatable.dart';

abstract class UserChannelfollowEvent extends Equatable {
  const UserChannelfollowEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserChannelfollow extends UserChannelfollowEvent {


  final int initialValue;

 const FetchUserChannelfollow({ this.initialValue = 1});

  @override
  List<Object?> get props => [];
}

class FetchMoreUserChannelfollow extends UserChannelfollowEvent {}

