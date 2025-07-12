import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../config/constants.dart';

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  factory LanguageState.initial() => const LanguageState(locale: Locale(defaultLanguage));

  LanguageState copyWith({Locale? locale}) {
    return LanguageState(locale: locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}
