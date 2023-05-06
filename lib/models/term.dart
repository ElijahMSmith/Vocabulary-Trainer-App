import 'dart:math';

import 'package:flutter/material.dart';

class Term {
  static int ID_COUNTER = 0; /* TODO: Go to a better system */

  late int id;

  TermItem term;
  TermItem definition;

  final DateTime created;
  late DateTime lastChecked;

  int scheduleIndex = 0;
  int failedAttempts = 0;
  int successfulAttempts = 0;

  Term.fromExisting(
      this.term, this.definition, this.created, this.lastChecked, this.id);

  Term.blank()
      : created = DateTime.now(),
        term = TermItem.blank(),
        definition = TermItem.blank() {
    id = _getNextAvailableID();
    lastChecked = created;
  }

  Term clone() {
    return Term.fromExisting(term, definition, created, lastChecked, id);
  }

  int _getNextAvailableID() {
    // TODO: Save and get from database
    return ID_COUNTER++;
  }

  String getAgeString() {
    // TODO: Start from years and check difference, then go to smaller unit as needed
    return "TODO";
  }

  String getNextCheckString() {
    // TODO: Similarly, start from years and check difference
    return "TODO";
  }

  @override
  String toString() {
    return "($id) ${term.item} (${term.language}) - ${definition.item} (${definition.language})";
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
