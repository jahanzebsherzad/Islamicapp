import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'prayer_screen.dart';
import 'quran_screen.dart';
import 'qibla_screen.dart';
import 'tasbih_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  BannerAd? _bannerAd;
  bool _bannerReady = false;

  final _screens = const [
    PrayerScreen(),
    QuranScreen(),
    QiblaScreen(),
    TasbihScreen(),
    CalendarScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _bannerReady = true),
        onAdFailedToLoad: (ad, err) { ad.dispose(); },
      ),
    )..load();
  }

  @override
  void dispose() { _bannerAd?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF112017) : const Color(0xFF1B6B3A);

    return Scaffold(
      appBar: AppBar(
        title: Text(app.t('app_name')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _screens[_tab]),
          if (_bannerReady && _bannerAd != null)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: navBg,
        indicatorColor: const Color(0xFFD4AF37).withOpacity(0.3),
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          _navItem(Icons.access_time_rounded, app.t('prayer')),
          _navItem(Icons.menu_book_rounded, app.t('quran')),
          _navItem(Icons.explore_rounded, app.t('qibla')),
          _navItem(Icons.countertops_rounded, app.t('tasbih')),
          _navItem(Icons.calendar_month_rounded, app.t('calendar')),
        ],
      ),
    );
  }

  NavigationDestination _navItem(IconData icon, String label) =>
      NavigationDestination(
        icon: Icon(icon, color: Colors.white54),
        selectedIcon: Icon(icon, color: const Color(0xFFD4AF37)),
        label: label,
      );
}
