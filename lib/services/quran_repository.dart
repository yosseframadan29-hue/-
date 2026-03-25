import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran_app_mvp/models/surah.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranRepository {
  static const _lastSurahKey = 'last_surah_number';
  static const _lastAyahKey = 'last_ayah_number';

  Future<List<Surah>> loadSurahs() async {
    final raw = await rootBundle.loadString('assets/quran_sample.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['surahs'] as List<dynamic>;

    return list
        .map((e) => Surah.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveLastRead({required int surahNumber, required int ayahNumber}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSurahKey, surahNumber);
    await prefs.setInt(_lastAyahKey, ayahNumber);
  }

  Future<(int surahNumber, int ayahNumber)?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final surah = prefs.getInt(_lastSurahKey);
    final ayah = prefs.getInt(_lastAyahKey);

    if (surah == null || ayah == null) return null;
    return (surah, ayah);
  }
}
