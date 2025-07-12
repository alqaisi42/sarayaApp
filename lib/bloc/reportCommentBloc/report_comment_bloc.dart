

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/bloc/reportCommentBloc/report_comment_event.dart';
import 'package:newsapp/bloc/reportCommentBloc/report_comment_state.dart';

import '../../Model/report_comment_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/post_api_repo.dart';

class ReportCommentBloc extends Bloc<ReportCommentEvent, ReportCommentState> {
  final PostapiRepo<ReportCommentResponse> _postapiRepo;

  ReportCommentBloc() :
        _postapiRepo = PostapiRepo<ReportCommentResponse>(fromJson: ReportCommentResponse.fromJson, isToken: true),
        super(ReportCommentInitialState()) {
    on<ReportComment>(_onPostComments);
  }

  Future<void> _onPostComments(ReportComment event, Emitter<ReportCommentState> emit) async {
    emit(ReportCommentLoadingState());
    try {
      final result = await _postapiRepo.postData(reportCommentUrl,report: event.txt,reportCommentId: event.commentid.toString());
      emit(ReportCommentSuccessState(reportCommentData: result));
    } catch (e) {
      emit(ReportCommentErrorState(errorMessage: e.toString()));
    }
  }
}
