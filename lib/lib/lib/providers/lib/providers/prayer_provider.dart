hereimport 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

class PrayerProvider extends ChangeNotifier {
  PrayerTimes? prayerTimes;
  String nextPrayerName = '';
  Duration timeUntilNext = Duration.zero;
  bool isLoading = false;
  String error = '';
  Timer? _timer;

  Future<void> load(double lat, double lng) async {
    isLoading = true;
    error = '';
    notifyListeners();
    try {
      final coords = Coordinates(lat, lng);
      final params = CalculationMethod.karachi.getParameters();
      params.madhab = Madhab.hanafi;
      final dc = DateComponents.from(DateTime.now());
      prayerTimes = PrayerTimes(coords, dc, params);
      _updateNext();
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateNext();
        notifyListeners();
      });
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> detectLocation(Function(double, double) onFound) async {
    try {
      bool se = await Geolocator.isLocationServiceEnabled();
      if (!se) return false;
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return false;
      }
      final pos = await Geolocator.getCurrentPosition();
      onFound(pos.latitude, pos.longitude);
      return true;
    } catch (_) { return false; }
  }

  void _updateNext() {
    if (prayerTimes == null) return;
    final now = DateTime.now();
    final prayers = {
      'فجر': prayerTimes!.fajr,
      'لمر ختل': prayerTimes!.sunrise,
      'غرمه': prayerTimes!.dhuhr,
      'عصر': prayerTimes!.asr,
      'مغرب': prayerTimes!.maghrib,
      'عشاء': prayerTimes!.isha,
    };
    for (final e in prayers.entries) {
      if (e.value.isAfter(now)) {
        nextPrayerName = e.key;
        timeUntilNext = e.value.difference(now);
        return;
      }
    }
    nextPrayerName = 'فجر';
    timeUntilNext = Duration.zero;
  }

  String fmt(DateTime? dt) {
    if (dt == null) return '--:--';
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m ${dt.hour >= 12 ? "PM" : "AM"}';
  }

  String countdown() {
    final h = timeUntilNext.inHours;
    final m = (timeUntilNext.inMinutes % 60).toString().padLeft(2, '0');
    final s = (timeUntilNext.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
}
