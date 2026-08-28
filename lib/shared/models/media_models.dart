class ArtistModel {
  final String id;
  final String name;
  final String imagePath;
  final String genre;
  final int monthlyListeners;
  final String bio;
  final bool isVerified;
  final List<String> songIds;

  const ArtistModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.genre,
    this.monthlyListeners = 1200000,
    this.bio = '',
    this.isVerified = true,
    this.songIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
        'genre': genre,
        'monthlyListeners': monthlyListeners,
        'bio': bio,
        'isVerified': isVerified,
        'songIds': songIds,
      };

  factory ArtistModel.fromJson(Map<String, dynamic> json) => ArtistModel(
        id: json['id'] as String,
        name: json['name'] as String,
        imagePath: json['imagePath'] as String,
        genre: json['genre'] as String,
        monthlyListeners: json['monthlyListeners'] as int? ?? 1200000,
        bio: json['bio'] as String? ?? '',
        isVerified: json['isVerified'] as bool? ?? true,
        songIds: List<String>.from(json['songIds'] as List? ?? []),
      );
}

class AlbumModel {
  final String id;
  final String title;
  final String artist;
  final String coverPath;
  final int releaseYear;
  final List<String> songIds;
  final String description;

  const AlbumModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverPath,
    required this.releaseYear,
    required this.songIds,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'coverPath': coverPath,
        'releaseYear': releaseYear,
        'songIds': songIds,
        'description': description,
      };

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
        id: json['id'] as String,
        title: json['title'] as String,
        artist: json['artist'] as String,
        coverPath: json['coverPath'] as String,
        releaseYear: json['releaseYear'] as int? ?? 2024,
        songIds: List<String>.from(json['songIds'] as List? ?? []),
        description: json['description'] as String? ?? '',
      );
}

class PlaylistModel {
  final String id;
  final String title;
  final String description;
  final String coverPath;
  final List<String> songIds;
  final DateTime createdAt;

  const PlaylistModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverPath,
    required this.songIds,
    required this.createdAt,
  });

  PlaylistModel copyWith({
    String? id,
    String? title,
    String? description,
    String? coverPath,
    List<String>? songIds,
    DateTime? createdAt,
  }) =>
      PlaylistModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        coverPath: coverPath ?? this.coverPath,
        songIds: songIds ?? this.songIds,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'coverPath': coverPath,
        'songIds': songIds,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        coverPath: json['coverPath'] as String,
        songIds: List<String>.from(json['songIds'] as List? ?? []),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}
