import 'dart:ui';

import 'package:flutter/material.dart';

class HiveBoxes {
  static const messages = "messages_box";
}
Color getColorForEmail(String email) {
  final hash = email.codeUnits.fold(0, (prev, e) => prev + e);
  final colors = [
    Colors.red,
    Colors.redAccent,
    Colors.orange,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.blue,
    Colors.pink,
  ];
  return colors[hash % colors.length];
}