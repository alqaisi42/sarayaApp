import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/react_emoji_model.dart';
import '../../config/api_routes.dart';
import '../blocRepository/get_api_repo.dart';
import '../emojiBloc/emojireact_user_bloc.dart';
import '../emojiBloc/emojireact_user__event.dart';
import '../totalReactionBloc/total_reaction_bloc.dart';
import '../totalReactionBloc/total_reaction_event.dart';
import 'emoji_post_event.dart';
import 'emoji_post_state.dart';



class EmojiPostBloc extends Bloc<EmojiPostEvent,EmojiPostState>{
  EmojiPostBloc() : super(EmojiPostInitialState()){
    on<PostEmojiDetails>(onEmojiPostEvent);
  }

  Future<void> onEmojiPostEvent(PostEmojiDetails event, Emitter<EmojiPostState> emit) async {
    try {
      final apiRepo = GetapiRepo(
        url: "$postEmojiUrl/${event.type}/${event.slug}",
        fromJson: ReactEmojiReponse.fromJson,
        isToken: true,
      );

      final List<ReactEmojiReponse> emojiData = await apiRepo.getData();

      if (event.context!.mounted) {

        List<UpdateReactionsData>? reactionsList = emojiData[0].data!.reactions;

        Map<int, UpdateReactionsData> reactionsMap = {
          for (int i = 0; i < reactionsList!.length; i++) i: reactionsList[i]
        };

        event.context?.read<EmojiReactUserBloc>().add(UpdateUserEmoji(updateUserReactData: reactionsMap));

        if(emojiData.first.data!.userHasReacted == true){

          event.context?.read<TotalReactionCountBloc>().add(UpdateTotalCount(updatedCountData: reactionsMap, userHasReacted: true));
        }else {

          event.context?.read<TotalReactionCountBloc>().add(UpdateTotalCount(updatedCountData: reactionsMap, userHasReacted: false));
        }


      }
      emit(EmojiPostSuccessState(emojiDetail: emojiData));
    } catch (e) {
      emit(EmojiPostErrorState(errorMessage: e.toString()));
    }
  }


}

