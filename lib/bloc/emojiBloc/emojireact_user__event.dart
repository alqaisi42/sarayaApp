import 'package:equatable/equatable.dart';

import '../../Model/detail_page_model.dart';
import '../../Model/react_emoji_model.dart';

abstract class EmojireactuserEvent extends Equatable{}

class InitialUserEmoji extends EmojireactuserEvent{
  final Map<int,UserReaction>? initialUserReactData;

  InitialUserEmoji({required this.initialUserReactData});


  @override
  List<Object?> get props => [initialUserReactData];
}



class UpdateUserEmoji extends EmojireactuserEvent{
  final Map<int,UpdateReactionsData> updateUserReactData;

  UpdateUserEmoji({required this.updateUserReactData});


  @override
  List<Object?> get props => [updateUserReactData];
}

