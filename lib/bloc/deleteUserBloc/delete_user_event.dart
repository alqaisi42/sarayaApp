



import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DeleteUserEvent extends Equatable {

  @override
  List<Object?> get props => [];
}


class DeleteUser extends DeleteUserEvent {
final String userDevice;
final BuildContext context;

DeleteUser({required this.userDevice,required this.context});

  @override
  List<Object?> get props => [];
}