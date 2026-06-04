import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  int _count = 0;
  int _target = 33;
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> dhikrList = [
    {'ar': 'سُبْحَانَ اللَّهِ', 'meaning': 'Glory be to Allah', 'target': 33},
    {'ar': 'الْحَمْدُ لِلَّهِ', 'meaning': 'Praise be to Allah', 'target': 33},
    {'ar': 'اللَّهُ أَكْبَرُ', 'meaning': 'Allah is the Greatest', 'target': 34},
    {'ar': 'لَا إِلَٰهَ إِلَّا اللَّهُ', 'meaning': 'No god but Allah', 'target': 100},
    {'ar': 'أَسْتَغْفِرُ اللَّهَ', 'meaning': 'I seek forgiveness', 'target': 100},
    {'ar': 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّد', 'meaning': 'Bless Muhammad ﷺ', 'target': 100},
  ];

  TasbihProvider(this._prefs) {
    _count = _prefs.getInt('tasbih_count') ?? 0;
    _target = _prefs.getInt('tasbih_target') ?? 33;
    _selectedIndex = _prefs.getInt('tasbih_idx') ?? 0;
  }

  int get count => _count;
  int get target => _target;
  int get selectedIndex => _selectedIndex;
  Map<String, dynamic> get current => dhikrList[_selectedIndex];
  double get progress => _target > 0 ? (_count % _target) / _target : 0;

  void tap() {
    HapticFeedback.lightImpact();
    _count++;
    if (_count % _target == 0) HapticFeedback.heavyImpact();
    _prefs.setInt('tasbih_count', _count);
    notifyListeners();
  }

  void reset() {
    _count = 0;
    _prefs.setInt('tasbih_count', 0);
    notifyListeners();
  }

  void selectDhikr(int idx) {
    _selectedIndex = idx;
    _target = dhikrList[idx]['target'];
    _count = 0;
    _prefs.setInt('tasbih_idx', idx);
    _prefs.setInt('tasbih_target', _target);
    _prefs.setInt('tasbih_count', 0);
    notifyListeners();
  }
}
