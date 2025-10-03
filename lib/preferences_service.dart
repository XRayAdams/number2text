// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keySelectedLanguage = 'selected_language';

  Future<void> saveLanguage(String languageName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelectedLanguage, languageName);
  }

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedLanguage);
  }
}
