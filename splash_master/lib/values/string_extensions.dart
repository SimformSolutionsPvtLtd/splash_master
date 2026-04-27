extension StringExtension on String {
  /// Replaces the last occurrence of [from] with [to] in the string.
  String replaceLastOccurrence(String from, String to) {
    final lastIndex = lastIndexOf(from);
    if (lastIndex == -1) return this;
    return substring(0, lastIndex) + to + substring(lastIndex + from.length);
  }
}

extension StringNullableExtension on String? {
  /// Checks if the string is not null and not blank (not empty and not just whitespace).
  bool get isNotNullOrBlank {
    if (this == null || this!.trim().isEmpty) {
      return false;
    }
    return true;
  }
}
