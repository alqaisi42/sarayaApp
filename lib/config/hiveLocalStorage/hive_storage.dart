import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';

import '../../Model/auth model/auth_response_model.dart';


class HiveStorage {
  final String themeBoxName = "themebox";
  final String tokenBoxName = 'tokenbox';
  final String authTokenKey = 'authToken';
  final String languageBoxName = 'languagebox';
  final String defaultLanguageBoxName = 'defaultLanguagebox';
  final String languageKey = 'selectedLanguage';
  final String fontSizeKey = 'fontSize';
  final String  freePlanFeaturesKey = 'freePlanFeatures';
  final String  selectedLanguageKey = 'selectedLanguage';
  final String lastFreePlanUpdateKey = 'lastFreePlanUpdate';
  final String firstLaunchBoxName = 'firstLaunchBox';
  final String firstLaunchKey = 'isFirstLaunch';
  final String languageCodeMapKey = 'languageCodeMap';
  final String endDateBoxName = 'endDateBox';
  final String lastEndDateBoxName = 'lastEndDateBox';
  final String isAdFreeBocKey = 'isAdFreeBocKey';






  //================================================ Store User Token

  Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }

  Future<void> storeToken(AuthResponse authResponse) async {
    final box = await openBox(tokenBoxName);
    String authResponseJson = jsonEncode(authResponse);
    await box.put(authTokenKey, authResponseJson);
  }

  Future<AuthResponse?> getToken() async {
    final box = await openBox(tokenBoxName);
    final String? authResponseJson = box.get(authTokenKey);

    if (authResponseJson == null) {
      return null;
    }

    try {
      Map<String, dynamic> jsonMap = jsonDecode(authResponseJson);
      return AuthResponse.fromJson(jsonMap);
    } catch (e) {
      log("Error decoding token: $e");
      return null;
    }
  }

  Future<void> clearToken() async {
    var box = await openBox(tokenBoxName);
    await box.delete((authTokenKey));
  }


  //================================================ Store Language

  Future<String?> getLanguage() async {
    final box = await openBox(languageBoxName);
    return box.get(languageKey);
  }

  Future<void> storeLanguage(String languageCode) async {
    final box = await openBox(languageBoxName);

    await box.put(languageKey, languageCode);
  }

  Future<void> storeDefaultLanguage(String languageCode) async {
    final box = await openBox(defaultLanguageBoxName);
    await box.put(languageKey, languageCode);
  }

  Future<String?> getDefaultLanguage() async {
    final box = await openBox(defaultLanguageBoxName);
    return box.get(languageKey);
  }

  // ============================================== Store Font Size
  Future<void> storeFontSize(String fontSizeValue) async {
    final box = await openBox(fontSizeKey);

    await box.put(fontSizeKey, fontSizeValue);
  }

  Future<String?> getFontSize() async {
    final box = await openBox(fontSizeKey);
    return box.get(fontSizeKey, defaultValue: 'Medium');
  }



// ==================================================================  Store Free Plan Features
  Future<void> storeFreePlanFeatures(Map<String, dynamic> features) async {
    final box = await openBox(freePlanFeaturesKey);
    final jsonString = jsonEncode(features);



    await box.put(freePlanFeaturesKey, jsonString);
  }



  Future<Map<String, dynamic>?> getFreePlanFeatures() async {
    final box = await openBox(freePlanFeaturesKey);
    final jsonString = box.get(freePlanFeaturesKey);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> features = jsonDecode(jsonString);



      if (features['articleLimit'] is int) {
        features['articleLimit'] = features['articleLimit'].toString();
      }

      return features;
    } catch (e) {
      log("Error decoding MembershipFeatures: $e");
      return null;
    }
  }


  Future<void> updateFreePlanFeatures(Map<String, dynamic> updatedFields) async {
    final box = await openBox(freePlanFeaturesKey);
    final jsonString = box.get(freePlanFeaturesKey);

    log("updated artical $updatedFields");

    Map<String, dynamic> existingData = {};
    if (jsonString != null) {
      try {
        existingData = jsonDecode(jsonString);
      } catch (e) {
        log("Error decoding MembershipFeatures for update: $e");
      }
    }


    // Update only the provided fields
    existingData.addAll(updatedFields);


    final updatedJsonString = jsonEncode(existingData);
    await box.put(freePlanFeaturesKey, updatedJsonString);
  }

  Future<void> clearPlanFeatures() async {
    final box = await openBox(freePlanFeaturesKey);

    await box.delete(freePlanFeaturesKey);
  }



  // ==================================================================  Store Selected Languages
  Future<void> storeSelectedLanguages(List<Map<String, dynamic>> languages) async {
    final box = await openBox(selectedLanguageKey);
    final jsonString = jsonEncode(languages);
    log("Storing selected languages: $jsonString");
    await box.put(selectedLanguageKey, jsonString);
  }

  Future<List<Map<String, dynamic>>> getSelectedLanguages() async {
    final box = await openBox(selectedLanguageKey);
    final jsonString = box.get(selectedLanguageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return List<Map<String, dynamic>>.from(decodedList);
    } catch (e) {
      log("Error decoding selected languages: $e");
      return [];
    }
  }

  Future<void> clearSelectedLanguages() async {
    final box = await openBox(selectedLanguageKey);
    await box.delete(selectedLanguageKey);
  }

  Future<void> updateSelectedLanguage(Map<String, dynamic> language) async {
    final List<Map<String, dynamic>> currentLanguages = await getSelectedLanguages();


    final int index = currentLanguages.indexWhere((lang) => lang['id'] == language['id']);

    if (index != -1) {

      currentLanguages[index] = language;
    } else {

      currentLanguages.add(language);
    }

    await storeSelectedLanguages(currentLanguages);
  }

  Future<void> removeSelectedLanguage(int languageId) async {
    final List<Map<String, dynamic>> currentLanguages = await getSelectedLanguages();
    currentLanguages.removeWhere((lang) => lang['id'] == languageId);
    await storeSelectedLanguages(currentLanguages);
  }

