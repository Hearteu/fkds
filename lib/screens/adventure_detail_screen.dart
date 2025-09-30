import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/adventure.dart';
import '../models/media_item.dart';
import '../services/supabase_service.dart';
import 'edit_adventure_screen.dart';
import 'media_viewer_screen.dart';

class AdventureDetailScreen extends StatefulWidget {
  final Adventure adventure;
  final bool isEditable;

  const AdventureDetailScreen({
    super.key,
    required this.adventure,
    this.isEditable = false,
  });

  @override
  State<AdventureDetailScreen> createState() => _AdventureDetailScreenState();
}

class _AdventureDetailScreenState extends State<AdventureDetailScreen> {
  late List<MediaItem> mediaItems;
  bool _isUploading = false;
  bool _isSelectionMode = false;
  final Set<String> _selectedPhotoIds = {};

  @override
  void initState() {
    super.initState();
    mediaItems = List.from(widget.adventure.mediaItems);
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedPhotoIds.clear();
    });
  }

  void _togglePhotoSelection(String photoId) {
    setState(() {
      if (_selectedPhotoIds.contains(photoId)) {
        _selectedPhotoIds.remove(photoId);
      } else {
        _selectedPhotoIds.add(photoId);
      }
    });
  }

  Future<void> _deleteSelectedPhotos() async {
    if (_selectedPhotoIds.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_selectedPhotoIds.length} Photos?',
            style: GoogleFonts.playfairDisplay()),
        content: Text(
          'This will permanently delete ${_selectedPhotoIds.length} selected photos from the adventure.',
          style: GoogleFonts.lato(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.lato()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete All', style: GoogleFonts.lato()),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final photosToDelete = mediaItems
          .where((item) => _selectedPhotoIds.contains(item.id))
          .toList();

      for (var item in photosToDelete) {
        await SupabaseService.deleteMediaItem(item.id);
        setState(() {
          mediaItems.remove(item);
        });
      }

      setState(() {
        _selectedPhotoIds.clear();
        _isSelectionMode = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${photosToDelete.length} photos deleted'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _addPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      for (var file in result.files) {
        if (file.bytes == null) continue;

        final isVideo = file.extension == 'mp4' ||
            file.extension == 'mov' ||
            file.extension == 'avi';

        // Upload file to Supabase
        final fileUrl = await SupabaseService.uploadFile(
          fileBytes: file.bytes!,
          fileName: file.name,
          contentType:
              isVideo ? 'video/${file.extension}' : 'image/${file.extension}',
        );

        if (fileUrl == null) continue;

        // Add to database
        final newMediaItem = await SupabaseService.addMediaItem(
          adventureId: widget.adventure.id,
          path: fileUrl,
          type: isVideo ? MediaType.video : MediaType.image,
          date: DateTime.now(),
        );

        if (newMediaItem != null) {
          setState(() {
            mediaItems.add(newMediaItem);
          });
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photos added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _deletePhoto(MediaItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Photo?', style: GoogleFonts.playfairDisplay()),
        content: Text(
          'This will permanently delete this photo from the adventure.',
          style: GoogleFonts.lato(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.lato()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete', style: GoogleFonts.lato()),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final success = await SupabaseService.deleteMediaItem(item.id);

      if (success) {
        setState(() {
          mediaItems.remove(item);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo deleted'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity( 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
              ),
              onPressed: () => Navigator.pop(context,
                  mediaItems.length != widget.adventure.mediaItems.length),
            ),
            actions: widget.isEditable
                ? [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity( 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAdventureScreen(
                              adventure: widget.adventure,
                            ),
                          ),
                        );
                        if (result == true && mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                      tooltip: 'Edit Adventure',
                    ),
                  ]
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.adventure.coverImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity( 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Pinned header with title, location, date, and description
          SliverPersistentHeader(
            pinned: true,
            delegate: _AdventureHeaderDelegate(
              adventure: widget.adventure,
              mediaCount: mediaItems.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Gallery',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                      const Spacer(),
                      if (widget.isEditable) ...[
                        if (_isSelectionMode) ...[
                          OutlinedButton.icon(
                            onPressed: _selectedPhotoIds.isEmpty
                                ? null
                                : _deleteSelectedPhotos,
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: Text(
                              'Delete (${_selectedPhotoIds.length})',
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _toggleSelectionMode,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ] else ...[
                          OutlinedButton.icon(
                            onPressed: mediaItems.isEmpty
                                ? null
                                : _toggleSelectionMode,
                            icon: const Icon(Icons.check_circle_outline,
                                size: 18),
                            label: Text(
                              'Select',
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _isUploading ? null : _addPhotos,
                            icon:
                                const Icon(Icons.add_photo_alternate, size: 18),
                            label: Text(
                              'Add Photos',
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF667EEA),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                  if (_isUploading)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Uploading photos...',
                            style: GoogleFonts.lato(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = mediaItems[index];
                final isSelected = _selectedPhotoIds.contains(item.id);

                return MediaThumbnail(
                  mediaItem: item,
                  isEditable: widget.isEditable,
                  isSelectionMode: _isSelectionMode,
                  isSelected: isSelected,
                  onTap: () {
                    if (_isSelectionMode) {
                      _togglePhotoSelection(item.id);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaViewerScreen(
                            mediaItems: mediaItems,
                            initialIndex: index,
                          ),
                        ),
                      );
                    }
                  },
                  onDelete: widget.isEditable && !_isSelectionMode
                      ? () => _deletePhoto(item)
                      : null,
                );
              }, childCount: mediaItems.length),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}

// Custom delegate for the pinned header
class _AdventureHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Adventure adventure;
  final int mediaCount;

  _AdventureHeaderDelegate({
    required this.adventure,
    required this.mediaCount,
  });

  @override
  double get minExtent => 200; // Minimum height when collapsed
  @override
  double get maxExtent => 200; // Maximum height when expanded

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              adventure.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3E50),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Location and Date row
            Row(
              children: [
                if (adventure.location != null) ...[
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    adventure.location!,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(adventure.date),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$mediaCount photos',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            Expanded(
              child: Text(
                adventure.description,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Bottom border
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_AdventureHeaderDelegate oldDelegate) {
    return adventure != oldDelegate.adventure ||
        mediaCount != oldDelegate.mediaCount;
  }
}

class MediaThumbnail extends StatefulWidget {
  final MediaItem mediaItem;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool isEditable;
  final bool isSelectionMode;
  final bool isSelected;

  const MediaThumbnail({
    super.key,
    required this.mediaItem,
    required this.onTap,
    this.onDelete,
    this.isEditable = false,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  bool _isHovered = false;
  bool _showDeleteButton = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          if (widget.isSelectionMode) {
            widget.onTap();
          } else if (!_showDeleteButton) {
            widget.onTap();
          } else {
            setState(() {
              _showDeleteButton = false;
            });
          }
        },
        onLongPress: widget.isEditable && !widget.isSelectionMode
            ? () {
                setState(() {
                  _showDeleteButton = !_showDeleteButton;
                });
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 0.95 : 1.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.mediaItem.path,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
                if (widget.mediaItem.type == MediaType.video)
                  Container(
                    color: Colors.black.withOpacity( 0.3),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Selection mode overlay
                if (widget.isSelectionMode)
                  Container(
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? Colors.blue.withOpacity( 0.4)
                          : Colors.black.withOpacity( 0.2),
                      border: widget.isSelected
                          ? Border.all(color: Colors.blue, width: 3)
                          : null,
                    ),
                  ),
                // Selection checkbox
                if (widget.isSelectionMode)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? Colors.blue
                            : Colors.white.withOpacity( 0.9),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        widget.isSelected
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: widget.isSelected ? Colors.white : Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                // Delete button (appears on click when not in selection mode)
                if (_showDeleteButton &&
                    widget.isEditable &&
                    !widget.isSelectionMode &&
                    widget.onDelete != null)
                  Container(
                    color: Colors.black.withOpacity( 0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            iconSize: 48,
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _showDeleteButton = false;
                              });
                              widget.onDelete!();
                            },
                          ),
                          Text(
                            'Delete Photo',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap again to cancel',
                            style: GoogleFonts.lato(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
