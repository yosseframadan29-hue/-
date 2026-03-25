import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app_mvp/models/surah.dart';
import 'package:quran_app_mvp/services/quran_repository.dart';

class SurahScreen extends StatefulWidget {
  final Surah surah;
  final QuranRepository repository;

  const SurahScreen({super.key, required this.surah, required this.repository});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final _player = AudioPlayer();
  bool _loadingAudio = false;

  Future<void> _toggleAudio() async {
    if (_player.playing) {
      await _player.pause();
      setState(() {});
      return;
    }

    try {
      setState(() => _loadingAudio = true);
      if (_player.processingState == ProcessingState.idle) {
        await _player.setUrl(widget.surah.audioUrl);
      }
      await _player.play();
    } finally {
      if (mounted) {
        setState(() => _loadingAudio = false);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.surah.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadingAudio ? null : _toggleAudio,
        icon: Icon(_player.playing ? Icons.pause : Icons.play_arrow),
        label: Text(_player.playing ? 'إيقاف التلاوة' : 'تشغيل التلاوة'),
      ),
      body: ListView.builder(
        itemCount: widget.surah.ayahs.length,
        itemBuilder: (_, index) {
          final ayah = widget.surah.ayahs[index];
          return ListTile(
            title: Text(
              ayah.text,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 20, height: 1.7),
            ),
            trailing: CircleAvatar(radius: 14, child: Text('${ayah.number}')),
            onTap: () {
              widget.repository.saveLastRead(
                surahNumber: widget.surah.number,
                ayahNumber: ayah.number,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حفظ الآية ${ayah.number} كآخر موضع قراءة')),
              );
            },
          );
        },
      ),
    );
  }
}
