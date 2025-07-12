
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart' as google_translator;

class TranslationService {
  static final TranslationService instance = TranslationService._internal();
  factory TranslationService() => instance;
  TranslationService._internal();

  final translator = google_translator.GoogleTranslator();


  final ValueNotifier<String> sourceLanguage = ValueNotifier<String>('');
  final ValueNotifier<String> targetLanguage = ValueNotifier<String>('');


  Future<String> translateText(String text) async {

    if (sourceLanguage.value.isEmpty ||
        targetLanguage.value.isEmpty ||
        sourceLanguage.value == targetLanguage.value) {
      return text;
    }

    try {
      var translation = await translator.translate(
        text,
        from: sourceLanguage.value,
        to: targetLanguage.value,
      );

      return translation.text;
    } catch (e) {

      return text; // Return original text on error
    }
  }

  // Method to change language settings
  void updateLanguages({String? source, String? target}) {
    if (source != null) {
      sourceLanguage.value = source;
    }
    if (target != null) {
      targetLanguage.value = target;
    }
  }

  // Reset to no language selected
  void resetToDefault() {
    sourceLanguage.value = '';
    targetLanguage.value = '';
  }
}