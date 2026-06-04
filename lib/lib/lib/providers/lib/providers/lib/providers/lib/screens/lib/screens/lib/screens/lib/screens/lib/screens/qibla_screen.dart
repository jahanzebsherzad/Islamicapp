import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFFD4AF37)),
                SizedBox(height: 16),
                Text('د موقعیت ټاکل...',
                    style: TextStyle(fontFamily: 'Amiri', fontSize: 18)),
              ],
            ),
          );
        }
        final qibla = snapshot.data!;
        final angle = qibla.qiblah * (math.pi / 180) * -1;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('د قبلې لوری',
                  style: TextStyle(
                    fontFamily: 'Amiri', fontSize: 28,
                    fontWeight: FontWeight.bold, color: Color(0xFFD4AF37),
                  )),
              const SizedBox(height: 8),
              Text('${qibla.qiblah.toStringAsFixed(1)}°',
                  style: const TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),
              SizedBox(
                width: 280, height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2D9E5F), width: 2),
                        color: const Color(0xFF112017),
                        boxShadow: [BoxShadow(
                          color: const Color(0xFF2D9E5F).withOpacity(0.2),
                          blurRadius: 20,
                        )],
                      ),
                    ),
                    ..._dirs(),
                    Transform.rotate(
                      angle: angle,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.navigation, color: Color(0xFFD4AF37), size: 60),
                          SizedBox(height: 4),
                          Text('كعبة', style: TextStyle(
                            fontFamily: 'Amiri', color: Color(0xFFD4AF37), fontSize: 14,
                          )),
                        ],
                      ),
                    ),
                    Container(
                      width: 16, height: 16,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFD4AF37),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B6B3A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF2D9E5F).withOpacity(0.5)),
                ),
                child: const Text('مخ د قبلې خوا کړئ',
                    style: TextStyle(fontFamily: 'Amiri', fontSize: 18)),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _dirs() {
    const dirs = ['N', 'E', 'S', 'W'];
    const angles = [0.0, math.pi / 2, math.pi, -math.pi / 2];
    const r = 110.0;
    return List.generate(4, (i) => Positioned(
      top: 140 - r * math.cos(angles[i]) - 10,
      left: 140 + r * math.sin(angles[i]) - 10,
      child: Text(dirs[i], style: const TextStyle(
        color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold,
      )),
    ));
  }
}
