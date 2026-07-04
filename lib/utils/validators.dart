import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class Validators {
  static String? required(String? value, BuildContext context, {String? fieldName}) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? l.this_field} ${l.is_required}';
    }
    return null;
  }

  static String? email(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l.email_required;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return l.invalid_email;
    }
    return null;
  }

  static String? minLength(String? value, int min, BuildContext context, {String? fieldName}) {
    final l = AppLocalizations.of(context)!;
    final name = fieldName ?? l.field;
    if (value == null || value.length < min) {
      return '$name ${l.min_length_prefix} $min ${l.min_length_suffix}';
    }
    return null;
  }

  static String? phone(String? value, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l.phone_required;
    }
    value = value.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return l.phone_english_digits_only;
    }
    if (value.length < 7 || value.length > 15) {
      return l.phone_invalid_format; // رقم بين 7 و 15 خانة
    }
    return null;
  }

  static String? match(
    String? value,
    String? otherValue,
    BuildContext context, {
    String? fieldName,
  }) {
    final l = AppLocalizations.of(context)!;
    final name = fieldName ?? l.value;
    if (value != otherValue) {
      return '$name ${l.does_not_match}';
    }
    return null;
  }

  static String? positiveInteger(String? value, BuildContext context, {String? fieldName}) {
    final l = AppLocalizations.of(context)!;
    final name = fieldName ?? l.this_field;
    if (value == null || value.trim().isEmpty) {
      return '$name ${l.is_required}';
    }
    final trimmed = value.trim();
    if (!RegExp(r'^[0-9]+$').hasMatch(trimmed)) {
      return '$name ${l.must_contain_english_digits}';
    }
    if (!RegExp(r'^[1-9]\d*$').hasMatch(trimmed)) {
      return '$name ${l.must_be_positive_integer}';
    }
    return null;
  }

  static String? url(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return 'Please enter a valid URL starting with https://';
    }
    return null;
  }

  static String? password(String? value, BuildContext context, {String? fieldName}) {
    final l = AppLocalizations.of(context)!;
    final name = fieldName ?? l.password;
    if (value == null || value.trim().isEmpty) {
      return '$name ${l.is_required}';
    }
    final strongPasswordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~%^]).{8,}$');
    if (!strongPasswordRegex.hasMatch(value.trim())) {
      return l.password_weak;
    }
    return null;
  }
}
