class SongModel {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String assetPath;
  final Duration duration;
  final String genre;
  final int releaseYear;
  final List<String> lyrics;
  final bool isFavorite;
  final int playCount;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.assetPath,
    required this.duration,
    required this.genre,
    this.releaseYear = 2024,
    this.lyrics = const [],
    this.isFavorite = false,
    this.playCount = 0,
  });

  SongModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? coverUrl,
    String? assetPath,
    Duration? duration,
    String? genre,
    int? releaseYear,
    List<String>? lyrics,
    bool? isFavorite,
    int? playCount,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      coverUrl: coverUrl ?? this.coverUrl,
      assetPath: assetPath ?? this.assetPath,
      duration: duration ?? this.duration,
      genre: genre ?? this.genre,
      releaseYear: releaseYear ?? this.releaseYear,
      lyrics: lyrics ?? this.lyrics,
      isFavorite: isFavorite ?? this.isFavorite,
      playCount: playCount ?? this.playCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'coverUrl': coverUrl,
      'assetPath': assetPath,
      'durationMs': duration.inMilliseconds,
      'genre': genre,
      'releaseYear': releaseYear,
      'lyrics': lyrics,
      'isFavorite': isFavorite,
      'playCount': playCount,
    };
  }

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      coverUrl: json['coverUrl'] as String,
      assetPath: json['assetPath'] as String,
      duration: Duration(milliseconds: json['durationMs'] as int? ?? 0),
      genre: json['genre'] as String? ?? 'Electronic',
      releaseYear: json['releaseYear'] as int? ?? 2024,
      lyrics: List<String>.from(json['lyrics'] as List? ?? []),
      isFavorite: json['isFavorite'] as bool? ?? false,
      playCount: json['playCount'] as int? ?? 0,
    );
  }
}
