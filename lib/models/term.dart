import 'dart:math';

import 'package:vocab_trainer_app/misc/db_helper.dart';

import '../misc/util.dart';
import '../misc/shared_preferences_helper.dart';

class Term {
  SPHelper sp = SPHelper();
  DBHelper db = DBHelper();

  // Initialize when DB is ready in main component setup
  static int nextId = -1;
  late int id;

  late final TermItem term;
  late final TermItem definition;

  late final DateTime created;
  late final DateTime lastChecked;

  int scheduleIndex = 0;
  int failedAttempts = 0;
  int successfulAttempts = 0;

  Term.blank() {
    id = nextId++;

    term = TermItem.blank();
    definition = TermItem.blank();

    DateTime now = standardizeTime(DateTime.now());
    created = now;
    lastChecked = now;
  }

  Term.fromQueryResult(Map<String, Object?> item) {
    term = TermItem(
      item["termItem"] as String,
      item["termLanguage"] as String,
    );
    definition = TermItem(
      item["definitionItem"] as String,
      item["definitionLanguage"] as String,
    );
    created = DateTime.fromMillisecondsSinceEpoch(item["created"] as int);
    lastChecked =
        DateTime.fromMillisecondsSinceEpoch(item["lastChecked"] as int);
    id = item["id"] as int;
  }

  Term.fromTermItems(this.term, this.definition);

  Map<String, Object> toMap() {
    return {
      "id": id,
      "termItem": term.item,
      "termLanguage": term.language,
      "definitionItem": definition.item,
      "definitionLanguage": definition.language,
      "created": created.millisecondsSinceEpoch,
      "lastChecked": lastChecked.millisecondsSinceEpoch,
      "scheduleIndex": scheduleIndex,
      "successfulAttempts": successfulAttempts,
      "failedAttempts": failedAttempts
    };
  }

  int get daysExisted {
    DateTime nowStandard = standardizeTime(DateTime.now());
    int milliDiff =
        nowStandard.millisecondsSinceEpoch - created.millisecondsSinceEpoch;
    double daysDiff = milliDiff / 1000 / 60 / 60 / 24;
    return daysDiff.floor();
  }

  int get daysUntilNextCheck {
    List<int> schedule = sp.schedule;
    if (scheduleIndex >= schedule.length) return -1;

    DateTime nextCheck = standardizeTime(
        lastChecked.add(Duration(days: schedule[scheduleIndex])));
    DateTime nowStandard = standardizeTime(DateTime.now());

    int milliDiff =
        nextCheck.millisecondsSinceEpoch - nowStandard.millisecondsSinceEpoch;
    double daysDiff = milliDiff / 1000 / 60 / 60 / 24;
    return max(daysDiff.floor(), 0);
  }

  String get ageString {
    return _formatDaysString(daysExisted);
  }

  String get nextCheckString {
    return _formatDaysString(daysUntilNextCheck);
  }

  String _formatDaysString(int days) {
    if (days >= 365) {
      int years = (days / 365).round();
      return "$years Year${years != 1 ? "s" : ""}";
    } else if (days >= 31) {
      int months = (days / 31).round();
      return "$months Month${months != 1 ? "s" : ""}";
    } else if (days >= 7) {
      int weeks = (days / 7).round();
      return "$weeks Week${weeks != 1 ? "s" : ""}";
    } else {
      return "$days Day${days != 1 ? "s" : ""}";
    }
  }

  String get memoryStatusString {
    List<int> schedule = sp.schedule;

    if (scheduleIndex >= schedule.length) return "Status: Learned!";
    if (scheduleIndex >= schedule.length / 2)
      return "Status: Long-Term Learning";
    else
      return "Status: Short-Term Learning";
  }

  String get displayString {
    // For using in search completion/other app locations, does not include id
    return "${term.item} (${term.language}): ${definition.item} (${definition.language})";
  }

  @override
  String toString() {
    // For printing/debugging, includes id that getDisplayString does not
    return "($id) ${term.item} (${term.language}) - ${definition.item} (${definition.language})";
  }

  @override
  bool operator ==(Object other) => other is Term && id == other.id;

  @override
  int get hashCode => id;
}

class TermItem {
  String item = "";
  String language = "English";

  TermItem(this.item, this.language);

  TermItem.blank();

  @override
  bool operator ==(Object other) =>
      other is TermItem && item == other.item && language == other.language;

  @override
  int get hashCode => "$item+$language".hashCode;
}

class HintOption {
  final String term;
  final String definition;

  const HintOption({required this.term, required this.definition});

  @override
  String toString() {
    return "\tHint: $term - $definition";
  }

  @override
  bool operator ==(Object other) =>
      other is HintOption &&
      term == other.term &&
      definition == other.definition;

  @override
  int get hashCode => toString().hashCode;
}

class TermWithHint {
  final Term term;
  final HintOption hint;

  const TermWithHint(this.term, this.hint);

  TermWithHint.blank()
      : term = Term.blank(),
        hint = allHints.elementAt(Random().nextInt(allHints.length));

  @override
  bool operator ==(Object other) =>
      other is TermWithHint && term.id == other.term.id;

  @override
  int get hashCode => term.id;
}

final List<HintOption> allHints = [
  const HintOption(term: "你好", definition: "Hello!"),
  const HintOption(term: "Bonjour", definition: "Hello!"),
  const HintOption(term: "Hola", definition: "Hello!"),
  const HintOption(term: "Përshëndetje", definition: "Hello!"),
  const HintOption(term: "Halló", definition: "Hello!"),
  const HintOption(term: "こんにちは", definition: "Hello!"),
  const HintOption(term: "안녕하세요", definition: "Hello!"),
  const HintOption(term: "สวัสดี", definition: "Hello!"),
  const HintOption(term: "Merhaba", definition: "Hello!"),
  const HintOption(term: "Γειά σου", definition: "Hello!"),
  const HintOption(term: "Hej", definition: "Hello!"),
  const HintOption(term: "ສະບາຍດີ", definition: "Hello!"),
];
