

import 'package:flutter/material.dart';
import 'package:newsapp/utils/widgets/detailPage/translator/translation_service.dart';




class TranslatedText extends StatefulWidget {
  final String text;

  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,

  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  final TranslationService _translationService = TranslationService();
  String _translatedText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _translateText();
    // Listen to changes in target language
    _translationService.targetLanguage.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _translationService.targetLanguage.removeListener(_onLanguageChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _translateText();
    }
  }

  void _onLanguageChanged() {
    _translateText();
  }

  Future<void> _translateText() async {
    // Only start loading if we have a target language
    if (_translationService.targetLanguage.value.isEmpty) {
      setState(() {
        _translatedText = widget.text;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final translatedText = await _translationService.translateText(widget.text);

    if (mounted) {
      setState(() {
        _translatedText = translatedText;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always show the text (either original or translated)
    final textToShow = _translatedText.isEmpty ? widget.text : _translatedText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              height: 2,
              child: LinearProgressIndicator(),
            ),
          ),
        Text(
          textToShow,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        ),
      ],
    );
  }
}