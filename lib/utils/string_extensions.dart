extension CapitalizeFirst on String {
  String capitalizeFirst() {
    if (length == 0) return '';
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

extension OrDefault on String? {
  String orDefault(String defaultVal) {
    if (this == null || this!.isEmpty) {
      return defaultVal;
    }
    return this!;
  }
}
