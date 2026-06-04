import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late HijriCalendar _today;
  int _selectedMonth = 0;
  int _selectedYear = 0;

  final _events = {
    '1-1': '🎉 د محرم اول - نوی کال',
    '1-10': '🕊️ د عاشورا ورځ',
    '3-12': '🌹 میلاد النبي ﷺ',
    '7-27': '✨ د معراج شپه',
    '8-15': '🌙 د شعبان نیمه شپه',
    '9-1': '🌙 د رمضان پیل',
    '9-27': '⭐ د قدر شپه',
    '10-1': '🎊 عید الفطر',
    '12-8': '⛺ د عرفات ورځ',
    '12-10': '🎊 عید الاضحى',
  };

  @override
  void initState() {
    super.initState();
    _today = HijriCalendar.now();
    _selectedMonth = _today.hMonth;
    _selectedYear = _today.hYear;
  }

  String _monthName(int m) {
    const months = [
      'محرم','صفر','ربیع الاول','ربیع الثاني',
      'جمادى الاولى','جمادى الثانية','رجب','شعبان',
      'رمضان','شوال','ذو القعدة','ذو الحجة',
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              const Text('☪', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                '${_today.hDay} ${_monthName(_today.hMonth)} ${_today.hYear}',
                style: const TextStyle(
                  fontFamily: 'Amiri', fontSize: 28,
                  color: Color(0xFFD4AF37), fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 4),
              Text(DateTime.now().toString().split(' ')[0],
                  style: const TextStyle(color: Colors.white54, fontSize: 14)),
            ]),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() {
                  if (_selectedMonth == 1) { _selectedMonth = 12; _selectedYear--; }
                  else _selectedMonth--;
                }),
              ),
              Text('${_monthName(_selectedMonth)} $_selectedYear',
                  style: const TextStyle(
                    fontFamily: 'Amiri', fontSize: 22, color: Color(0xFFD4AF37),
                  ),
                  textDirection: TextDirection.rtl),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() {
                  if (_selectedMonth == 12) { _selectedMonth = 1; _selectedYear++; }
                  else _selectedMonth++;
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(30, (i) {
            final day = i + 1;
            final key = '$_selectedMonth-$day';
            final event = _events[key];
            if (event == null) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2D9E5F).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B6B3A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text('$day',
                        style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(event,
                      style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
                      textDirection: TextDirection.rtl)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
