// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sort_child_properties_last, avoid_unnecessary_containers

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';


import 'package:newsapp/screens/home/seachbar/search_result.dart';
import 'package:remixicon/remixicon.dart';

import '../../../bloc/languageBloc/language_switcher_bloc.dart';
import '../../../bloc/searchResultBloc/search_result_bloc.dart';
import '../../../bloc/searchResultBloc/search_result_event.dart';
import '../../../bloc/searchResultBloc/search_result_state.dart';
import '../../../bloc/suggestionBloc/suggestion_bloc.dart';
import '../../../bloc/suggestionBloc/suggestion_event.dart';
import '../../../bloc/suggestionBloc/suggestion_state.dart';
import '../../../config/check_internet.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';

import '../../../config/helper/helper_functions.dart';
import '../../../utils/widgets/no_internet_screen.dart';
import '../../../utils/widgets/reuse_searchbar.dart';
import '../../../l10n/app_localizations.dart';



class Discoversearch extends StatefulWidget {
  const Discoversearch({super.key});

  @override
  DiscoversearchState createState() => DiscoversearchState();
}



class DiscoversearchState extends State<Discoversearch> {
  TextEditingController searchController = TextEditingController();
  bool showSuggestions = false;
  bool isTyping = false;
  late SuggestionBloc _suggestionBloc;
  Timer? _debounce;


  List<ConnectivityResult> _connectionStatus = [];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;



  @override
  void initState() {
    super.initState();
    _suggestionBloc = SuggestionBloc();


    CheckInternet.initConnectivity().then((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        setState(() {
          _connectionStatus = results;
        });
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        CheckInternet.updateConnectionStatus(results).then((value) {
          setState(() {
            _connectionStatus = value;
            context.read<SearchResultBloc>().add(EmptySearchResult());
          });
        });
      }
    });

    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      if (searchController.text.isEmpty) {
        setState(() {
          showSuggestions = false;
        });
        return;
      }

      if (isTyping) {
        _debounce = Timer(const Duration(milliseconds: 500), () {
          setState(() => showSuggestions = true);
          _suggestionBloc.add(FetchSuggestion(suggestionVal: searchController.text));
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _suggestionBloc.close();
    _connectivitySubscription.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  void onSuggestionSelected(String suggestion) {
    setState(() {
      searchController.text = suggestion;
      showSuggestions = false;
      isTyping = false;
    });
    _handleSearch(suggestion);
  }

  void _handleSearch([String? searchText]) {
    final textToSearch = searchText ?? searchController.text;
    if (textToSearch.isNotEmpty) {
      setState(() {
        showSuggestions = false;
        isTyping = false;
      });
      context.read<SearchResultBloc>().add(
          FetchSearchResult(suggestionText: textToSearch,context: context)
      );
      FocusScope.of(context).unfocus();
    }
  }

  @override

  Widget build(BuildContext context) {
    return _connectionStatus.contains(connectivityCheck)
        ? NoInternetScreen()
        : Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(),

                BlocBuilder<SearchResultBloc, SearchResultState>(
                  builder: (context, state) {
                    final searchResultList =
                        context.read<SearchResultBloc>().searchResultList;

                    if (state is SearchResultLoadingState) {
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors().primaryColor,),
                        ),
                      );
                    }



                    if (searchResultList.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(HeroiconsSolid.newspaper,
                                  size: 150, ),
                              Text(
                                AppLocalizations.of(context)!.searchNews,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: fontType

                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SearchResultListWidget();
                  },
                ),
              ],
            ),
            if (showSuggestions && isTyping) _buildSuggestionsOverlay(),
          ],
        ),
      ),
    );
  }



  Widget _buildSearchBar() {
    final languageCode = context.read<LanguageBloc>().state.locale.languageCode;
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQueryHelper.screenWidth(context) * 0.03,
      ),
      child: Row(
        children: [
          _buildBackButton(),
           SizedBox(width: 5),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  isTyping = hasFocus;
                  if (!hasFocus) {
                    showSuggestions = false;
                  }
                });
              },
              child: SearchBarComman(
                searchHintText: AppLocalizations.of(context)!.searchNews,
                searchController: searchController,
                onChanged: (value) {
                  setState(() {
                    isTyping = true;
                  });
                },
                onEditingComplete: () => _handleSearch(),
              ),
            ),
          ),
          languageCode == 'ar' ? SizedBox(width: 5) :  SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    final languageCode = context.read<LanguageBloc>().state.locale.languageCode;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        context.read<SearchResultBloc>().add(EmptySearchResult());
      },
      child: Container(
        padding:  EdgeInsets.all(2),
        child:  Icon(languageCode == 'ar' ? Remix.arrow_right_s_line : Remix.arrow_left_s_line, size: 30),
      ),
    );
  }

  Widget _buildSuggestionsOverlay() {
    return Positioned(
      top: MediaQueryHelper.screenHeight(context) * 0.08,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            showSuggestions = false;
            isTyping = false;
          });
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: BlocBuilder<SuggestionBloc, SuggestionState>(
                  bloc: _suggestionBloc,
                  builder: (context, state) {
                    return _buildSuggestionContent(state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionContent(SuggestionState state) {
    if (state is SuggestionLoadingState) {
      return Container(
        padding: const EdgeInsets.all(16),
        child:  Center(
          child: CircularProgressIndicator(color: AppColors().primaryColor),
        ),
      );
    }

    if (state is SuggestionSuccessState) {
      final allData = state.suggestion
          .expand((item) => item.data ?? [])
          .toList();

      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQueryHelper.screenHeight(context) * 0.8,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: allData.length,
          separatorBuilder: (context, index) => Divider(
            height: 0.4,
            color: Colors.grey[300],
            indent: 16,
            endIndent: 16,
          ),
          itemBuilder: (context, index) => _buildSuggestionItem(allData[index]),
        ),
      );
    }

    if (state is SuggestionErrorState) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(state.errorMessage,style: TextStyle(fontFamily: fontType),),
      );
    }

    return const SizedBox();
  }

  Widget _buildSuggestionItem(data) {
    return GestureDetector(
      onTap: () => onSuggestionSelected(data.title ?? ''),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image with enhanced styling
              Container(
                width: MediaQueryHelper.screenWidth(context) * 0.15,
                height: MediaQueryHelper.screenHeight(context) * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageUtils.networkImage(
                    data.image,
                    fit: BoxFit.cover,
                    
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Title with better styling
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.title ?? '',
                      style:  TextStyle(
                        fontSize: 13,
                        fontFamily: fontType,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),


                  ],
                ),
              ),


              Icon(
                Icons.north_west,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildSuggestionItem(data) {
  //   return GestureDetector(
  //     onTap: () => onSuggestionSelected(data.title ?? ''),
  //     child: ListTile(
  //       leading: ClipRRect(
  //         borderRadius: BorderRadius.circular(5.0),
  //         child: ImageUtils.networkImage(data.image,width: MediaQueryHelper.screenWidth(context) * 0.13,height: MediaQueryHelper.screenHeight(context) * 0.04,fit: BoxFit.cover)
  //       ),
  //       title: Text(
  //         data.title ?? '',
  //         style: const TextStyle(
  //           fontSize: 14,
  //           fontFamily: fontType
  //         ),
  //         maxLines: 2,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: 16,
  //         vertical: 8,
  //       ),
  //     ),
  //   );
  // }
}