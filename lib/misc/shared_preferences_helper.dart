import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/misc/util.dart';

// TODO: Update selector to include a scrollable listing of some of the most common choices or offer to enter manually
// Keep a list of languages entered manually in SP

class SPHelper {
  static final SPHelper _instance = SPHelper._internal();
  SharedPreferences? _prefs;

  List<int> _schedule = defaultSchedule;
  bool _resetAfterMiss = true;
  bool _useDarkTheme = true;
  String _defaultTermLanguage = "English";
  String _defaultDefinitionLanguage = "English";

  factory SPHelper() {
    return _instance;
  }

  SPHelper._internal() {
    // Initialization Logic
    SharedPreferences.getInstance().then((sp) async {
      List<String>? retrieved = sp.getStringList("schedule");
      if (retrieved != null)
        _schedule = stringListToIntList(retrieved);
      else
        _schedule = defaultSchedule;

      _resetAfterMiss = sp.getBool("resetAfterMiss") ?? true;
      _useDarkTheme = sp.getBool("useDarkTheme") ?? true;
      _defaultTermLanguage = sp.getString("defaultTermLanguage") ?? "English";
      _defaultDefinitionLanguage =
          sp.getString("defaultDefinitionLanguage") ?? "English";

      _prefs = sp;
      debugPrint("Shared Preferences Data Retrieved!");
    });
  }

  bool get isReady {
    return _prefs != null;
  }

  List<int> get schedule {
    return _schedule;
  }

  Future<bool> updateSchedule(List<int> newSchedule) async {
    if (!isReady) return false;

    bool success = await _prefs!
        .setStringList("schedule", intListToStringList(newSchedule));
    if (success) _schedule = newSchedule;

    return success;
  }

  bool get resetAfterMiss {
    return _resetAfterMiss;
  }

  Future<bool> updateResetAfterMiss(bool newVal) async {
    if (!isReady) return false;

    bool success = await _prefs!.setBool("resetAfterMiss", newVal);
    if (success) _resetAfterMiss = newVal;

    return success;
  }

  bool get useDarkTheme {
    return _useDarkTheme;
  }

  Future<bool> updateUseDarkTheme(bool newVal) async {
    if (!isReady) return false;

    bool success = await _prefs!.setBool("useDarkTheme", newVal);
    if (success) _useDarkTheme = newVal;

    return success;
  }

  String get defaultTermLanguage {
    return _defaultTermLanguage;
  }

  String get defaultDefinitionLanguage {
    return _defaultDefinitionLanguage;
  }

  Future<bool> updateMostRecentTermLanguages(
    String newTermLanguage,
    String newDefinitionLanguage,
  ) async {
    if (!isReady) return false;

    bool termSuccess =
        await _prefs!.setString("defaultTermLanguage", newTermLanguage);
    if (termSuccess) _defaultTermLanguage = newTermLanguage;

    bool defSuccess = await _prefs!
        .setString("defaultDefinitionLanguage", newDefinitionLanguage);
    if (defSuccess) _defaultDefinitionLanguage = newDefinitionLanguage;

    return termSuccess && defSuccess;
  }
}
