import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:newsapp/utils/widgets/detailPage/translator/translation_service.dart';

import '../../../../config/hiveLocalStorage/hive_storage.dart';
import 'languages_code.dart';







class LanguageSelector extends StatelessWidget {
  final TranslationService translationService = TranslationService();



  LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<String>(
      valueListenable: translationService.targetLanguage,
      builder: (context, targetLanguage, child) {
        // Determine what text to display
        String displayText = "Change Language";

        // If a language is selected, find its name and display that instead
        if (targetLanguage.isNotEmpty) {
          final selectedLanguage = languagesCode.firstWhere(
                  (lang) => lang['code'] == targetLanguage,
              orElse: () => {'code': targetLanguage, 'name': targetLanguage}
          );
          displayText = selectedLanguage['name']!;
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha:0.2),
              width: 1,
            ),
          ),
          child: PopupMenuButton<String>(
            elevation: 8,
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    HeroiconsSolid.language,
                    size: 22,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    displayText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 22,
                  ),
                ],
              ),
            ),

              onSelected: (String languageCode) async {
                final hiveStorage = HiveStorage();

                String? sourceLanguage = await hiveStorage.getLanguageCode();


                if (translationService.sourceLanguage.value.isEmpty && languageCode.isNotEmpty) {
                  translationService.updateLanguages(
                      source: sourceLanguage,
                      target: languageCode
                  );
                } else {
                  translationService.updateLanguages(target: languageCode);
                }
              },
            itemBuilder: (BuildContext context) {
              return languagesCode.map((language) {
                final isSelected = language['code'] == targetLanguage;

                return PopupMenuItem<String>(
                  value: language['code'],
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    decoration: isSelected ? BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(8),
                    ) : null,
                    padding: isSelected ? const EdgeInsets.all(8) : EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          language['name']!,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList();
            },
          ),
        );
      },
    );
  }
}