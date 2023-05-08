DateTime standardizeTime(DateTime orig) {
  return orig.toLocal().copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);
}
