import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/colors.dart';


import '../../../bloc/fontSizeBloc/font_size_bloc.dart';
import '../../../bloc/fontSizeBloc/font_size_event.dart';
import '../../../bloc/fontSizeBloc/font_size_state.dart';
import '../../../l10n/app_localizations.dart';

import '../../../config/helper/helper_functions.dart';

class FontSizePopup extends StatefulWidget {
  final String initialFontSize;

  const FontSizePopup({super.key, required this.initialFontSize});

  @override
  State<FontSizePopup> createState() => _FontSizePopupState();


}



class _FontSizePopupState extends State<FontSizePopup> {
  late List<FontSize> _fontSizes;
  late FontSize _selectedFontSize;

  @override
  void initState() {
    super.initState();
    _selectedFontSize = FontSize.fromString(widget.initialFontSize);
  }

  @override
  Widget build(BuildContext context) {
    _fontSizes = FontSize.values;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.selectFontSize,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _fontSizes.length,
            itemBuilder: (context, index) {
              return RadioListTile<FontSize>(
                title: Text(
                  _fontSizes[index].getLocalizedName(context),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                value: _fontSizes[index],
                groupValue: _selectedFontSize,
                activeColor: AppColors().primaryColor,
                onChanged: (FontSize? value) {
                  setState(() {
                    _selectedFontSize = value!;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                    color:AppColors().primaryColor
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedFontSize.name); // Pass name
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().primaryColor,
                  foregroundColor: AppColors.whiteColor,
                ),
                child: Text(AppLocalizations.of(context)!.apply),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




void showFontSizePopup(BuildContext context) {
  final state = context.read<FontSizeBloc>().state;
  String currentFontSizeStr = 'Medium';

  if (state is FontSizeLoaded) {
    currentFontSizeStr = state.fontSize.name;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FontSizePopup(initialFontSize: currentFontSizeStr);
    },
  ).then((selectedSize) {
    if (selectedSize != null) {
      final fontSize = FontSize.fromString(selectedSize);
      if (context.mounted) {
        context.read<FontSizeBloc>().add(ChangeFontSize(fontSize));
      }
    }
  });
}


