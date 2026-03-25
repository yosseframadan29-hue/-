import 'package:flutter/material.dart';
import 'package:quran_app_mvp/models/surah.dart';
import 'package:quran_app_mvp/screens/search_screen.dart';
import 'package:quran_app_mvp/screens/surah_screen.dart';
import 'package:quran_app_mvp/services/quran_repository.dart';

class HomeScreen extends StatefulWidget {
  final QuranRepository repository;

  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Surah>> _surahsFuture;
  String? _lastReadText;

  @override
  void initState() {
    super.initState();
    _surahsFuture = widget.repository.loadSurahs();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final lastRead = await widget.repository.getLastRead();
    if (!mounted || lastRead == null) return;

    setState(() {
      _lastReadText = 'آخر قراءة: سورة ${lastRead.$1} - آية ${lastRead.$2}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق القرآن'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final surahs = await _surahsFuture;
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(surahs: surahs),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Surah>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ في تحميل البيانات: ${snapshot.error}'));
          }

          final surahs = snapshot.data ?? [];
          return Column(
            children: [
              if (_lastReadText != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.bookmark),
                      title: Text(_lastReadText!),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  itemCount: surahs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final surah = surahs[index];
                    return ListTile(
                      title: Text(surah.name),
                      subtitle: Text('عدد الآيات: ${surah.ayahCount}'),
                      leading: CircleAvatar(child: Text('${surah.number}')),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurahScreen(
                              surah: surah,
                              repository: widget.repository,
                            ),
                          ),
                        );
                        _loadLastRead();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
