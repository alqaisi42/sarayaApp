

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/constants.dart';

import '../../../bloc/userChannelFollowListBloc/user_channelfollow_bloc.dart';
import '../../../bloc/userChannelFollowListBloc/user_channelfollow_event.dart';
import '../../../bloc/userChannelFollowListBloc/user_channelfollow_state.dart';
import '../../../config/colors.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/widgets/follow_channel.dart';


class UserChannelFollow extends StatefulWidget {
  const UserChannelFollow({super.key});

  @override
  State<UserChannelFollow> createState() => _UserChannelFollowState();
}

class _UserChannelFollowState extends State<UserChannelFollow> {
  @override
  void initState() {
    super.initState();
    context.read<UserChannelfollowBloc>().add(FetchUserChannelfollow(initialValue: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        scrolledUnderElevation: 1.0,
        title: Text(
          AppLocalizations.of(context)!.followedChannels,
          style: const TextStyle(
            fontFamily: fontType,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: false,

      ),
      body: RefreshIndicator(
        color: AppColors().primaryColor,
        onRefresh: () async {
          context.read<UserChannelfollowBloc>().add(FetchUserChannelfollow());
        },
        child: BlocBuilder<UserChannelfollowBloc, UserChannelfollowState>(
          builder: (context, state) {
            if (state is UserChannelfollowInitialState || (state is UserChannelfollowLoadingState && state.userChannelFollowList.isEmpty)) {
              return _buildLoadingShimmer();
            } else if (state is UserChannelfollowErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage,
                      style: TextStyle(
                        fontFamily: fontType,
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<UserChannelfollowBloc>().add(FetchUserChannelfollow());
                      },
                      icon:  Icon(Icons.refresh),
                      label: Text(AppLocalizations.of(context)!.retry),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors().primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return _buildChannelList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          borderRadius: 16,
        );
      },
    );
  }

  Widget _buildChannelList() {
    return BlocBuilder<UserChannelfollowBloc, UserChannelfollowState>(
      builder: (context, state) {
        final bloc = context.read<UserChannelfollowBloc>();
        final allChannels = bloc.userChannlFollowData.expand((response) => response.data?.channels ?? []).toList();

        if (allChannels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors().primaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.noFollowedChannels,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: fontType,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    GoRouter.of(context).push("/channelsAll",extra: 'userChannelFollow');
                  },
                  icon: Icon(Icons.explore, color: AppColors().primaryColor),
                  label: Text(
                    AppLocalizations.of(context)!.discoverChannels,
                    style: TextStyle(color: AppColors().primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0, // optional, if you want flat look
                    backgroundColor: Colors.transparent, // no fill color
                    shadowColor: Colors.transparent, // remove shadow
                    side: BorderSide(color: AppColors().primaryColor), // border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // optional rounded corners
                    ),
                  ),
                ),

              ],
            ),
          );
        }

        return ListView.builder(
          controller: bloc.scrollController,
          padding: EdgeInsets.symmetric(
            vertical: MediaQueryHelper.screenHeight(context) * 0.01,
            horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
          ),
          itemCount: allChannels.length + 1,
          itemBuilder: (context, index) {
            if (index == allChannels.length) {
              if (state is UserChannelfollowLoadingMoreState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors().primaryColor,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }

            final item = allChannels[index];
            return GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/customNewsPage/${item.slug}');
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQueryHelper.screenHeight(context) * 0.01),
                child: DisplayUserChannelFollow(
                  id: item.id,
                  channelName: item.name ?? '',
                  logo: item.logo ?? '',
                  channelSlug: item.slug ?? '',
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DisplayUserChannelFollow extends StatelessWidget {
  final int? id;
  final String? logo;
  final String? channelName;
  final String? channelSlug;

  const DisplayUserChannelFollow({
    super.key,
    required this.id,
    required this.logo,
    required this.channelName,
    required this.channelSlug,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            // Channel Image with animation
            Hero(
              tag: 'channel-$id',
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    logo ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Channel Name and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channelName ?? "",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: fontType,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.article_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                         "Tap to view news",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: fontType,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Follow Button
            FollowButton(
              channelslug: channelSlug ?? "",
            ),
          ],
        ),
      ),
    );
  }
}

// class _UserChannelFollowState extends State<UserChannelFollow> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<UserChannelfollowBloc>().add(FetchUserChannelfollow(initialValue: 1));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:  Text(AppLocalizations.of(context)!.followedChannels,style: TextStyle(fontFamily: fontType),),
//         centerTitle: false,
//       ),
//       body: RefreshIndicator(
//         color: AppColors().primaryColor,
//         onRefresh: () async {
//           context.read<UserChannelfollowBloc>().add(FetchUserChannelfollow(refreshIndicator: true));
//         },
//         child: BlocBuilder<UserChannelfollowBloc, UserChannelfollowState>(
//           builder: (context, state) {
//             if (state is UserChannelfollowInitialState || (state is UserChannelfollowLoadingState && state.userChannelFollowList.isEmpty)) {
//               return _buildLoadingShimmer();
//             } else if (state is UserChannelfollowErrorState) {
//               return Center(child: Text(state.errorMessage,style: TextStyle(fontFamily: fontType),));
//             } else {
//               return _buildChannelList();
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingShimmer() {
//     return ListView.builder(
//       itemCount: 8,
//       itemBuilder: (context, index) {
//         return ShimmerWidget(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.1,
//           margin: EdgeInsets.only(
//             top: MediaQuery.of(context).size.height * 0.02,
//             left: MediaQuery.of(context).size.width * 0.03,
//             right: MediaQuery.of(context).size.width * 0.03,
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildChannelList() {
//     return BlocBuilder<UserChannelfollowBloc, UserChannelfollowState>(
//       builder: (context, state) {
//         final bloc = context.read<UserChannelfollowBloc>();
//         final allChannels = bloc.userChannlFollowData.expand((response) => response.data?.channels ?? []).toList();
//
//         if (allChannels.isEmpty) {
//           return Center(
//             child: Container(
//               padding: EdgeInsets.all(14.0),
//               decoration: BoxDecoration(
//                 color: AppColors().primaryColor,
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               child: Text(
//                 AppLocalizations.of(context)!.noFollowedChannels,
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   color: Colors.white,
//                   fontFamily: fontType
//                 ),
//               ),
//             ),
//           );
//         }
//
//         return ListView.builder(
//           controller: bloc.scrollController,
//           itemCount: allChannels.length + 1,
//           itemBuilder: (context, index) {
//             if (index == allChannels.length) {
//               if (state is UserChannelfollowLoadingMoreState) {
//                 return const Center(child: CircularProgressIndicator(color: AppColors().primaryColor));
//               } else {
//                 return const SizedBox.shrink();
//               }
//             }
//
//             final item = allChannels[index];
//             // print("Check user follow list ${allChannels[]}");
//             return GestureDetector(
//               onTap: () {
//                 GoRouter.of(context).push('/channelDetail/${item.slug}');
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: MediaQueryHelper.screenWidth(context) * 0,
//                   right: MediaQueryHelper.screenWidth(context) * 0,
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.only(top: MediaQueryHelper.screenHeight(context) * 0.01),
//                   child: GestureDetector(
//                     onTap: () {
//                       GoRouter.of(context).push('/customNewsPage/${item.slug}');
//                     },
//                     child: DisplayUserChannelFollow(
//                       id: item.id,
//                         channelName: item.name ?? '',
//                         logo: item.logo ?? '',
//                         channelSlug: item.slug ?? '',
//
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
//
// class DisplayUserChannelFollow extends StatelessWidget {
//
//   final int? id;
//   final String? logo;
//   final String? channelName;
//   final String? channelSlug;
//
//
//
//   const DisplayUserChannelFollow({
//     super.key,
//     required this.id,required this.logo,required this.channelName,required this.channelSlug,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: MediaQueryHelper.screenWidth(context) * 0.03),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Theme.of(context).colorScheme.primary,
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: MediaQueryHelper.screenWidth(context) * 0.03,
//             vertical: MediaQueryHelper.screenHeight(context) * 0.01,
//           ),
//           child: Row(
//             children: [
//               // Image and Name
//               Expanded(
//                 child: Row(
//                   children: [
//                     // Channel Image
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Image.network(
//                         logo ?? "",
//                         height: 50,
//                         width: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             height: 50,
//                             width: 50,
//                             color: Colors.grey[200],
//                             child: Icon(Icons.image, color: Colors.grey),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16.0),
//                     // Channel Name
//                     Expanded(
//                       child: Text(
//                         channelName ?? "",
//                         style: const TextStyle(
//                           fontSize: 16.0,
//                           fontFamily: fontType,
//                           fontWeight: FontWeight.bold,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               FollowButton(
//                 channelslug: channelSlug ?? "",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



