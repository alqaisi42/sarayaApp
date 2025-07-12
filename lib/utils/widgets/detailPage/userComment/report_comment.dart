



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/reportCommentBloc/report_comment_bloc.dart';
import '../../../../bloc/reportCommentBloc/report_comment_event.dart';
import '../../../../bloc/reportCommentBloc/report_comment_state.dart';
import '../../../../config/colors.dart';
import '../../../../config/constants.dart';

import '../../../../config/helper/helper_functions.dart';
import '../../../../l10n/app_localizations.dart';

class ReportCommentPopup extends StatelessWidget {
  final int commentId;
  final TextEditingController _commentController = TextEditingController();

  ReportCommentPopup({super.key, required this.commentId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCommentBloc, ReportCommentState>(
      listener: (context, state) {
        if (state is ReportCommentSuccessState) {
          Navigator.pop(context);
          Navigator.pop(context);
          CustomFloatingSnackBar.showCustomSnackBar(
            context,
            state.reportCommentData[0].message.toString(),
            1,
          );
        } else if (state is ReportCommentErrorState) {
          Navigator.pop(context);
          Navigator.pop(context);
          CustomFloatingSnackBar.showCustomSnackBar(
            context,
            state.errorMessage,
            0,
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.reportComment,style: TextStyle(fontFamily: fontType),),
          content: TextField(
            controller: _commentController,
            cursorColor: Colors.red,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.yourComment,
              labelStyle: TextStyle(color: AppColors.whiteColor),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors().primaryColor),
              ),
            ),
          ),
          actions: [
            if (state is ReportCommentLoadingState)
               CircularProgressIndicator(color: AppColors().primaryColor)
            else ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: AppColors().primaryColor,fontFamily: fontType),
                ),
              ),
              TextButton(
                onPressed: () {
                  final txt = _commentController.text.trim();
                  if (txt.isEmpty) {

                  } else {

                    context.read<ReportCommentBloc>().add(
                      ReportComment(
                        commentid: commentId,
                        txt: txt,
                      ),
                    );
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.send,
                  style: TextStyle(color: AppColors().primaryColor,fontFamily: fontType),
                ),
              ),
            ],
          ],
        );
      },
    );
  }}