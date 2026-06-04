import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  Locale _locale = const Locale('ps');
  ThemeMode _themeMode = ThemeMode.dark;
  double _latitude = 34.5553;
  double _longitude = 69.2075;
  String _city = 'کابل';

  AppProvider(this._prefs) { _load(); }

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get city => _city;
  String get langCode => _locale.languageCode;

  void _load() {
    _locale = Locale(_prefs.getString('lang') ?? 'ps');
    _themeMode = (_prefs.getBool('dark') ?? true) ? ThemeMode.dark : ThemeMode.light;
    _latitude = _prefs.getDouble('lat') ?? 34.5553;
    _longitude = _prefs.getDouble('lng') ?? 69.2075;
    _city = _prefs.getString('city') ?? 'کابل';
    notifyListeners();
  }

  void setLang(String code) {
    _locale = Locale(code);
    _prefs.setString('lang', code);
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _prefs.setBool('dark', _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  void setLocation(double lat, double lng, String city) {
    _latitude = lat; _longitude = lng; _city = city;
    _prefs.setDouble('lat', lat);
    _prefs.setDouble('lng', lng);
    _prefs.setString('city', city);
    notifyListeners();
  }

  String t(String key) {
    const tr = {
      'ps': {
        'app_name': 'نور اسلام','quran': 'قرآن کریم',
        'prayer': 'د لمانځه وختونه','qibla': 'د قبلې لوری',
        'tasbih': 'تسبیح','calendar': 'اسلامي کلنډر',
        'settings': 'ترتیبات','fajr': 'فجر','sunrise': 'لمر ختل',
        'dhuhr': 'غرمه','asr': 'عصر','maghrib': 'مغرب','isha': 'عشاء',
        'next': 'راتلونکی لمانځه','reset': 'بیا پیل','dark': 'تیاره','light': 'روښانه',
      },
      'ar': {
        'app_name': 'نور الإسلام','quran': 'القرآن الكريم',
        'prayer': 'أوقات الصلاة','qibla': 'اتجاه القبلة',
        'tasbih': 'التسبيح','calendar': 'التقويم الهجري',
        'settings': 'الإعدادات','fajr': 'الفجر','sunrise': 'الشروق',
        'dhuhr': 'الظهر','asr': 'العصر','maghrib': 'المغرب','isha': 'العشاء',
        'next': 'الصلاة القادمة','reset': 'إعادة','dark': 'داكن','light': 'فاتح',
      },
      'en': {
        'app_name': 'Noor Islam','quran': 'Holy Quran',
        'prayer': 'Prayer Times','qibla': 'Qibla',
        'tasbih': 'Tasbih','calendar': 'Islamic Calendar',
        'settings': 'Settings','fajr': 'Fajr','sunrise': 'Sunrise',
        'dhuhr': 'Dhuhr','asr': 'Asr','maghrib': 'Maghrib','isha': 'Isha',
        'next': 'Next Prayer','reset': 'Reset','dark': 'Dark','light': 'Light',
      },
      'ur': {
        'app_name': 'نور اسلام','quran': 'قرآن کریم',
        'prayer': 'نماز کے اوقات','qibla': 'قبلہ',
        'tasbih': 'تسبیح','calendar': 'اسلامی کیلنڈر',
        'settings': 'ترتیبات','fajr': 'فجر','sunrise': 'طلوع',
        'dhuhr': 'ظہر','asr': 'عصر','maghrib': 'مغرب','isha': 'عشاء',
        'next': 'اگلی نماز','reset': 'دوبارہ','dark': 'تاریک','light': 'روشن',
      },
      'fa': {
        'app_name': 'نور اسلام','quran': 'قرآن کریم',
        'prayer': 'اوقات نماز','qibla': 'قبله',
        'tasbih': 'تسبیح','calendar': 'تقویم اسلامی',
        'settings': 'تنظیمات','fajr': 'فجر','sunrise': 'طلوع',
        'dhuhr': 'ظهر','asr': 'عصر','maghrib': 'مغرب','isha': 'عشاء',
        'next': 'نماز بعدی','reset': 'بازنشانی','dark': 'تاریک','light': 'روشن',
      },
    };
    return tr[langCode]?[key] ?? tr['en']?[key] ?? key;
  }
}
