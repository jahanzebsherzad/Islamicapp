import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
  @override State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = List.generate(114, (i) => i + 1)
        .where((s) => quran.getSurahNameArabic(s).contains(_search) ||
            quran.getSurahName(s).toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: '...د سورت نوم',
              hintStyle: const TextStyle(fontFamily: 'Amiri'),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B6B3A), Color(0xFF2D9E5F)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
              style: TextStyle(fontFamily: 'Amiri', fontSize: 22, color: Color(0xFFD4AF37)),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (ctx, i) {
              final s = filtered[i];
              final verses = quran.getVerseCount(s);
              return ListTile(
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2D9E5F)),
                  ),
                  child: Center(child: Text('$s',
                      style: const TextStyle(color: Color(0xFF2D9E5F), fontWeight: FontWeight.bold))),
                ),
                title: Text(quran.getSurahNameArabic(s),
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 20)),
                subtitle: Text('${quran.getSurahName(s)} • $verses آیتونه',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                onTap: () => Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => SurahScreen(surahNum: s))),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SurahScreen extends StatelessWidget {
  final int surahNum;
  const SurahScreen({super.key, required this.surahNum});

  @override
  Widget build(BuildContext context) {
    final verseCount = quran.getVerseCount(surahNum);
    final name = quran.getSurahNameArabic(surahNum);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: verseCount + 1,
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B6B3A), Color(0xFF0D3D22)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(children: [
                Text(name, style: const TextStyle(
                    fontFamily: 'Amiri', fontSize: 28, color: Color(0xFFD4AF37))),
                const SizedBox(height: 8),
                if (surahNum != 1 && surahNum != 9)
                  const Text('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                      style: TextStyle(fontFamily: 'Amiri', fontSize: 20, color: Colors.white),
                      textDirection: TextDirection.rtl),
              ]),
            );
          }
          final text = quran.getVerse(surahNum, i, verseEndSymbol: true);
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: const Border(left: BorderSide(color: Color(0xFF2D9E5F), width: 3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B6B3A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('$i', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(height: 10),
                Text(text,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 24, height: 1.9)),
              ],
            ),
          );
        },
      ),
    );
  }
}
