


import 'package:equatable/equatable.dart';

abstract class ContactUsEvent extends Equatable{

  @override
  List<Object?> get props => [];
}


class ContactUsPost extends ContactUsEvent{
  final String userEmail;
  final String userMessage;

  ContactUsPost({required this.userEmail,required this.userMessage});

  @override
  List<Object> get props => [userEmail,userMessage];
}