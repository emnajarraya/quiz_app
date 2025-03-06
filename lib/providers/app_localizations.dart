import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    String langCode = locale.languageCode;
    String content = await rootBundle.loadString('assets/l10n/arb/app_$langCode.arb'); 
    Map<String, dynamic> translations = json.decode(content);
    _localizedStrings = translations.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) => _localizedStrings[key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}