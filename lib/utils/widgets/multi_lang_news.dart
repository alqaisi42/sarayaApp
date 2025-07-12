import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:newsapp/config/colors.dart';


import '../../bloc/channelBloc/channel_bloc.dart';
import '../../bloc/channelBloc/channel_event.dart';

import '../../bloc/languageBloc/language_switcher_bloc.dart';
import '../../bloc/languageBloc/language_switcher_event.dart';
import '../../bloc/multiLanguageGetBloc/multi_lang_bloc.dart';
import '../../bloc/multiLanguageGetBloc/multi_lang_event.dart';
import '../../bloc/multiLanguageGetBloc/multi_lang_state.dart';

import '../../bloc/newsTopicsBloc/news_topic_bloc.dart';
import '../../bloc/newsTopicsBloc/news_topic_event.dart';
import '../../bloc/popularHomeNewsBloc/popular_news_home_bloc.dart';
import '../../bloc/popularHomeNewsBloc/popular_news_home_event.dart';
import '../../bloc/recommendationNewsBloc/recommendation_bloc.dart';
import '../../bloc/recommendationNewsBloc/recommendation_event.dart';
import '../../bloc/sliderBloc/slider_bloc.dart';
import '../../bloc/sliderBloc/slider_event.dart';
import '../../bloc/storiesBloc/stories_bloc.dart';
import '../../bloc/storiesBloc/stories_event.dart';
import '../../config/constants.dart';
import '../../l10n/app_localizations.dart';

import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../../config/shimmer.dart';

import '../../routes/app_routes.dart';

class MultiLangNews extends StatefulWidget {
  final String? pageName;
  const MultiLangNews({super.key, this.pageName});

  @override
  State<MultiLangNews> createState() => _MultiLangNewsState();
}

class _MultiLangNewsState extends State<MultiLangNews> {
  // The currently saved language ID
  int? selectedLanguageId;
  // Temporarily store the language ID that the user has tapped on
  int? tempSelectedLanguageId;
  final HiveStorage _hiveStorage = HiveStorage();

  @override
  void initState() {
    super.initState();
    context.read<MultiLangBloc>().add(FetchMultiLang());
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final savedLanguages = await _hiveStorage.getSelectedLanguages();
    if (savedLanguages.isNotEmpty) {
      // Take only the first saved language
      if (savedLanguages[0]['id'] != null) {
        setState(() {
          selectedLanguageId = savedLanguages[0]['id'] as int;
          // Initialize the temporary selection with the loaded selection
          tempSelectedLanguageId = selectedLanguageId;
        });
      }
      log("Loaded saved language ID: $selectedLanguageId");
    }
  }

  // Modified to handle temporary selection without updating isSelected in the data model
  void selectLanguage(int? languageId, String? languageName) async {
    if (languageId == null) return;

    setState(() {
      // Only update the temporary selection
      tempSelectedLanguageId = languageId;
    });

    log("Temporarily selected language ID: $tempSelectedLanguageId");
  }

