
import 'package:equatable/equatable.dart';


abstract class GetReactUserDataEvent extends Equatable {
  const GetReactUserDataEvent();
  @override
  List<Object?> get props => [];
}

class FetchReactUserData extends GetReactUserDataEvent {
  final int initialValue;
  final String emojiType;
  final String slug;

  const FetchReactUserData({this.initialValue = 1, this.emojiType = "",this.slug = ""});

  @override
  List<Object?> get props => [initialValue, emojiType];
}

class FetchMoreReactUserData extends GetReactUserDataEvent {
  @override
  List<Object?> get props => [];
}




