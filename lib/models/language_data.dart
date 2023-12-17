import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
TODOs

- Still not super happy with the design on this widget. Something isn't quite right.
- Find a better solution for the ordering so you don't have to scroll nearly as far.
- Get a new list because this one sucks
- Make a search feature? Maybe not yet but later?
- Update selector to include most common languages at the top or offer to enter new

*/

class LanguageData {
  final String name;
  final String nativeName;
  final String code;

  const LanguageData(this.name, this.nativeName, this.code);

  @override
  String toString() {
    return "($code) $name - $nativeName";
  }
}

class LanguageCollection {
  static final LanguageCollection _instance = LanguageCollection._internal();
  final List<LanguageData> _allData = [];

  // Loaded with other resources in the main widget before the app is usable
  factory LanguageCollection() {
    return _instance;
  }

  LanguageCollection._internal() {
    rootBundle.loadString('assets/loads/languages.json').then((response) {
      Map<String, dynamic> data = json.decode(response) as Map<String, dynamic>;
      data.forEach((key, value) {
        var newLang = LanguageData(
            value["name"] as String, value["nativeName"] as String, key);
        _allData.add(newLang);
      });
      debugPrint("Loaded ${_allData.length} languages");
    });
  }

  List<LanguageData> get list {
    return _allData;
  }
}
