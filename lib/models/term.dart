import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

import '../misc/util.dart';

class Term {
  static const List<int> dayWaits = [1, 2, 3, 7, 14, 30];

  int? id;

  late final TermItem term;
  late final TermItem definition;

  late final DateTime created;
  late final DateTime lastChecked;

  int scheduleIndex = 3;
  int failedAttempts = 0;
  int successfulAttempts = 0;

  // TODO: Check this logic and daysUtilNextCheck logic
  int get daysExisted {
    DateTime nowStandard = standardizeTime(DateTime.now());
    int milliDiff =
        nowStandard.millisecondsSinceEpoch - created.millisecondsSinceEpoch;
    double daysDiff = milliDiff / 1000 / 60 / 60 / 24;
    return daysDiff.floor();
  }

  // TODO: Provide some dummy value for if we are past the end of the schedule
  int get daysUntilNextCheck {
    if (scheduleIndex >= dayWaits.length) return -1;

    DateTime nextCheck = standardizeTime(
        lastChecked.add(Duration(days: dayWaits[scheduleIndex])));

    int milliDiff = nextCheck.millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;
    double daysDiff = milliDiff / 1000 / 60 / 60 / 24;
    return daysDiff.floor() + 1;
  }

  Term.fromExisting(this.term, this.definition, DateTime created,
      DateTime lastChecked, this.id)
      : created = standardizeTime(created),
        lastChecked = standardizeTime(lastChecked);

  Term.blank()
      : created = standardizeTime(DateTime.now()),
        lastChecked = standardizeTime(DateTime.now()),
        term = TermItem.blank(),
        definition = TermItem.blank();

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

  Map<String, Object> toMap() {
    return {
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

  String getAgeString() {
    int days = daysExisted;
    if (days >= 365)
      return "${days / 365} Years";
    else if (days >= 31)
      return "${days / 31} Months";
    else if (days >= 7)
      return "${days / 7} Weeks";
    else
      return "$days Days";
  }

  String getNextCheckString() {
    int days = daysUntilNextCheck;
    if (days >= 365)
      return "${days / 365} Years";
    else if (days >= 31)
      return "${days / 31} Months";
    else if (days >= 7)
      return "${days / 7} Weeks";
    else
      return "$days Days";
  }

  String getMemoryStatusString() {
    if (scheduleIndex >= dayWaits.length) return "Status: Learned!";
    if (scheduleIndex >= dayWaits.length / 2)
      return "Status: Long-Term Learning";
    else
      return "Status: Short-Term Learning";
  }

  @override
  String toString() {
    return "($id) ${term.item} (${term.language}) - ${definition.item} (${definition.language})";
  }

  String getDisplayString() {
    return "${term.item} (${term.language}): ${definition.item} (${definition.language})";
  }

  // TODO: Define save and delete methods, static get method that
  // returns a Term object for database access
}

class TermItem {
  String item = "";
  String language = "English";

  TermItem(this.item, this.language);

  TermItem.blank();
}

class HintOption {
  final String term;
  final String definition;

  const HintOption({required this.term, required this.definition});

  @override
  String toString() {
    return "\tHint: $term - $definition";
  }
}

class TermWithHint {
  final Term term;
  final HintOption hint;

  const TermWithHint(this.term, this.hint);
  TermWithHint.blank()
      : term = Term.blank(),
        hint = allHints.elementAt(Random().nextInt(allHints.length));
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
