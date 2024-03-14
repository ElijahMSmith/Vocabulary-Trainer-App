DateTime standardizeTime(DateTime orig) {
  return orig
      .toLocal()
      .copyWith(hour: 12, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}

List<String> intListToStringList(List<int> list) {
  return list.map((e) => e.toString()).toList();
}

List<int> stringListToIntList(List<String> list) {
  return list.map((e) => int.parse(e)).toList();
}

String makePluralIfNeeded(String theThing, int theCount) {
  return theThing + (theCount > 1 ? "s" : "");
}
