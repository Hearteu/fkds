enum MediaType { image, video }

class MediaItem {
  final String id;
  final String path;
  final MediaType type;
  final String? thumbnail;
  final DateTime date;
  final String? description;
  final String? location;

  MediaItem({
    required this.id,
    required this.path,
    required this.type,
    this.thumbnail,
    required this.date,
    this.description,
    this.location,
  });
}
