import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vocab_trainer_app/misc/db_helper.dart';
import 'package:vocab_trainer_app/models/term.dart';

class TermListModel with ChangeNotifier {
  final List<Term> terms = List.empty(growable: true);
  final DBHelper db = DBHelper();
  final MAX_RETRIES = 3;
  final RETRY_BACKOFF_MS = 1000;

  TermListModel() {
    attemptFetchFromDB(MAX_RETRIES);
  }

  void attemptFetchFromDB(int retries) {
    if (retries == 0) return;

    if (db.isReady) {
      db.getAllTerms().then((foundTerms) => addAll(foundTerms));
    } else {
      Timer(
        Duration(milliseconds: RETRY_BACKOFF_MS),
        () => attemptFetchFromDB(retries - 1),
      );
    }
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
