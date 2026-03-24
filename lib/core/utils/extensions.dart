import 'package:flutter/material.dart';

// ── BuildContext extensions ────────────────────────────────────
extension ContextExt on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Responsive percentages
  double sw(double pct) => screenWidth * pct;
  double sh(double pct) => screenHeight * pct;

  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Navigation
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
}

// ── String extensions ─────────────────────────────────────────
extension StringExt on String {
  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPhone => RegExp(r'^\+?[0-9]{10,15}$').hasMatch(this);

  bool get isValidPassword => length >= 8;

  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');

  String truncate(int maxLen, {String suffix = '...'}) =>
      length > maxLen ? '${substring(0, maxLen)}$suffix' : this;
}

// ── Int extensions ─────────────────────────────────────────────
extension IntExt on int {
  String get asCoins => '$this coins';
  String get asXp => '+$this XP';
  String get asPct => '$this%';

  /// Format large numbers: 1240 → '1.2k'
  String get compact {
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}k';
    return toString();
  }
}

// ── Double extensions ─────────────────────────────────────────
extension DoubleExt on double {
  String get asPct => '${(this * 100).toInt()}%';
}

// ── DateTime extensions ────────────────────────────────────────
extension DateTimeExt on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '$day/$month/$year';
  }
}
