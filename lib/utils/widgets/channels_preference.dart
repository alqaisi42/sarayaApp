import 'dart:async';
import 'dart:developer';
import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/channelsPreferenceBloc/channel_preference_bloc.dart';
import '../../bloc/channelsPreferenceBloc/channel_preference_event.dart';
import '../../bloc/channelsPreferenceBloc/channel_preference_state.dart';
import '../../bloc/getSettingsBloc/get_settings_bloc.dart';
import '../../bloc/getSettingsBloc/get_settings_state.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../config/helper/helper_functions.dart';
import '../../config/shimmer.dart';

import 'follow_channel.dart';


class ChannelsPreference extends StatefulWidget {
  const ChannelsPreference({super.key});

  @override
  State<ChannelsPreference> createState() => _ChannelsPreferenceState();
}

class _ChannelsPreferenceState extends State<ChannelsPreference> {

  @override
  void initState() {
    super.initState();
    context.read<ChannelsPreferenceBloc>().add(FetchChannelsPreference(context: context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.channels,style: TextStyle(fontFamily: fontType),),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: MediaQueryHelper.screenWidth(context) * 0.04),
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pushReplacement("/home");
                },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColors().primaryColor,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                AppLocalizations.of(context)!.skip,
                style: TextStyle(fontSize: 16, color: AppColors().primaryColor,fontFamily: fontType),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer();
          final bloc = context.read<ChannelsPreferenceBloc>();
          bloc.stream.listen((state) {
            if (state is ChannelsPreferenceSuccessState ||
                state is ChannelsPreferenceErrorState) {
              completer.complete();
            }
          });

          // Trigger the fetch
          bloc.add(FetchChannelsPreference(context: context));

          // Wait for completion
          return completer.future;
        },
        color: AppColors().primaryColor,
        child: ChannelList(),
      ),
    );
  }
}

class ChannelList extends StatelessWidget {
  const ChannelList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelsPreferenceBloc, ChannelsPreferenceState>(
      builder: (context, state) {
        if (state is ChannelsPreferenceLoadingState) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.1,
                  ),
                  padding: EdgeInsets.all(MediaQueryHelper.screenWidth(context) * 0.03),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                        left: MediaQueryHelper.screenWidth(context) * 0.02,
                        right: MediaQueryHelper.screenWidth(context) * 0.02,
                      ),
                      child: ShimmerWidget(
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.zero,
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(MediaQueryHelper.screenWidth(context) * 0.04),
                child: const SizedBox(height: 56),
              ),
            ],
          );
        }

        if (state is ChannelsPreferenceSuccessState) {
          final channelsData = state.channels.first.data;
          final channels = channelsData?.channels;
          log("total channels ${channels!.length}");
          if (channels.isEmpty) {
            return  Center(child: Text(AppLocalizations.of(context)!.noChannelsAvailable));
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.1,
                  ),
                  padding: EdgeInsets.all(MediaQueryHelper.screenWidth(context) * 0.03),
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channelData = channels[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      margin: EdgeInsets.only(
                        left: MediaQueryHelper.screenWidth(context) * 0.02,
                        right: MediaQueryHelper.screenWidth(context) * 0.02,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQueryHelper.screenWidth(context) * 0.17,
                            height: MediaQueryHelper.screenHeight(context) * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: ImageUtils.networkImageProvider(channelData.logo),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                          Text(
                            channelData.name ?? "",
                            style:  TextStyle(fontSize: 16,fontFamily: fontType),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
                          FollowButton(channelslug: channelData.slug.toString()),
                        ],
                      ),
                    );
                  },
                ),
              ),
              BlocBuilder<GetSettingsBloc, GetSettingsState>(
                builder: (context, state) {
                  bool isNewsLanguageEnabled = false;
                  if (state is GetSettingsSuccessState) {
                    final newsLanguageStatus = state.getSettingsData[0].data?.firstWhere(
                        (setting) => setting.name == 'news_language_status',
                    );
                    isNewsLanguageEnabled = newsLanguageStatus?.value == 'true';
                  }

                  return Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(MediaQueryHelper.screenWidth(context) * 0.04),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                            GoRouter.of(context).pushReplacement("/home");

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isNewsLanguageEnabled ? "Next" : AppLocalizations.of(context)!.save,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontType,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Container(
              //   color: Colors.transparent,
              //   padding: EdgeInsets.all(MediaQueryHelper.screenWidth(context) * 0.04),
              //   child: SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         // GoRouter.of(context).pushReplacement("/home");
              //         GoRouter.of(context).push("/multiLangNews");
              //       },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: AppColors().primaryColor,
              //         foregroundColor: Colors.white,
              //         padding:  EdgeInsets.symmetric(vertical: 10),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //       child:  Text(
              //         AppLocalizations.of(context)!.save,
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           fontFamily: fontType
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01,)
            ],
          );
        }

        if (state is ChannelsPreferenceErrorState) {
          return Center(
              child: Text('${AppLocalizations.of(context)!.error}: ${state.errorMessage}',style: TextStyle(fontFamily: fontType),)
          );
        }

        return const SizedBox();
      },
    );
  }
}



