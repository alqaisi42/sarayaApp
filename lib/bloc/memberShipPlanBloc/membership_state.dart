import 'package:equatable/equatable.dart';
import '../../Model/membership_model.dart';

abstract class MembershipState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MembershipInitializationState extends MembershipState {}

class MembershipLoadingState extends MembershipState {}

class MembershipSuccessState extends MembershipState {
  final List<MembershipPlansModel> membershipPlanData;

  MembershipSuccessState({required this.membershipPlanData});

  @override
  List<Object?> get props => [membershipPlanData];
}

class MembershipErrorState extends MembershipState {
  final String errorMessage;

  MembershipErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
