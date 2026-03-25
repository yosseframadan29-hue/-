class Ayah {
  final int number;
  final String text;

  Ayah({required this.number, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] as int,
      text: json['text'] as String,
    );
  }
}

class Surah {
  final int number;
  final String name;
  final int ayahCount;
  final String audioUrl;
  final List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.ayahCount,
    required this.audioUrl,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    final ayahList = (json['ayahs'] as List<dynamic>)
        .map((e) => Ayah.fromJson(e as Map<String, dynamic>))
        .toList();

    return Surah(
      number: json['number'] as int,
      name: json['name'] as String,
      ayahCount: json['ayahCount'] as int,
      audioUrl: json['audioUrl'] as String,
      ayahs: ayahList,
    );
  }
}
