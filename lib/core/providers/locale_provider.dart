import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/language_constant.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  Future<void> loadLocale() async {
    final locale = await getLocale();
    state = locale;
  }

  Future<void> changeLanguage(String code) async {
    final locale = await setLocale(code);
    state = locale;
  }

  Future<void> resetToEnglish() async {
    final locale = await setLocale('en');
    state = locale;
  }
}
