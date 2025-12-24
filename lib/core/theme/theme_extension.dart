import 'dart:ui';
import 'package:flutter/material.dart';

class GlassTheme extends ThemeExtension<GlassTheme> {
  final double blur;
  final Color color;
  final Color border;
  final double borderWidth;
  final double saturation;

  const GlassTheme({
    required this.blur,
    required this.color,
    required this.border,
    required this.borderWidth,
    required this.saturation,
  });

  @override
  GlassTheme copyWith({
    double? blur,
    Color? color,
    Color? border,
    double? borderWidth,
    double? saturation,
  }) {
    return GlassTheme(
      blur: blur ?? this.blur,
      color: color ?? this.color,
      border: border ?? this.border,
      borderWidth: borderWidth ?? this.borderWidth,
      saturation: saturation ?? this.saturation,
    );
  }

  @override
  GlassTheme lerp(ThemeExtension<GlassTheme>? other, double t) {
    if (other is! GlassTheme) return this;
    return GlassTheme(
      blur: lerpDouble(blur, other.blur, t)!,
      color: Color.lerp(color, other.color, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      saturation: lerpDouble(saturation, other.saturation, t)!,
    );
  }
}
