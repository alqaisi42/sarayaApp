import 'package:equatable/equatable.dart';

import '../../Model/contact_us_model.dart';

abstract class ContactUsState extends Equatable {


  @override
  List<Object?> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final List<ContactUsModel> contactUsData;

   ContactUsSuccess({required this.contactUsData});

  @override
  List<Object> get props => [contactUsData];
}

class ContactUsError extends ContactUsState {
  final String error;

   ContactUsError({required this.error});

  @override
  List<Object> get props => [error];
}