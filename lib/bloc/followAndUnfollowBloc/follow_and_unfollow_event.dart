import 'package:equatable/equatable.dart';

abstract class FollowAndunfollowEvent extends Equatable{}

class PostFollowAndunfollow extends FollowAndunfollowEvent{
  final String? slug;
  PostFollowAndunfollow({required this.slug});
  @override
  List<Object?> get props => [slug];
}

