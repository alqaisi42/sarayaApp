

import 'dart:developer';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../../Model/membership_model.dart';
import '../../config/api_routes.dart';

import '../../config/helper/helper_functions.dart';
import '../../config/hiveLocalStorage/hive_storage.dart';
import '../blocRepository/get_api_repo.dart';
import 'membership_event.dart';
import 'membership_state.dart';


class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  MembershipBloc() : super(MembershipInitializationState()) {
    on<FetchMembershipPlans>((event, emit) async {
      emit(MembershipLoadingState());
      try {
        final apiRepo = GetapiRepo(url: memberShipPlanUrl, fromJson: MembershipPlansModel.fromJson, isToken: true);
        final membershipPlans = await apiRepo.getData();
        final features = await HiveStorage().getFreePlanFeatures();
        final hiveStorage = HiveStorage();

        final activeSubscription = membershipPlans[0].data.activeSubscription;
        final activatePlanData = activeSubscription.status;
        final postLimit = activeSubscription.maxArticles.toString();
        final storiesLimit = activeSubscription.maxStories.toString();
        final articleCount = activeSubscription.articleCount.toString();
        final storyCount = activeSubscription.storyCount.toString();
        final endDateStr = activeSubscription.endDate;
        final lastEndDateStr = membershipPlans[0].data.endDate;

        if (activatePlanData == true) {
          // User has active plan - store the plan data
          await storeFreePlanDataHive(
            articleLimit: postLimit,
            storyLimit: storiesLimit,
            isActivePlan: activatePlanData,
            articleCount: articleCount,
            storyCount: storyCount,
          );

          if (endDateStr.isNotEmpty) {
            final DateTime endDate = DateTime.parse(endDateStr);
           

            await hiveStorage.storeEndDate(endDate);
          }
        } else {

          if (lastEndDateStr.isNotEmpty) {
            final DateTime lastEndDate = DateTime.parse(lastEndDateStr);
           
            await storeFreePlanDataHive(
              articleLimit: features?['articleLimit']?.toString() ?? '0',
              storyLimit: features?['storyLimit']?.toString() ?? '0',
              isActivePlan: activatePlanData,
            );

            await hiveStorage.storeLastEndDate(lastEndDate);
          }

          // Check if plan has expired and clear data if needed
          await checkAndHandlePlanExpiration();
        }

        emit(MembershipSuccessState(membershipPlanData: membershipPlans));
      } catch (e, stackTrace) {
        log('ERROR: $e');
        log('STACKTRACE: $stackTrace');
        emit(MembershipErrorState(errorMessage: e.toString()));
      }
    });
  }

  Future<void> checkAndHandlePlanExpiration() async {

    final hiveStorage = HiveStorage();
    try {
      final storedDateRange = await hiveStorage.getDateRange();

      final endDate = storedDateRange['endDate'];
      final lastEndDate = storedDateRange['lastEndDate'];

      // First check if both dates exist (not null)
      if (endDate != null && lastEndDate != null) {
        // Format dates for logging
        String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
        String formattedLastEndDate = DateFormat('yyyy-MM-dd').format(lastEndDate);
        log("Comparing dates - endDate: $formattedEndDate, lastEndDate: $formattedLastEndDate");

        // Check if the dates are at the same moment (for more accurate comparison, consider comparing just dates)
        if (isSameDay(endDate, lastEndDate)) {
          log("Plan expired! Dates match: ${endDate.isAtSameMomentAs(lastEndDate)}");
          await hiveStorage.clearPlanFeatures();
          await hiveStorage.clearDateRange();
          await hiveStorage.clearLastFreePlanUpdateTime();
          log('Plan expired and both dates are same. Hive storage cleared.');
        } else {
          log('Plan not expired yet or dates do not match.');
        }
      } else {
        log('One or both dates are missing in Hive storage.');
      }
    } catch (e) {
      log('Error checking plan expiration: $e');
    }
  }

  // Helper method to compare just the date part (ignoring time)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