  // New method to apply the temporary selection
  void applySelectedLanguage() {
    if (tempSelectedLanguageId != null) {
      setState(() {
        selectedLanguageId = tempSelectedLanguageId;
      });

      // Clear all saved languages first
      _hiveStorage.clearSelectedLanguages();

      // Get the name of the selected language
      String? languageName;
      String? languageCode;
      final state = context.read<MultiLangBloc>().state;
      if (state is MultiLangSuccessState && state.multiLangData.isNotEmpty) {
        final languages = state.multiLangData[0].data;
        if (languages != null) {
          for (var language in languages) {
            if (language.id == selectedLanguageId) {
              languageName = language.name;
              languageCode = language.code;
              break;
            }
          }
        }
      }


      final matchedLanguage = languagesCode.firstWhere(
            (lang) => lang['code'] == languageCode,orElse: () => {}, );

      if (matchedLanguage.isNotEmpty) {

        final selectedLanguageCode = matchedLanguage['code'];
        if (selectedLanguageCode != null) {
          context.read<LanguageBloc>().add(
            ChangeLanguage(languageCode: selectedLanguageCode),
          );
        }
      }


      // Then save the new selection
      _hiveStorage.updateSelectedLanguage(
          {'id': selectedLanguageId, 'name': languageName});



    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.selectLanguages,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: false,
        elevation: 0,
        actions: widget.pageName == "splashscreen"
            ? [
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQueryHelper.screenWidth(context) * 0.04),
                  child: ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pushReplacement("/home");
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors().primaryColor,
                          width: 1,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.skip,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: fontType,
                          color: AppColors().primaryColor),
                    ),
                  ),
                )
              ]
            : null,
      ),
      body: BlocBuilder<MultiLangBloc, MultiLangState>(
        builder: (context, state) {
          if (state is MultiLangLoadingState) {
            return GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return ShimmerWidget(
                  width: double.infinity,
                  height: 150,
                  borderRadius: 16,
                );
              },
            );
          } else if (state is MultiLangErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MultiLangBloc>().add(FetchMultiLang());
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          } else if (state is MultiLangSuccessState) {
            final languages = state.multiLangData[0].data;

            if (languages!.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noLanguagesAvailable),
              );
            }

            // Initialize tempSelectedLanguageId if it's null but there's a language with isSelected=true
            if (tempSelectedLanguageId == null) {
              for (var language in languages) {
                if (language.isSelected == true && language.id != null) {
                  tempSelectedLanguageId = language.id!;
                  selectedLanguageId = language.id!;
                  break;
                }
              }
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: tempSelectedLanguageId != null ? 80.0 : 0,
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final language = languages[index];

                        // Only use the tempSelectedLanguageId for UI display,
                        // not modifying the underlying language.isSelected property
                        final isSelected =
                            language.id == tempSelectedLanguageId;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Transform.scale(
                            scale: isSelected ? 1.05 : 1.0,
                            child: GestureDetector(
                              onTap: () =>
                                  selectLanguage(language.id, language.name),
                              child: AttractiveLangCard(
                                language: language,
                                isSelected: isSelected,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (tempSelectedLanguageId != null)
                    Positioned(
                      bottom: MediaQueryHelper.screenHeight(context) * 0.05,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Theme.of(context).primaryColor.withAlpha(50),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            applySelectedLanguage();

                            router.go('/home');
                            Future.microtask(() {
                              if (context.mounted) {
                                context.read<SliderBloc>().add(FetchSlider(refreshIndicator: true));
                                context.read<SliderBloc>().add(FetchSlider(refreshIndicator: true,));
                                context.read<ChannelBloc>().add(FetchChannels(refreshIndicator: true,));
                                context.read<PopularBloc>().add(FetchPopular(refreshIndicator: true,));
                                context.read<RecommendationBloc>().add(FetchRecommendation(refreshIndicator: true));
                                context.read<NewsTopicBloc>().add(FetchNewsTopic(refreshIndicator: true));
                                context.read<StoriesBloc>().add(FetchStories(reFetch: true));
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors().primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  color: AppColors.whiteColor),
                              const SizedBox(width: 5),
                              Text(
                                AppLocalizations.of(context)!.apply,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: fontType,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          }

          // Initial state
          return Center(
            child:
                Text(AppLocalizations.of(context)!.selectLanguagesToContinue),
          );
        },
      ),
    );
  }
}

class AttractiveLangCard extends StatefulWidget {
  final dynamic language;
  final bool isSelected;
  final Function()? onTap;

  const AttractiveLangCard({
    super.key,
    required this.language,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<AttractiveLangCard> createState() => _AttractiveLangCardState();
}

class _AttractiveLangCardState extends State<AttractiveLangCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AttractiveLangCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.4)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.1),
              blurRadius: widget.isSelected ? 12 : 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Animated background image
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: ImageUtils.networkImage(
                        widget.language.image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              // Dark overlay with animated opacity
              Positioned.fill(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black
                            .withValues(alpha: widget.isSelected ? 0.15 : 0.1),
                        Colors.black
                            .withValues(alpha: widget.isSelected ? 0.7 : 0.6),
                      ],
                    ),
                  ),
                ),
              ),
              // Language name centered
              Positioned.fill(
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: widget.isSelected ? 22 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    child: Text(widget.language.name),
                  ),
                ),
              ),
              // Selection indicator with animation
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                top: 8,
                right: 8,
                width: widget.isSelected ? 22 : 0,
                height: widget.isSelected ? 22 : 0,
                child: AnimatedOpacity(
                  opacity: widget.isSelected ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
              // Highlight border when selected
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
