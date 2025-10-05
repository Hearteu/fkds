import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../config/supabase_config.dart';
import '../models/adventure.dart';
import '../models/app_settings.dart';
import '../models/media_item.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const _uuid = Uuid();

  // Get app settings (header image, title, etc.)
  static Future<AppSettings> getAppSettings() async {
    try {
      final response =
          await _client.from('app_settings').select().limit(1).maybeSingle();

      if (response == null) {
        return AppSettings.getDefault();
      }

      return AppSettings.fromJson(response);
    } catch (e) {
      print('Error fetching app settings: $e');
      return AppSettings.getDefault();
    }
  }

  // Update app settings
  static Future<bool> updateAppSettings(AppSettings settings) async {
    try {
      await _client.from('app_settings').upsert(
        {
          'id': 1, // Single row for app settings
          ...settings.toJson(),
        },
      );
      return true;
    } catch (e) {
      print('Error updating app settings: $e');
      return false;
    }
  }

  // Get all adventures
  static Future<List<Adventure>> getAdventures() async {
    try {
      final response = await _client
          .from('adventures')
          .select('*, media_items(*)')
          .order('date', ascending: false);

      return (response as List).map((data) {
        final mediaItems = (data['media_items'] as List?)
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

      await _client.storage.from(SupabaseConfig.mediaBucketName).uploadBinary(
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

  // Birthday photos management
  static Future<List<String>> getBirthdayPhotos() async {
    try {
      final response = await _client
          .from('birthday_photos')
          .select('photo_url')
          .order('created_at', ascending: true);

      return (response as List)
          .map((item) => item['photo_url'] as String)
          .toList();
    } catch (e) {
      print('Error fetching birthday photos: $e');
      return [];
    }
  }

  static Future<bool> addBirthdayPhoto(String photoUrl) async {
    try {
      await _client.from('birthday_photos').insert({
        'photo_url': photoUrl,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error adding birthday photo: $e');
      return false;
    }
  }

  static Future<bool> removeBirthdayPhoto(String photoUrl) async {
    try {
      await _client.from('birthday_photos').delete().eq('photo_url', photoUrl);
      return true;
    } catch (e) {
      print('Error removing birthday photo: $e');
      return false;
    }
  }

  static Future<bool> clearBirthdayPhotos() async {
    try {
      await _client.from('birthday_photos').delete().neq('id', 0);
      return true;
    } catch (e) {
      print('Error clearing birthday photos: $e');
      return false;
    }
  }

  // Delete a file from Supabase Storage
  static Future<bool> deleteFile(String fileUrl) async {
    try {
      // Extract the filename from the URL
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length < 3) {
        print('Invalid file URL format: $fileUrl');
        return false;
      }

      // Get the filename from the URL path
      final fileName = pathSegments.last;

      // Delete the file from storage
      await _client.storage
          .from(SupabaseConfig.mediaBucketName)
          .remove([fileName]);

      print('Successfully deleted file: $fileName');
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
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
      // First, get all media items associated with this adventure to delete their files
      final mediaItems = await _client
          .from('media_items')
          .select('path, thumbnail')
          .eq('adventure_id', adventureId);

      // Delete from database (this will cascade delete media_items due to foreign key)
      await _client.from('adventures').delete().eq('id', adventureId);

      // Delete all media files from storage
      for (final mediaItem in mediaItems) {
        // Delete main file
        if (mediaItem['path'] != null &&
            mediaItem['path'].toString().isNotEmpty) {
          try {
            await deleteFile(mediaItem['path']);
          } catch (e) {
            print('Error deleting main file from storage: $e');
          }
        }

        // Delete thumbnail if it exists and is different from main file
        if (mediaItem['thumbnail'] != null &&
            mediaItem['thumbnail'].toString().isNotEmpty &&
            mediaItem['thumbnail'] != mediaItem['path']) {
          try {
            await deleteFile(mediaItem['thumbnail']);
          } catch (e) {
            print('Error deleting thumbnail from storage: $e');
          }
        }
      }

      return true;
    } catch (e) {
      print('Error deleting adventure: $e');
      return false;
    }
  }

  // Delete a media item
  static Future<bool> deleteMediaItem(String mediaItemId) async {
    try {
      // First, get the media item to get the file path for storage deletion
      final mediaItem = await _client
          .from('media_items')
          .select('path, thumbnail')
          .eq('id', mediaItemId)
          .maybeSingle();

      // Delete from database
      await _client.from('media_items').delete().eq('id', mediaItemId);

      // Delete files from storage if they exist
      if (mediaItem != null) {
        // Delete main file
        if (mediaItem['path'] != null &&
            mediaItem['path'].toString().isNotEmpty) {
          try {
            await deleteFile(mediaItem['path']);
          } catch (e) {
            print('Error deleting main file from storage: $e');
          }
        }

        // Delete thumbnail if it exists and is different from main file
        if (mediaItem['thumbnail'] != null &&
            mediaItem['thumbnail'].toString().isNotEmpty &&
            mediaItem['thumbnail'] != mediaItem['path']) {
          try {
            await deleteFile(mediaItem['thumbnail']);
          } catch (e) {
            print('Error deleting thumbnail from storage: $e');
          }
        }
      }

      return true;
    } catch (e) {
      print('Error deleting media item: $e');
      return false;
    }
  }

  // Update an adventure
  static Future<bool> updateAdventure({
    required String adventureId,
    required String title,
    required String description,
    required DateTime date,
    String? location,
    String? coverImage,
  }) async {
    try {
      final updateData = {
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'location': location,
      };

      if (coverImage != null) {
        updateData['cover_image'] = coverImage;
      }

      await _client.from('adventures').update(updateData).eq('id', adventureId);

      return true;
    } catch (e) {
      print('Error updating adventure: $e');
      return false;
    }
  }
}
