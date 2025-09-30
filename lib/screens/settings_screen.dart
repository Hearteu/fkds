import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/app_settings.dart';
import '../services/supabase_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;

  String? _headerImageUrl;
  Uint8List? _newHeaderImageBytes;
  String? _newHeaderImageName;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    final settings = await SupabaseService.getAppSettings();

    setState(() {
      _headerImageUrl = settings.headerImageUrl;
      _titleController.text = settings.appTitle ?? 'Our Adventures';
      _subtitleController.text =
          settings.appSubtitle ?? 'A collection of our favorite moments';
      _isLoading = false;
    });
  }

  Future<void> _pickHeaderImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _newHeaderImageBytes = result.files.first.bytes;
        _newHeaderImageName = result.files.first.name;
      });
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      String? newHeaderUrl = _headerImageUrl;

      // Upload new header image if selected
      if (_newHeaderImageBytes != null && _newHeaderImageName != null) {
        newHeaderUrl = await SupabaseService.uploadFile(
          fileBytes: _newHeaderImageBytes!,
          fileName: _newHeaderImageName!,
          contentType: 'image/${_newHeaderImageName!.split('.').last}',
        );

        if (newHeaderUrl == null) {
          throw Exception('Failed to upload header image');
        }
      }

      final settings = AppSettings(
        id: '1',
        headerImageUrl: newHeaderUrl ?? _headerImageUrl!,
        appTitle: _titleController.text,
        appSubtitle: _subtitleController.text,
      );

      final success = await SupabaseService.updateAppSettings(settings);

      if (!success) {
        throw Exception('Failed to save settings');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to refresh
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
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'App Settings',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isSaving
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        'Saving settings...',
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
                        Text(
                          'Header Image',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Header Image Preview
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: _newHeaderImageBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(_newHeaderImageBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : _headerImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(_headerImageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                            color: Colors.grey[200],
                          ),
                          child: Stack(
                            children: [
                              // Gradient overlay
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _pickHeaderImage,
                                  icon: const Icon(Icons.upload),
                                  label: Text(
                                    'Change Header Image',
                                    style: GoogleFonts.lato(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          'App Text',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Title
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'App Title',
                            labelStyle: GoogleFonts.lato(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Our Adventures',
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

                        // Subtitle
                        TextFormField(
                          controller: _subtitleController,
                          decoration: InputDecoration(
                            labelText: 'Subtitle',
                            labelStyle: GoogleFonts.lato(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'A collection of our favorite moments',
                          ),
                          style: GoogleFonts.lato(),
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
                                  'These settings affect the main gallery screen. Changes will be visible after saving.',
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

                        // Save Button
                        ElevatedButton(
                          onPressed: _saveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Settings',
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
