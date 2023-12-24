import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/models/term.dart';

// TODO: Use this when constructing the widget in language selector
class LanguageTracker {
  final Map<String, int> _usages = {};

  void addTerm(Term term) {
    addLanguage(term.term.language);
    addLanguage(term.definition.language);
  }

  void addLanguage(String lang) {
    if (_usages.containsKey(lang))
      _usages[lang] = _usages[lang]! + 1;
    else
      _usages[lang] = 1;
  }

  void removeTerm(Term term) {
    removeLanguage(term.term.language);
    removeLanguage(term.definition.language);
  }

  void removeLanguage(String lang) {
    int oldCount = getUsages(lang);
    if (oldCount > 0) _usages[lang] = oldCount - 1;
  }

  void updateTerm(Term oldTerm, Term newTerm) {
    removeTerm(oldTerm);
    addTerm(newTerm);
  }

  void clear() {
    _usages.clear();
  }

  // TODO: Write some tests (especially things like this)
  List<String> getNMostRecent(int n) {
    List<String> keyset = _usages.keys.toList();

    keyset.forEach((key) {
      debugPrint("$key: ${_usages[key]} usages");
    });

    keyset.removeWhere((lang) => _usages[lang] == 0);
    keyset.sort((lang1, lang2) {
      if (_usages[lang1]! != _usages[lang2])
        // Invert here so more usages is earlier
        return _usages[lang2]!.compareTo(_usages[lang1]!);
      else
        // Otherwise, sort by normal keys
        return lang1.compareTo(lang2);
    });

    return keyset.sublist(0, min(n, keyset.length));
  }

  int getUsages(String language) {
    return _usages[language] ?? 0;
  }
}
