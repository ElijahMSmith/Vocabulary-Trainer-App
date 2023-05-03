class Term {
  static int ID_COUNTER = 0; /* TODO: Go to a better system */

  late int id;

  TermItem term;
  TermItem definition;

  final DateTime created;
  late DateTime lastChecked;

  int scheduleIndex = 0;
  int failedAttempts = 0;
  int successfulAttempts = 0;

  Term.fromExisting(
      this.term, this.definition, this.created, this.lastChecked, this.id);

  Term.blank()
      : created = DateTime.now(),
        term = TermItem.blank(),
        definition = TermItem.blank() {
    id = _getNextAvailableID();
    lastChecked = created;
  }

  int _getNextAvailableID() {
    /* TODO: Get from database query */
    return ID_COUNTER++;
  }

  String getAgeString() {
    // Start from years and check difference, then go to smaller unit as needed
    return "TODO";
  }

  String getNextCheckString() {
    // Similarly, start from years and check difference
    return "TODO";
  }

  @override
  String toString() {
    return "${term.item} (${term.language}) - ${definition.item} (${definition.language})";
  }
}

class TermItem {
  String item = "";
  String language = "English";

  TermItem(this.item, this.language);

  TermItem.blank();

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

class HintOption {
  final String term;
  final String definition;

  const HintOption({required this.term, required this.definition});
}

final List<HintOption> allHints = [
  const HintOption(term: "你好", definition: "Hello!"),
  const HintOption(term: "Bonjour", definition: "Hello!"),
  const HintOption(term: "Hola", definition: "Hello!"),
  const HintOption(term: "Përshëndetje", definition: "Hello!"),
  const HintOption(term: "Halló", definition: "Hello!"),
  const HintOption(term: "こんにちは", definition: "Hello!"),
  const HintOption(term: "안녕하세요", definition: "Hello!"),
  const HintOption(term: "สวัสดี", definition: "Hello!"),
  const HintOption(term: "Merhaba", definition: "Hello!"),
  const HintOption(term: "Γειά σου", definition: "Hello!"),
  const HintOption(term: "Hej", definition: "Hello!"),
  const HintOption(term: "ສະບາຍດີ", definition: "Hello!"),
];
