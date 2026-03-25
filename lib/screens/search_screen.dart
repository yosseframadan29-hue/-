import 'package:flutter/material.dart';
import 'package:quran_app_mvp/models/surah.dart';

class SearchScreen extends StatefulWidget {
  final List<Surah> surahs;

  const SearchScreen({super.key, required this.surahs});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = widget.surahs
        .expand(
          (surah) => surah.ayahs
              .where((ayah) => ayah.text.contains(_query))
              .map((ayah) => (surah, ayah)),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('البحث في الآيات')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'اكتب كلمة للبحث...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          Expanded(
            child: _query.isEmpty
                ? const Center(child: Text('ابدأ بكتابة كلمة للبحث'))
                : ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final (surah, ayah) = results[index];
                      return ListTile(
                        title: Text(
                          ayah.text,
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text('${surah.name} - آية ${ayah.number}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
