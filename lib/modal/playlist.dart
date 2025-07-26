class PlaylistModel {
  final String id;
  final String name;
  final String createdBy;
  final DateTime createdAt;
  final List<String> trackIds;
  final String? imageUrl;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.trackIds,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'trackIds': trackIds,
      'imageUrl': imageUrl,
    };
  }

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      trackIds: List<String>.from(map['trackIds'] ?? []),
      imageUrl: map['imageUrl'],
    );
  }
}
