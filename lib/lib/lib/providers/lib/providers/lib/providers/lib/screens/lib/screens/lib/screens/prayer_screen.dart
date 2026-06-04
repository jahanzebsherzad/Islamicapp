import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final prayer = context.watch<PrayerProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B6B3A), Color(0xFF0D3D22)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                color: const Color(0xFF1B6B3A).withOpacity(0.4),
                blurRadius: 20, offset: const Offset(0, 8),
              )],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFD4AF37), size: 16),
                    const SizedBox(width: 4),
                    Text(app.city, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(app.t('next'),
                    style: const TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 4),
                Text(prayer.nextPrayerName,
                    style: const TextStyle(
                      fontFamily: 'Amiri', color: Color(0xFFD4AF37),
                      fontSize: 32, fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                Text(prayer.countdown(),
                    style: const TextStyle(
                      color: Colors.white, fontSize: 42,
                      fontWeight: FontWeight.w300, letterSpacing: 4,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (prayer.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (prayer.prayerTimes != null) ...[
            _tile(context, app.t('fajr'), prayer.fmt(prayer.prayerTimes!.fajr), '🌙', prayer.nextPrayerName == app.t('fajr')),
            _tile(context, app.t('sunrise'), prayer.fmt(prayer.prayerTimes!.sunrise), '🌅', false),
            _tile(context, app.t('dhuhr'), prayer.fmt(prayer.prayerTimes!.dhuhr), '☀️', prayer.nextPrayerName == app.t('dhuhr')),
            _tile(context, app.t('asr'), prayer.fmt(prayer.prayerTimes!.asr), '🌤️', prayer.nextPrayerName == app.t('asr')),
            _tile(context, app.t('maghrib'), prayer.fmt(prayer.prayerTimes!.maghrib), '🌇', prayer.nextPrayerName == app.t('maghrib')),
            _tile(context, app.t('isha'), prayer.fmt(prayer.prayerTimes!.isha), '🌃', prayer.nextPrayerName == app.t('isha')),
          ],
        ],
      ),
    );
  }

  Widget _tile(BuildContext ctx, String name, String time, String emoji, bool isNext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isNext ? const Color(0xFFD4AF37).withOpacity(0.15) : Theme.of(ctx).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNext ? const Color(0xFFD4AF37) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Text(name, style: TextStyle(
            fontFamily: 'Amiri', fontSize: 20,
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
            color: isNext ? const Color(0xFFD4AF37) : null,
          )),
          const Spacer(),
          Text(time, style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600,
            color: isNext ? const Color(0xFFD4AF37) : Colors.grey,
          )),
        ],
      ),
    );
  }
}
