class Term {
  static int ID_COUNTER = 0;

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
}

class TermItem {
  String item = "";
  String language = "";

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
