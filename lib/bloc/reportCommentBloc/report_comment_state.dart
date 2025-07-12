
import 'package:equatable/equatable.dart';

import '../../Model/report_comment_model.dart';

abstract class ReportCommentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportCommentInitialState extends ReportCommentState {}

class ReportCommentLoadingState extends ReportCommentState {}

class ReportCommentSuccessState extends ReportCommentState {
  final List<ReportCommentResponse> reportCommentData;

  ReportCommentSuccessState({required this.reportCommentData});

  @override
  List<Object?> get props => [reportCommentData];
}

class ReportCommentErrorState extends ReportCommentState {
  final String errorMessage;

  ReportCommentErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
