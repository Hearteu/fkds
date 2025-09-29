import 'media_item.dart';

class Adventure {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? location;
  final List<MediaItem> mediaItems;
  final String coverImage;

  Adventure({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.location,
    required this.mediaItems,
    required this.coverImage,
  });
}
