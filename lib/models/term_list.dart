import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/models/language_tracker.dart';
import 'package:vocab_trainer_app/models/term.dart';

class TermListModel with ChangeNotifier {
  final List<Term> terms = List.empty(growable: true);
  final LanguageTracker usageTracker = LanguageTracker();
  final DBHelper db = DBHelper();

  TermListModel() {
    db.getAllTerms().then((foundTerms) {
      debugPrint("Adding terms from DB to list:\n$foundTerms");
      addAll(foundTerms);
    });
  }

  void add(Term newTerm) {
    terms.add(newTerm);
    usageTracker.addTerm(newTerm);
    notifyListeners();
  }

  void addAll(List<Term> newTerms) {
    terms.addAll(newTerms);
    newTerms.forEach((term) => usageTracker.addTerm(term));
    notifyListeners();
  }

  void clear() {
    terms.clear();
    usageTracker.clear();
    notifyListeners();
  }

  bool remove(Term aTerm) {
    bool success = terms.remove(aTerm);
    if (success) {
      usageTracker.removeTerm(aTerm);
      notifyListeners();
    }
    return success;
  }

  Term? removeAt(int index) {
    if (index >= terms.length) return null;

    Term removed = terms.removeAt(index);
    usageTracker.removeTerm(removed);

    notifyListeners();
    return removed;
  }

  void updateTerm(Term anUpdatedTerm) {
    for (int i = 0; i < terms.length; i++) {
      if (terms[i].id == anUpdatedTerm.id) {
        Term originalTerm = terms[i];
        usageTracker.updateTerm(originalTerm, anUpdatedTerm);
        
        terms[i] = anUpdatedTerm;
        notifyListeners();
        return;
      }
    }
  }

  void resetTermWaits() {
    terms.forEach((term) => term.scheduleIndex = 0);
    notifyListeners();
  }
}
