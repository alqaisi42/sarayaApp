

import 'package:equatable/equatable.dart';

abstract class ReportCommentEvent extends Equatable{
  @override
  List<Object?> get props => [];
}


class ReportComment extends ReportCommentEvent{
  final int commentid;
  final String txt;

  ReportComment({required this.commentid,required this.txt});

  @override
  List<Object?> get props => [commentid,txt];
}