// ==================================================================  LastFreePlanUpdateTime

  Future<void> setLastFreePlanUpdateTime(DateTime time) async {
    final box = await openBox(lastFreePlanUpdateKey);
    log('Saving last update time: $time');

    await box.put(lastFreePlanUpdateKey, time.toIso8601String());
  }

  Future<DateTime?> getLastFreePlanUpdateTime() async {
    final box = await openBox(lastFreePlanUpdateKey);
    final timeString = box.get(lastFreePlanUpdateKey);

    if (timeString == null) return null;

    try {
      return DateTime.parse(timeString);
    } catch (e) {
      log("Error parsing last update time: $e");
      return null;
    }
  }

  Future<void> clearLastFreePlanUpdateTime() async {
    final box = await openBox(lastFreePlanUpdateKey);
    await box.delete(lastFreePlanUpdateKey);
  }


// ================================================================== setFirstLaunchDone Language Select

  Future<void> setFirstLaunchDone() async {
    final box = await openBox(firstLaunchBoxName);
    await box.put(firstLaunchKey, true);
  }

  Future<bool> isFirstLaunch() async {
    final box = await openBox(firstLaunchBoxName);
    return box.get(firstLaunchKey, defaultValue: false) == false;
  }


// ================================================================== Details page Change Language
  Future<void> storeLanguageCode(String languageCode) async {
    final box = await openBox(languageCodeMapKey);
    await box.put(languageKey, languageCode);
    log("Stored language code: $languageCode");
  }

  // Get the stored language code
  Future<String?> getLanguageCode() async {
    final box = await openBox(languageCodeMapKey);
    final code = box.get(languageKey);
    return code;
  }

// ================================================================== Get End Date of Plans

  Future<void> storeEndDate(DateTime endDate) async {
    final box = await openBox(endDateBoxName);
    await box.put('endDate', endDate.toIso8601String());
    log('Stored endDate: $endDate');
  }

  Future<void> storeLastEndDate(DateTime lastEndDate) async {
    final box = await openBox(lastEndDateBoxName);
    await box.put('lastEndDate', lastEndDate.toIso8601String());
    log('Stored lastEndDate: $lastEndDate');
  }

  Future<Map<String, DateTime?>> getDateRange() async {
    final endDateBox = await openBox(endDateBoxName);
    final lastEndDateBox = await openBox(lastEndDateBoxName);

    String? endDateStr = endDateBox.get('endDate');
    String? lastEndDateStr = lastEndDateBox.get('lastEndDate');

    DateTime? endDate;
    DateTime? lastEndDate;

    try {
      if (endDateStr != null) {
        endDate = DateTime.parse(endDateStr);
      }
      if (lastEndDateStr != null) {
        lastEndDate = DateTime.parse(lastEndDateStr);
      }
    } catch (e) {
      log("Error parsing date: $e");
    }

    return {
      'endDate': endDate,
      'lastEndDate': lastEndDate,
    };
  }



  Future<void> clearDateRange() async {
    final endDateBox = await openBox(endDateBoxName);
    final lastEndDateBox = await openBox(lastEndDateBoxName);

    await endDateBox.delete('endDate');
    await lastEndDateBox.delete('lastEndDate');

    log('Date range cleared from Hive storage');
  }


  // ================================================================== Store Ad Free Status

  Future<void> setAdFreeStatus(bool isAdFree) async {
    final box = await openBox(isAdFreeBocKey);
    await box.put(isAdFreeBocKey, isAdFree);
    log('Stored ad free status: $isAdFree');
  }

  Future<bool> getAdFreeStatus() async {
    final box = await openBox(isAdFreeBocKey);
    return box.get(isAdFreeBocKey, defaultValue: false);
  }

  Future<void> clearAdFreeStatus() async {
    final box = await openBox(isAdFreeBocKey);
    await box.delete(isAdFreeBocKey);
    log('Ad free status cleared from Hive storage');
  }

}





@HiveType(typeId: 1)
class DateRangeModel extends HiveObject {
  @HiveField(0)
  DateTime endDate;

  @HiveField(1)
  DateTime lastEndDate;

  DateRangeModel({required this.endDate, required this.lastEndDate});
}



