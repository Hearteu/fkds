import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/adventure.dart';
import '../services/supabase_service.dart';

class EditAdventureScreen extends StatefulWidget {
  final Adventure adventure;

  const EditAdventureScreen({super.key, required this.adventure});

  @override
  State<EditAdventureScreen> createState() => _EditAdventureScreenState();
}

class _EditAdventureScreenState extends State<EditAdventureScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;

  String? _coverImageUrl;
  Uint8List? _newCoverImageBytes;
  String? _newCoverImageName;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.adventure.title);
    _descriptionController =
        TextEditingController(text: widget.adventure.description);
    _locationController =
        TextEditingController(text: widget.adventure.location ?? '');
    _selectedDate = widget.adventure.date;
    _coverImageUrl = widget.adventure.coverImage;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickNewCoverImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _newCoverImageBytes = result.files.first.bytes;
        _newCoverImageName = result.files.first.name;
      });
    }
  }

  Future<void> _updateAdventure() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      String? newCoverUrl;

      // Upload new cover image if selected
      if (_newCoverImageBytes != null && _newCoverImageName != null) {
        newCoverUrl = await SupabaseService.uploadFile(
          fileBytes: _newCoverImageBytes!,
          fileName: _newCoverImageName!,
          contentType: 'image/${_newCoverImageName!.split('.').last}',
        );

        if (newCoverUrl == null) {
          throw Exception('Failed to upload new cover image');
        }
      }

      // Update adventure
      final success = await SupabaseService.updateAdventure(
        adventureId: widget.adventure.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        location:
            _locationController.text.isEmpty ? null : _locationController.text,
        coverImage: newCoverUrl,
      );

      if (!success) {
        throw Exception('Failed to update adventure');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adventure updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
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
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _deleteAdventure() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Adventure?',
          style: GoogleFonts.playfairDisplay(),
        ),
        content: Text(
          'This will permanently delete "${widget.adventure.title}" and all its photos. This cannot be undone.',
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

    setState(() {
      _isUpdating = true;
    });

    try {
      final success =
          await SupabaseService.deleteAdventure(widget.adventure.id);

      if (!success) {
        throw Exception('Failed to delete adventure');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adventure deleted'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context, true); // Return true to refresh list
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
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Edit Adventure',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _isUpdating ? null : _deleteAdventure,
            tooltip: 'Delete Adventure',
          ),
        ],
      ),
      body: _isUpdating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    'Updating adventure...',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cover Image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: _newCoverImageBytes != null
                            ? DecorationImage(
                                image: MemoryImage(_newCoverImageBytes!),
                                fit: BoxFit.cover,
                              )
                            : _coverImageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(_coverImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                        color: Colors.grey[200],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: ElevatedButton.icon(
                              onPressed: _pickNewCoverImage,
                              icon: const Icon(Icons.edit, size: 16),
                              label: Text(
                                'Change Cover',
                                style: GoogleFonts.lato(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Adventure Title',
                        labelStyle: GoogleFonts.lato(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: GoogleFonts.lato(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: GoogleFonts.lato(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: GoogleFonts.lato(),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Location
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location (optional)',
                        labelStyle: GoogleFonts.lato(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                      style: GoogleFonts.lato(),
                    ),
                    const SizedBox(height: 16),

                    // Date
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 12),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: GoogleFonts.lato(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This will update the adventure details. Photos can be managed separately.',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Update Button
                    ElevatedButton(
                      onPressed: _updateAdventure,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667EEA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
