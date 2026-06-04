import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/tasbih_provider.dart';
import '../providers/app_provider.dart';

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<TasbihProvider>();
    final app = context.watch<AppProvider>();
    final rounds = t.target > 0 ? t.count ~/ t.target : 0;
    final remaining = t.target - (t.count % t.target);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: t.dhikrList.length,
              itemBuilder: (ctx, i) {
                final selected = i == t.selectedIndex;
                return GestureDetector(
                  onTap: () => t.selectDhikr(i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1B6B3A) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? const Color(0xFF1B6B3A) : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(t.dhikrList[i]['ar'],
                        style: TextStyle(
                          fontFamily: 'Amiri', fontSize: 14,
                          color: selected ? Colors.white : Colors.grey,
                        )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(t.current['ar'],
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Amiri', fontSize: 36,
                  color: Color(0xFFD4AF37), height: 1.5,
                )),
          ),
          Text(t.current['meaning'],
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 32),
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 12.0,
            percent: t.progress,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${t.count % t.target == 0 && t.count > 0 ? t.target : t.count % t.target}',
                    style: const TextStyle(
                      fontSize: 64, fontWeight: FontWeight.w200,
                      color: Color(0xFFD4AF37),
                    )),
                Text('/ ${t.target}',
                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
            progressColor: const Color(0xFF2D9E5F),
            backgroundColor: const Color(0xFF1B6B3A).withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animateFromLastPercent: true,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _badge('جمع: ${t.count}', const Color(0xFF1B6B3A)),
              const SizedBox(width: 12),
              _badge('دور: $rounds', const Color(0xFF8B6914)),
              const SizedBox(width: 12),
              _badge('پاتې: $remaining', const Color(0xFF1A3D2E)),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: t.tap,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(colors: [
                  Color(0xFF2D9E5F), Color(0xFF1B6B3A),
                ]),
                boxShadow: [BoxShadow(
                  color: const Color(0xFF1B6B3A).withOpacity(0.5),
                  blurRadius: 30, spreadRadius: 5,
                )],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('☪', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 4),
                  Text('فشار ورکړئ', style: TextStyle(
                    fontFamily: 'Amiri', color: Colors.white70, fontSize: 14,
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: t.reset,
            icon: const Icon(Icons.refresh, color: Colors.grey),
            label: Text(app.t('reset'),
                style: const TextStyle(color: Colors.grey, fontFamily: 'Amiri')),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.3),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.5)),
    ),
    child: Text(text, style: const TextStyle(fontSize: 12)),
  );
}
