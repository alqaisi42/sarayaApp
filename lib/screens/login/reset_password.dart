import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';

import 'package:newsapp/utils/widgets/custom_textfield.dart';

import '../../bloc/forgatePasswordBloc/forgot_password_bloc.dart';
import '../../bloc/forgatePasswordBloc/forgot_password_event.dart';
import '../../bloc/forgatePasswordBloc/forgot_password_state.dart';
import '../../../l10n/app_localizations.dart';

import '../../config/helper/helper_functions.dart';






class ResetPasswordscreen extends StatelessWidget {
  ResetPasswordscreen({super.key});

  final TextEditingController resetEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (context) => ForgatePasswordBloc(),
        child: BlocConsumer<ForgatePasswordBloc, ForgatePasswordState>(
          listener: (context, state) {
            if (state is ForgatePasswordSuccessState) {
              CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.resetPasswordEmailSentSuccessfullyPleaseCheckYourEmail, 1);
            } else if (state is ForgatePasswordErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              body: Container(
                margin: EdgeInsets.only(
                  left: MediaQueryHelper.screenWidth(context) * 0.04,
                  right: MediaQueryHelper.screenWidth(context) * 0.04,
                  top: MediaQueryHelper.screenHeight(context) * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.forgotPassword,
                      style: TextStyle(fontSize: 22, fontFamily: fontType),
                    ),
                    SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.01,
                    ),
                    Text(
                      AppLocalizations.of(context)!.pleaseEnterTheEmailAddressLinkedWithYourAccount,

                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontFamily: fontType,
                      ),
                    ),
                    SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.04,
                    ),
                    MyTextField(
                      label: AppLocalizations.of(context)!.emial,
                      controller: resetEmailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: MediaQueryHelper.screenHeight(context) * 0.04,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is ForgatePasswordLoadingState
                            ? null
                            : () {
                          if (resetEmailController.text.trim().isEmpty) {
                            CustomFloatingSnackBar.showCustomSnackBar(context, AppLocalizations.of(context)!.pleaseEnterYourEmail, 0);
                            return;
                          }
                          context.read<ForgatePasswordBloc>().add(
                            PostForgatePassword(
                              userEmail: resetEmailController.text.trim(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQueryHelper.screenHeight(context) * 0.01,
                          ),
                          backgroundColor: AppColors().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: state is ForgatePasswordLoadingState
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          AppLocalizations.of(context)!.sendEmail,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: fontType,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}