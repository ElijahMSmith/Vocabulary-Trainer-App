import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_trainer_app/misc/util.dart';

final List<int> defaultSchedule = [0, 1, 3, 7, 7, 14, 30, 365];

// TODO: Store the last used language pairing (update after submit to the last in the column)
// When we create a card without any existing in the list, use this value as the default pairing

// Update selector to include a scrollable listing of some of the most common choices or offer to enter manually
// Keep a list of languages entered manually in SP

class SPHelper {
  static final SPHelper _instance = SPHelper._internal();
  SharedPreferences? _prefs;

  List<int> _schedule = defaultSchedule;
  bool _resetAfterMiss = true;
  bool _useDarkTheme = true;

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
}
