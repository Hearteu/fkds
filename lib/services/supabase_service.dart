import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config/supabase_config.dart';
import '../models/adventure.dart';
import '../models/media_item.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const _uuid = Uuid();

  // Get all adventures
  static Future<List<Adventure>> getAdventures() async {
    try {
      final response = await _client
          .from('adventures')
          .select('*, media_items(*)')
          .order('date', ascending: false);

      return (response as List).map((data) {
        final mediaItems =
            (data['media_items'] as List?)
                ?.map(
                  (item) => MediaItem(
                    id: item['id'].toString(),
                    path: item['path'],
                    type: item['type'] == 'video'
                        ? MediaType.video
                        : MediaType.image,
                    thumbnail: item['thumbnail'],
                    date: DateTime.parse(item['date']),
                    description: item['description'],
                    location: item['location'],
                  ),
                )
                .toList() ??
            [];

        return Adventure(
          id: data['id'].toString(),
          title: data['title'],
          description: data['description'],
          date: DateTime.parse(data['date']),
          location: data['location'],
          coverImage: data['cover_image'],
          mediaItems: mediaItems,
        );
      }).toList();
    } catch (e) {
      print('Error fetching adventures: $e');
      return [];
    }
  }

  // Upload a file to Supabase Storage
  static Future<String?> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String contentType,
  }) async {
    try {
      final String uniqueFileName = '${_uuid.v4()}_$fileName';

      await _client.storage
          .from(SupabaseConfig.mediaBucketName)
          .uploadBinary(
            uniqueFileName,
            fileBytes,
            fileOptions: FileOptions(contentType: contentType, upsert: false),
          );

      final String publicUrl = _client.storage
          .from(SupabaseConfig.mediaBucketName)
          .getPublicUrl(uniqueFileName);

      return publicUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  // Create a new adventure
  static Future<Adventure?> createAdventure({
    required String title,
    required String description,
    required DateTime date,
    String? location,
    required String coverImage,
  }) async {
    try {
      final response = await _client
          .from('adventures')
          .insert({
            'title': title,
            'description': description,
            'date': date.toIso8601String(),
            'location': location,
            'cover_image': coverImage,
          })
          .select()
          .single();

      return Adventure(
        id: response['id'].toString(),
        title: response['title'],
        description: response['description'],
        date: DateTime.parse(response['date']),
        location: response['location'],
        coverImage: response['cover_image'],
        mediaItems: [],
      );
    } catch (e) {
      print('Error creating adventure: $e');
      return null;
    }
  }

  // Add media item to an adventure
  static Future<MediaItem?> addMediaItem({
    required String adventureId,
    required String path,
    required MediaType type,
    required DateTime date,
    String? thumbnail,
    String? description,
    String? location,
  }) async {
    try {
      final response = await _client
          .from('media_items')
          .insert({
            'adventure_id': adventureId,
            'path': path,
            'type': type == MediaType.video ? 'video' : 'image',
            'thumbnail': thumbnail,
            'date': date.toIso8601String(),
            'description': description,
            'location': location,
          })
          .select()
          .single();

      return MediaItem(
        id: response['id'].toString(),
        path: response['path'],
        type: response['type'] == 'video' ? MediaType.video : MediaType.image,
        thumbnail: response['thumbnail'],
        date: DateTime.parse(response['date']),
        description: response['description'],
        location: response['location'],
      );
    } catch (e) {
      print('Error adding media item: $e');
      return null;
    }
  }

  // Delete an adventure and its media items
  static Future<bool> deleteAdventure(String adventureId) async {
    try {
      await _client.from('adventures').delete().eq('id', adventureId);
      return true;
    } catch (e) {
      print('Error deleting adventure: $e');
      return false;
    }
  }

  // Delete a media item
  static Future<bool> deleteMediaItem(String mediaItemId) async {
    try {
      await _client.from('media_items').delete().eq('id', mediaItemId);
      return true;
    } catch (e) {
      print('Error deleting media item: $e');
      return false;
    }
  }
}
