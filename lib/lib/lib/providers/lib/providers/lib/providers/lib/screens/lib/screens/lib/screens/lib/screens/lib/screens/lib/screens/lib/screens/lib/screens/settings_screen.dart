import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final prayer = context.read<PrayerProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(app.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('🌐 ژبه'),
          Wrap(
            spacing: 8,
            children: [
              _langChip(context, app, 'ps', 'پښتو'),
              _langChip(context, app, 'ar', 'عربي'),
              _langChip(context, app, 'ur', 'اردو'),
              _langChip(context, app, 'en', 'English'),
              _langChip(context, app, 'fa', 'فارسي'),
            ],
          ),
          const SizedBox(height: 24),
          _section('🎨 تھیم'),
          SwitchListTile(
            value: app.themeMode == ThemeMode.dark,
            onChanged: (_) => app.toggleTheme(),
            title: Text(
              app.themeMode == ThemeMode.dark ? app.t('dark') : app.t('light'),
              style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
            ),
            activeColor: const Color(0xFF2D9E5F),
            secondary: Icon(
              app.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _section('📍 ښار'),
          Wrap(
            spacing: 8,
            children: [
              _cityChip(context, app, prayer, 'کابل', 34.5553, 69.2075),
              _cityChip(context, app, prayer, 'کندهار', 31.6289, 65.7372),
              _cityChip(context, app, prayer, 'هرات', 34.3482, 62.2000),
              _cityChip(context, app, prayer, 'مزار', 36.7069, 67.1110),
              _cityChip(context, app, prayer, 'کراچي', 24.8607, 67.0011),
              _cityChip(context, app, prayer, 'لاهور', 31.5497, 74.3436),
              _cityChip(context, app, prayer, 'ریاض', 24.7136, 46.6753),
              _cityChip(context, app, prayer, 'لندن', 51.5074, -0.1278),
              _cityChip(context, app, prayer, 'دوبۍ', 25.2048, 55.2708),
            ],
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.my_location, color: Color(0xFF2D9E5F)),
            title: const Text('اوسنی موقعیت',
                style: TextStyle(fontFamily: 'Amiri', fontSize: 18)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B6B3A)),
              onPressed: () async {
                await prayer.detectLocation((lat, lng) {
                  app.setLocation(lat, lng, 'اوسنی ځای');
                  prayer.load(lat, lng);
                });
              },
              child: const Text('GPS', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF8B6914).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💰 AdMob',
                    style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('home_screen.dart کې خپل AdMob ID واچوئ',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(
      fontFamily: 'Amiri', fontSize: 18, color: Color(0xFFD4AF37),
    )),
  );

  Widget _langChip(BuildContext ctx, AppProvider app, String code, String label) {
    final selected = app.langCode == code;
    return FilterChip(
      label: Text(label, style: TextStyle(
        fontFamily: 'Amiri', color: selected ? Colors.white : null,
      )),
      selected: selected,
      onSelected: (_) => app.setLang(code),
      selectedColor: const Color(0xFF1B6B3A),
      checkmarkColor: const Color(0xFFD4AF37),
    );
  }

  Widget _cityChip(BuildContext ctx, AppProvider app, PrayerProvider prayer,
      String city, double lat, double lng) {
    final selected = app.city == city;
    return ActionChip(
      label: Text(city, style: TextStyle(
        fontFamily: 'Amiri',
        color: selected ? const Color(0xFFD4AF37) : null,
      )),
      backgroundColor: selected ? const Color(0xFF1B6B3A) : null,
      onPressed: () {
        app.setLocation(lat, lng, city);
        prayer.load(lat, lng);
      },
    );
  }
}
