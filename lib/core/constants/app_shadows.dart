import 'package:flutter/material.dart';

class AppShadows {
  static BoxShadow neon(Color c) => BoxShadow(
    // ignore: deprecated_member_use
    color: c.withOpacity(0.30),
    blurRadius: 25,
    spreadRadius: -4,
    offset: const Offset(0, 6),
  );
}
