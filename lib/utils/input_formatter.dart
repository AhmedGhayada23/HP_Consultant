import 'package:flutter/services.dart';

class InputFormatter {
  final secureTextFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9\u0600-\u06FF\s.,!?()\-_@#$%:/]"),
  );
}
