class Surah {
  final int id;
  final String name;
  final int aya;
  final String english;
  final String turkish;
  final String place;
  final String arabic;

  Surah({
    required this.id,
    required this.name,
    required this.aya,
    required this.english,
    required this.turkish,
    required this.place,
    required this.arabic,
  });

  factory Surah.fromMap(Map<String, dynamic> map) {
    return Surah(
      id: map['id'],
      name: map['name'],
      aya: map['aya'],
      english: map['english'],
      turkish: map['turkish'],
      place: map['place'],
      arabic: map['arabic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'aya': aya,
      'english': english,
      'turkish': turkish,
      'place': place,
      'arabic': arabic,
    };
  }
}
