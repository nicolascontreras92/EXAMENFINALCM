import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.grey),
    );
  }
}
