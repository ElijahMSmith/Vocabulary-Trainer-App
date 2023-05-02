import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class Term {
  TermItem term;
  TermItem definition;
  final DateTime created;
  int scheduleIndex = 0;
  int failedAttempts = 0;
  int successfulAttempts = 0;

  Term(this.term, this.definition) : created = DateTime.now();

  String getAgeString() {
    return "TODO";
    // Start from years and check difference, then go to smaller unit as needed
  }
}

class TermItem {
  String item;
  String language;

  TermItem(this.item, this.language);

  bool updateItem(String newItem) {
    if (newItem.isNotEmpty) {
      item = newItem;
      return true;
    }
    return false;
  }

  bool updateLanguage(String newLanguage) {
    if (newLanguage.isNotEmpty) {
      language = newLanguage;
      return true;
    }
    return false;
  }
}