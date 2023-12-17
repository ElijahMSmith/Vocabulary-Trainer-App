import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_trainer_app/misc/util.dart';

const List<int> DEFAULT_SCHEDULE = [0, 1, 3, 7, 7, 14, 30, 365];

// TODO: Keep a list of languages entered manually in SP
class SPHelper {
  static final SPHelper _instance = SPHelper._internal();
  SharedPreferences? _prefs;

  List<int> _schedule = DEFAULT_SCHEDULE;
  bool _resetAfterMiss = true;
  bool _useDarkTheme = true;
  String _defaultTermLanguage = "English";
  String _defaultDefinitionLanguage = "English";

  factory SPHelper() {
    return _instance;
  }

  SPHelper._internal();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    List<String>? retrieved = _prefs!.getStringList("schedule");
    if (retrieved != null)
      _schedule = stringListToIntList(retrieved);
    else
      _schedule = DEFAULT_SCHEDULE;

    _resetAfterMiss = _prefs!.getBool("resetAfterMiss") ?? true;
    _useDarkTheme = _prefs!.getBool("useDarkTheme") ?? true;
    _defaultTermLanguage =
        _prefs!.getString("defaultTermLanguage") ?? "English";
    _defaultDefinitionLanguage =
        _prefs!.getString("defaultDefinitionLanguage") ?? "English";
  }

  bool get isReady {
    return _prefs != null;
  }

  List<int> get schedule {
    return _schedule;
  }

  Future<bool> updateSchedule(List<int> newSchedule) async {
    bool success = await _prefs!
        .setStringList("schedule", intListToStringList(newSchedule));
    if (success) _schedule = newSchedule;

    return success;
  }

  bool get resetAfterMiss {
    return _resetAfterMiss;
  }

  Future<bool> updateResetAfterMiss(bool newVal) async {
    bool success = await _prefs!.setBool("resetAfterMiss", newVal);
    if (success) _resetAfterMiss = newVal;

    return success;
  }

  bool get useDarkTheme {
    return _useDarkTheme;
  }

  Future<bool> updateUseDarkTheme(bool newVal) async {
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
    bool termSuccess =
        await _prefs!.setString("defaultTermLanguage", newTermLanguage);
    if (termSuccess) _defaultTermLanguage = newTermLanguage;

    bool defSuccess = await _prefs!
        .setString("defaultDefinitionLanguage", newDefinitionLanguage);
    if (defSuccess) _defaultDefinitionLanguage = newDefinitionLanguage;

    return termSuccess && defSuccess;
  }
}
