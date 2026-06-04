import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ac, curve: const Interval(0, 0.6)));
    _scale = Tween<double>(begin: 0.7, end: 1).animate(
        CurvedAnimation(parent: _ac, curve: Curves.elasticOut));
    _ac.forward();
    _init();
  }

  Future<void> _init() async {
    final app = context.read<AppProvider>();
    final prayer = context.read<PrayerProvider>();
    await prayer.detectLocation((lat, lng) {
      app.setLocation(lat, lng, app.city);
    });
    await prayer.load(app.latitude, app.longitude);
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F0F),
      body: Center(
        child: AnimatedBuilder(
          animation: _ac,
          builder: (_, __) => FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(colors: [
                        Color(0xFF2D9E5F), Color(0xFF1B6B3A),
                      ]),
                      boxShadow: [BoxShadow(
                        color: const Color(0xFF2D9E5F).withOpacity(0.4),
                        blurRadius: 30, spreadRadius: 5,
                      )],
                    ),
                    child: const Center(
                      child: Text('☪', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('نور اسلام',
                      style: TextStyle(
                        fontFamily: 'Amiri', fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                      )),
                  const SizedBox(height: 8),
                  const Text('Noor Islam',
                      style: TextStyle(
                        fontSize: 16, color: Color(0xFF7AAF8A),
                        letterSpacing: 4,
                      )),
                  const SizedBox(height: 48),
                  const SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4AF37), strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
