import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


abstract class EmojiPostEvent extends Equatable{}

class PostEmojiDetails extends EmojiPostEvent{
  final String? slug;
  final String? type;
  final BuildContext? context;


  PostEmojiDetails({required this.slug,required this.type,this.context});
  @override
  List<Object?> get props => [slug,type];
}