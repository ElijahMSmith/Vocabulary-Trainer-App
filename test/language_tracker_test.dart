import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_trainer_app/models/language_tracker.dart';
import 'package:vocab_trainer_app/models/term.dart';

void main() {
  test("Add a single term", () {
    LanguageTracker tracker = LanguageTracker();

    tracker.addTerm(Term.fromTermItems(
      TermItem("hola", "Spanish"),
      TermItem("hello", "English"),
    ));

    expect(tracker.getUsages("Spanish"), 1);
    expect(tracker.getUsages("English"), 1);
  });

  test("Add term with language already in the list", () {
    LanguageTracker tracker = LanguageTracker();

    tracker.addTerm(Term.fromTermItems(
      TermItem("hola", "Spanish"),
      TermItem("hello", "English"),
    ));
    tracker.addTerm(Term.fromTermItems(
      TermItem("bonjour", "French"),
      TermItem("hello", "English"),
    ));

    expect(tracker.getUsages("Spanish"), 1);
    expect(tracker.getUsages("English"), 2);
    expect(tracker.getUsages("French"), 1);
  });

  test("Remove term", () {
    LanguageTracker tracker = LanguageTracker();
    Term theTerm = Term.fromTermItems(
      TermItem("hola", "Spanish"),
      TermItem("hello", "English"),
    );

    tracker.addTerm(theTerm);
    expect(tracker.getUsages("Spanish"), 1);
    expect(tracker.getUsages("English"), 1);

    tracker.removeTerm(theTerm);
    expect(tracker.getUsages("Spanish"), 0);
    expect(tracker.getUsages("English"), 0);
  });

  test("Can't remove usages below zero", () {
    LanguageTracker tracker = LanguageTracker();

    Term theTerm = Term.fromTermItems(
      TermItem("hola", "Spanish"),
      TermItem("hello", "English"),
    );
    tracker.removeTerm(theTerm);

    expect(tracker.getUsages("Spanish"), 0);
    expect(tracker.getUsages("English"), 0);
  });

  test("Update term", () {
    LanguageTracker tracker = LanguageTracker();

    Term oldTerm = Term.fromTermItems(
      TermItem("hola", "Spanish"),
      TermItem("hello", "English"),
    );
    tracker.addTerm(oldTerm);
    expect(tracker.getUsages("Spanish"), 1);
    expect(tracker.getUsages("English"), 1);
    expect(tracker.getUsages("French"), 0);
    expect(tracker.getUsages("German"), 0);

    Term newTerm = Term.fromTermItems(
      TermItem("bonjour", "French"),
      TermItem("hallo", "German"),
    );
    tracker.updateTerm(oldTerm, newTerm);
    expect(tracker.getUsages("Spanish"), 0);
    expect(tracker.getUsages("English"), 0);
    expect(tracker.getUsages("French"), 1);
    expect(tracker.getUsages("German"), 1);
  });

  test("getNMostRecent returns less than N if not N unique languages", () {
    LanguageTracker tracker = LanguageTracker();

    tracker.addLanguage("English");
    tracker.addLanguage("Spanish");
    tracker.addLanguage("Spanish");
    tracker.addLanguage("French");
    tracker.addLanguage("French");
    tracker.addLanguage("French");

    List<String> mostRecent = tracker.getNMostRecent(5);
    expect(mostRecent.length, 3);
    expect(mostRecent[0], "French");
    expect(mostRecent[1], "Spanish");
    expect(mostRecent[2], "English");
  });

  test("getNMostRecent returns N if more than N unique languages", () {
    LanguageTracker tracker = LanguageTracker();

    tracker.addLanguage("English");
    tracker.addLanguage("English");
    tracker.addLanguage("Spanish");
    tracker.addLanguage("Spanish");
    tracker.addLanguage("French");
    tracker.addLanguage("French");
    tracker.addLanguage("German");
    tracker.addLanguage("Chinese (Simplified)");
    tracker.addLanguage("Japanese");

    List<String> mostRecent = tracker.getNMostRecent(3);
    expect(mostRecent.length, 3);
    expect(mostRecent[0], "English");
    expect(mostRecent[1], "French");
    expect(mostRecent[2], "Spanish");
  });

  test("getNMostRecent breaks ties alphabetically", () {
    LanguageTracker tracker = LanguageTracker();

    tracker.addLanguage("English");
    tracker.addLanguage("Spanish");
    tracker.addLanguage("Chinese (Simplified)");
    tracker.addLanguage("Japanese");
    tracker.addLanguage("Korean");
    tracker.addLanguage("Chinese (Traditional)");
    tracker.addLanguage("Hebrew");
    tracker.addLanguage("French");
    tracker.addLanguage("Greek");
    tracker.addLanguage("German");

    List<String> mostRecent = tracker.getNMostRecent(5);
    expect(mostRecent.length, 5);
    expect(mostRecent[0], "Chinese (Simplified)");
    expect(mostRecent[1], "Chinese (Traditional)");
    expect(mostRecent[2], "English");
    expect(mostRecent[3], "French");
    expect(mostRecent[4], "German");
  });
}
