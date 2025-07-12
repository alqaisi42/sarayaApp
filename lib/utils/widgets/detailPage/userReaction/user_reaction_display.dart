import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/utils/widgets/detailPage/userReaction/reac_user_list.dart';

import '../../../../bloc/totalReactionBloc/total_reaction_bloc.dart';
import '../../../../bloc/totalReactionBloc/total_reaction_state.dart';
import '../../../../config/constants.dart';
import '../../../../l10n/app_localizations.dart';


class ReactionDisplay extends StatelessWidget {
  final String slug;

  const ReactionDisplay({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalReactionCountBloc, TotalReactionCountState>(
      builder: (context, state) {
        if (state.reactionData.isEmpty) {
          return const SizedBox.shrink();
        }
        String countText = "";
        if (state.totalCount > 1) {
          countText = state.userHasReacted
              ? "${AppLocalizations.of(context)!.you} + ${state.totalCount - 1}"
              : '${state.totalCount}';
        } else {
          if (state.userHasReacted) {
            countText = AppLocalizations.of(context)!.you;
          } else {
            countText = '${state.totalCount}';
          }
        }

        return InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              enableDrag: true,
              builder: (BuildContext context) {
                return CustomBottomSheet(slug: slug);
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stack of emojis - now shows for any number of reactions
              SizedBox(
                width: state.reactionData.length >= 3
                    ? 50
                    : state.reactionData.length == 2
                    ? 38
                    : 26,
                height: 26,
                child: Stack(
                  children: [
                    ...state.reactionData
                        .take(3)
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      return Positioned(
                        left: entry.key * 12.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            entry.value['emojiPath'],
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 3),
              state.userHasReacted
                  ?  SizedBox(width: 4)
                  :  SizedBox.shrink(),
              Text(
                countText,
                style:  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontType
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}