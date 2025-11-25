extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 8;
  }

  bool get isNotBlank {
    return trim().isNotEmpty;
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  String get removeHtmlTags {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  String? get nullIfEmpty {
    return isEmpty ? null : this;
  }

  int? toIntOrNull() {
    return int.tryParse(this);
  }

  double? toDoubleOrNull() {
    return double.tryParse(this);
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  bool get isNotNullOrEmpty {
    return this != null && this!.isNotEmpty;
  }

  String orEmpty() {
    return this ?? '';
  }
}
