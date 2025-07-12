

import 'package:equatable/equatable.dart';

import '../../Model/detail_page_model.dart';
import '../../Model/react_emoji_model.dart';

abstract class TotalReactionCountEvent extends Equatable {


  @override
  List<Object?> get props => [];
}

class InitialTotalCount extends TotalReactionCountEvent {
  final Map<int, UserReaction>? initialCountData;
  final bool userHasReacted;

  InitialTotalCount({required this.initialCountData,required this.userHasReacted});
}

class UpdateTotalCount extends TotalReactionCountEvent {
  final Map<int, UpdateReactionsData> updatedCountData;
  final bool userHasReacted;

  UpdateTotalCount({required this.updatedCountData,required this.userHasReacted});
}