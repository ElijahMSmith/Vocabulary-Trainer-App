import 'dart:convert';

import 'package:flutter/services.dart';

/*
TODOs
- Still not super happy with the design on this widget. Something isn't quite right.
- Find a better solution for the ordering so you don't have to scroll nearly as far.
- Get a new list because this one sucks
- Make a search feature? Maybe not yet but later?
- Update selector to include most common languages at the top or offer to enter new
*/

class Language {
  final String name;
  final String nativeName;
  final String code;

  const Language(this.name, this.nativeName, this.code);

  @override
  String toString() {
    return "($code) $name - $nativeName";
  }
}

class LanguageCollection {
  static final LanguageCollection _instance = LanguageCollection._internal();
  List<Language> data = [];

  // Loaded with other resources in the main widget before the app is usable
  factory LanguageCollection() {
    return _instance;
  }

  LanguageCollection._internal();

  Future<void> initialize() async {
    String languageJSON =
        await rootBundle.loadString('assets/loads/languages.json');
    Map<String, dynamic> languageData =
        json.decode(languageJSON) as Map<String, dynamic>;
    data = languageData.entries.map((entry) {
      return Language(entry.value["name"] as String,
          entry.value["nativeName"] as String, entry.key);
    }).toList();
  }

  int indexOfName(String name) {
    for (int i = 0; i < data.length; i++) {
      if (data[i].name == name) return i;
    }
    return -1;
  }
}
