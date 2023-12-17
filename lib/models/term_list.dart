import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/models/term.dart';

class TermListModel with ChangeNotifier {
  final List<Term> terms = List.empty(growable: true);
  final DBHelper db = DBHelper();

  TermListModel() {
    db.getAllTerms().then((foundTerms) {
      debugPrint("Adding terms from DB to list:\n$foundTerms");
      addAll(foundTerms);
    });
  }

  void add(Term newTerm) {
    terms.add(newTerm);
    notifyListeners();
  }

  void addAll(List<Term> newTerms) {
    terms.addAll(newTerms);
    notifyListeners();
  }

  void clear() {
    terms.clear();
    notifyListeners();
  }

  bool remove(Term aTerm) {
    bool success = terms.remove(aTerm);
    if (success) notifyListeners();
    return success;
  }

  Term? removeAt(int index) {
    if (index >= terms.length) return null;

    Term removed = terms.removeAt(index);
    notifyListeners();
    return removed;
  }

  void updateTerm(Term anUpdatedTerm) {
    for (int i = 0; i < terms.length; i++) {
      if (terms[i].id == anUpdatedTerm.id) {
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
