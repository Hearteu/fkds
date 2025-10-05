import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/supabase_service.dart';

class PhotoManagementScreen extends StatefulWidget {
  final List<String> backgroundPhotos;
  final Function(List<String>) onPhotosChanged;

  const PhotoManagementScreen({
    super.key,
    required this.backgroundPhotos,
    required this.onPhotosChanged,
  });

  @override
  State<PhotoManagementScreen> createState() => _PhotoManagementScreenState();
}

class _PhotoManagementScreenState extends State<PhotoManagementScreen> {
  late List<String> _photos;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.backgroundPhotos);
  }

  Future<void> _addPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true, // Allow multiple file selection
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });

      int successCount = 0;
      int failCount = 0;

      // Upload each selected file
      for (final file in result.files) {
        if (file.bytes != null) {
          try {
            final uploadedUrl = await SupabaseService.uploadFile(
              fileBytes: file.bytes!,
              fileName:
                  'bday_${DateTime.now().millisecondsSinceEpoch}_${successCount + failCount}.${file.extension ?? 'jpg'}',
              contentType: 'image/${file.extension ?? 'jpg'}',
            );

            if (uploadedUrl != null) {
              setState(() {
                _photos.add(uploadedUrl);
              });
              // Save to database
              await SupabaseService.addBirthdayPhoto(uploadedUrl);
              successCount++;
            } else {
              failCount++;
            }
          } catch (e) {
            print('Error uploading file ${file.name}: $e');
            failCount++;
          }
        } else {
          failCount++;
        }
      }

      setState(() {
        _isUploading = false;
      });

      // Update parent screen
      widget.onPhotosChanged(_photos);

      // Show appropriate feedback message
      if (mounted) {
        if (successCount > 0 && failCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '$successCount photo${successCount > 1 ? 's' : ''} added to collage!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (successCount > 0 && failCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '$successCount photo${successCount > 1 ? 's' : ''} added, $failCount failed'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to upload $failCount photo${failCount > 1 ? 's' : ''}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _removePhoto(int index) async {
    if (index >= _photos.length) return;

    final photoUrl = _photos[index];

    // Remove from local list first
    setState(() {
      _photos.removeAt(index);
    });

    // Update parent screen
    widget.onPhotosChanged(_photos);

    // Remove from database
    await SupabaseService.removeBirthdayPhoto(photoUrl);

    // Delete from Supabase Storage (only for uploaded photos, not Unsplash URLs)
    if (photoUrl.contains('supabase') ||
        photoUrl.contains('storage.googleapis.com')) {
      try {
        final deleted = await SupabaseService.deleteFile(photoUrl);
        if (deleted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Photo deleted from storage'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Photo removed from collage (storage deletion failed)'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } catch (e) {
        print('Error deleting photo from storage: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Photo removed from collage (deletion error: $e)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } else {
      // For Unsplash URLs, just show removed message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo removed from collage'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Background Photos',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isUploading ? null : _addPhoto,
            icon: _isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_photo_alternate, size: 18),
            label: Text(
              _isUploading ? 'Uploading...' : 'Add Photos',
              style: GoogleFonts.lato(fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF667EEA),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Photo count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_photos.length} photos',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Photo grid
            Expanded(
              child: _photos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No photos yet',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap "Add Photos" to get started',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 50,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _photos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: _photos[index],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => _removePhoto(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
