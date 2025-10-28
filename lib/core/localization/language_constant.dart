import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LAGUAGE_CODE = 'languageCode';

const String ENGLISH = 'en';
const String BANGLA = 'bn';

Future<Locale> setLocale(String languageCode) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  await prefs.setString('$LAGUAGE_CODE-$userId', languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  String? code = prefs.getString('$LAGUAGE_CODE-$userId');
  return _locale(code ?? ENGLISH);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case BANGLA:
      return const Locale(BANGLA, '');
    case ENGLISH:
    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations translation(BuildContext context) =>
    AppLocalizations.of(context)!;
