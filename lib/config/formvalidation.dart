

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../../l10n/app_localizations.dart';

String? validateEmail(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.emailIsRequired;
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return AppLocalizations.of(context)!.validEmail;
  }
  return null;
}

String? validatePassword(String? value,context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.passwordIsRequired;
  }
  if (value.length < 8) {
    return AppLocalizations.of(context)!.passwordMustBeAtLeast8CharactersLong;
  }
  bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
  bool hasLowercase = value.contains(RegExp(r'[a-z]'));
  bool hasDigit = value.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacter = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  if (!hasUppercase) {
    return AppLocalizations.of(context)!.passwordMustContainAtLeastOneUppercaseLetter;
  }
  if (!hasLowercase) {
    return AppLocalizations.of(context)!.passwordMustContainAtLeastOneLowercaseLetter;
  }
  if (!hasDigit) {
    return AppLocalizations.of(context)!.passwordMustContainAtLeastOneDigit;
  }
  if (!hasSpecialCharacter) {
    return AppLocalizations.of(context)!.passwordMustContainAtLeastOneSpecialCharacter;
  }
  return null;
}


String? validateReenterPassword(String? value, BuildContext context, TextEditingController passwordController) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.pleaseReEnterYourPassword;
  }
  if (value != passwordController.text) {
    return AppLocalizations.of(context)!.passwordsDoNotMatch;
  }
  return null;
}



String? validateName(String? value,context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.nameIsRequired;
  }
  return null;
}

void submitForm(formKey,emailController) {
  if (formKey.currentState!.validate()) {
    log('Form is valid. Email: ${emailController.text}');
  }
}