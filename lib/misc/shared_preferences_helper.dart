import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_trainer_app/misc/util.dart';

final List<int> defaultSchedule = [0, 1, 3, 7, 7, 14, 30, 365];

class SPHelper {
  static late List<int> _schedule;
  static late SharedPreferences _prefs;

  static Future<void> initializeSP() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? retrieved = _prefs.getStringList("schedule");

    if (retrieved == null) {
      await _prefs.setStringList(
        "schedule",
        intListToStringList(defaultSchedule),
      );
      _schedule = defaultSchedule;
    } else {
      _schedule = stringListToIntList(retrieved);
    }
  }

  static Future<bool> updateSchedule(List<int> newSchedule) async {
    await _prefs.setStringList("schedule", intListToStringList(newSchedule));
    return true;
  }

  static List<int> get schedule {
    return _schedule;
  }
}
