import 'package:flutter/material.dart';

enum PlayerColor {
  red,
  green,
  yellow,
  blue;

  String get displayName {
    switch (this) {
      case PlayerColor.red:
        return 'Red';
      case PlayerColor.green:
        return 'Green';
      case PlayerColor.yellow:
        return 'Yellow';
      case PlayerColor.blue:
        return 'Blue';
    }
  }

  Color get color {
    switch (this) {
      case PlayerColor.red:
        return const Color(0xFFEF4444);
      case PlayerColor.green:
        return const Color(0xFF10B981);
      case PlayerColor.yellow:
        return const Color(0xFFF59E0B);
      case PlayerColor.blue:
        return const Color(0xFF3B82F6);
    }
  }

  Color get darkColor {
    switch (this) {
      case PlayerColor.red:
        return const Color(0xFFB91C1C);
      case PlayerColor.green:
        return const Color(0xFF047857);
      case PlayerColor.yellow:
        return const Color(0xFFD97706);
      case PlayerColor.blue:
        return const Color(0xFF1D4ED8);
    }
  }

  Color get lightColor {
    switch (this) {
      case PlayerColor.red:
        return const Color(0xFFFEE2E2);
      case PlayerColor.green:
        return const Color(0xFFD1FAE5);
      case PlayerColor.yellow:
        return const Color(0xFFFEF3C7);
      case PlayerColor.blue:
        return const Color(0xFFDBEAFE);
    }
  }
}
