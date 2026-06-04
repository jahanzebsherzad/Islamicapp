
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'providers/app_provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/tasbih_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  runApp(NoorIslamApp(prefs: prefs));
}

class NoorIslamApp extends StatelessWidget {
  final SharedPreferences prefs;
  const NoorIslamApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider(prefs)),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => TasbihProvider(prefs)),
      ],
      child: Consumer<AppProvider>(
        builder: (ctx, app, _) => MaterialApp(
          title: 'نور اسلام',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Amiri',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1B6B3A),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Amiri',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1B6B3A),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF0A1F0F),
          ),
          themeMode: app.themeMode,
          locale: app.locale,
          supportedLocales: const [
            Locale('ps'), Locale('ar'), Locale('ur'),
            Locale('en'), Locale('fa'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
```
