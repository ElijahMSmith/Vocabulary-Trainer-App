import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  factory LanguageCollection() {
    return _instance;
  }

  LanguageCollection._internal() {
    // Initialization Logic
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
