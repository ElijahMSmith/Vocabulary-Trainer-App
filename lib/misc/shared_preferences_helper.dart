import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_trainer_app/misc/util.dart';

final List<int> defaultSchedule = [0, 1, 3, 7, 7, 14, 30, 365];

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

    return await _prefs!
        .setStringList("schedule", intListToStringList(newSchedule));
  }

  bool get resetAfterMiss {
    return _resetAfterMiss;
  }

  Future<bool> updateResetAfterMiss(bool newVal) async {
    if (!isReady) return false;

    return await _prefs!.setBool("resetAfterMiss", newVal);
  }

  bool get useDarkTheme {
    return _useDarkTheme;
  }

  Future<bool> updateUseDarkTheme(bool newVal) async {
    if (!isReady) return false;

    return await _prefs!.setBool("useDarkTheme", newVal);
  }
}
