import 'package:flutter/material.dart';
import 'theme_extension.dart';

class AppTheme {
  /// iOS-like frosted glass (Light)
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    extensions: const [
      GlassTheme(
        blur: 28,
        saturation: 1.8,
        color: Color(0x66FFFFFF),
        border: Color(0x33FFFFFF),
        borderWidth: 0.6,
      ),
    ],
  );

  /// iOS-like frosted glass (Dark)
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    extensions: const [
      GlassTheme(
        blur: 30,
        saturation: 1.6,
        color: Color(0x661C1C1E),
        border: Color(0x33FFFFFF),
        borderWidth: 0.6,
      ),
    ],
  );
}
