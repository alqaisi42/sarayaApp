

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../bloc/getSettingsBloc/get_settings_bloc.dart';
import '../../bloc/getSettingsBloc/get_settings_state.dart';
import '../../config/constants.dart';
import '../../../l10n/app_localizations.dart';

class CustomeProfileDisplayData extends StatelessWidget {
  final String title;
  final String slug;

  const CustomeProfileDisplayData({
    super.key,
    required this.title,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 22, fontFamily: fontType),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<GetSettingsBloc, GetSettingsState>(
        builder: (context, state) {
          if (state is GetSettingsSuccessState) {
            try {
              final matchingData = state.getSettingsData[0].data?.firstWhere(
                    (item) => item.name == slug,
              );

              if (matchingData?.value == null) {
                return  Center(
                  child: Text(AppLocalizations.of(context)!.nodatafoundforthissection,style: TextStyle(fontFamily: fontType),),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(matchingData!.value!),
              );
            } catch (e) {
              return Center(
                child: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}',style: TextStyle(fontFamily: fontType),),
              );
            }
          }


          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

