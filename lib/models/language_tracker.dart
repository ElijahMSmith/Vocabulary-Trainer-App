import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/models/term.dart';

// TODO: Use this when constructing the widget in language selector
class LanguageTracker {
  Map<String, int> usages = {};

  void addTerm(Term term) {
    addLanguage(term.term.language);
    addLanguage(term.definition.language);
  }

  void addLanguage(String lang) {
    if (usages.containsKey(lang))
      usages[lang] = usages[lang]! + 1;
    else
      usages[lang] = 1;
  }

  void removeTerm(Term term) {
    removeLanguage(term.term.language);
    removeLanguage(term.definition.language);
  }

  void removeLanguage(String lang) {
    if (usages.containsKey(lang)) {
      int newUsages = usages[lang]! - 1;
      if (newUsages < 0) {
        debugPrint(
            "Language ${lang} is listed as ${newUsages} usages, which is a bug");
      }
    }
  }

  void updateTerm(Term oldTerm, Term newTerm) {
    removeTerm(oldTerm);
    addTerm(newTerm);
  }

  void clear() {
    usages.clear();
  }
}
