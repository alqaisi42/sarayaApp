import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DetailspageEvent extends Equatable{}

class FetchDetailspage extends DetailspageEvent{
  final String? slug;
  final bool refreshIndicator;
  final BuildContext context;
  final String deviceid;
  final String? fcmToken;

  FetchDetailspage({required this.slug,this.refreshIndicator = false, required this.context,required this.deviceid,this.fcmToken});
  @override
  List<Object?> get props => [slug];
}