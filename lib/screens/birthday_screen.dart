import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/supabase_service.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _rotationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;

  final List<ConfettiParticle> _confetti = [];
  final Random _random = Random();

  // Photo collage management
  List<String> _backgroundPhotos = [
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&auto=format&fit=crop',
  ];
  bool _showPhotoManagement = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Start animations
    _startAnimations();
    _generateConfetti();
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _slideController.forward();
    });
    _rotationController.repeat();
  }

  void _generateConfetti() {
    for (int i = 0; i < 50; i++) {
      _confetti.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        color: _getRandomColor(),
        size: _random.nextDouble() * 8 + 4,
        speed: _random.nextDouble() * 2 + 1,
        rotation: _random.nextDouble() * 360,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      Colors.pink,
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.cyan,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Photo collage background
          _buildPhotoCollage(),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Photo management button
          Positioned(
            top: 50,
            right: 20,
            child: _buildPhotoManagementButton(),
          ),

          // Animated background elements
          ...List.generate(20, (index) => _buildFloatingBalloon(index)),

          // Confetti particles
          ..._confetti.map((particle) => _buildConfettiParticle(particle)),

          // Photo management panel
          _buildPhotoManagementPanel(),

          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Birthday cake icon with rotation
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 2 * pi * 0.1,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.cake,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Main birthday message
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          Text(
                            '🎉 Happy Birthday! 🎉',
                            style: GoogleFonts.pacifico(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'May your special day be filled with\njoy, laughter, and wonderful memories!',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          // Birthday wishes cards
                          _buildWishCard(
                            '🎂',
                            'Another Year Wiser',
                            'Age is just a number, and you\'re making it look amazing!',
                          ),

                          const SizedBox(height: 20),

                          _buildWishCard(
                            '🎈',
                            'Endless Joy',
                            'May happiness follow you wherever you go!',
                          ),

                          const SizedBox(height: 20),

                          _buildWishCard(
                            '🎁',
                            'Amazing Adventures',
                            'Here\'s to another year of incredible experiences!',
                          ),

                          const SizedBox(height: 40),

                          // Celebration button
                          _buildCelebrationButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCollage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Photo grid with overlapping effect
          ...List.generate(_backgroundPhotos.length, (index) {
            return Positioned(
              left: (index % 3) * (MediaQuery.of(context).size.width / 3) +
                  (_random.nextDouble() - 0.5) * 50,
              top: (index ~/ 3) * (MediaQuery.of(context).size.height / 4) +
                  (_random.nextDouble() - 0.5) * 50,
              child: Transform.rotate(
                angle: (_random.nextDouble() - 0.5) * 0.5,
                child: Container(
                  width: 200.0 + _random.nextInt(100).toDouble(),
                  height: 150.0 + _random.nextInt(80).toDouble(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: _backgroundPhotos[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPhotoManagementButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(
          _showPhotoManagement ? Icons.close : Icons.photo_library,
          color: Colors.white,
        ),
        onPressed: _togglePhotoManagement,
        tooltip:
            _showPhotoManagement ? 'Hide Photo Management' : 'Manage Photos',
      ),
    );
  }

  Widget _buildPhotoManagementPanel() {
    if (!_showPhotoManagement) return const SizedBox.shrink();

    return Positioned(
      top: 100,
      right: 20,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Background Photos',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 15),

            // Add photo button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _addPhoto,
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_photo_alternate, size: 18),
                label: Text(
                  _isUploading ? 'Uploading...' : 'Add Photo',
                  style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Photo grid
            Container(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _backgroundPhotos.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: _backgroundPhotos[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
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

  Widget _buildFloatingBalloon(int index) {
    return Positioned(
      left: _random.nextDouble() * MediaQuery.of(context).size.width,
      top: _random.nextDouble() * MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              sin(_rotationController.value * 2 * pi + index) * 10,
              cos(_rotationController.value * 2 * pi + index) * 5,
            ),
            child: Opacity(
              opacity: 0.3,
              child: Icon(
                Icons.celebration,
                size: 30 + (index % 3) * 10,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfettiParticle(ConfettiParticle particle) {
    return Positioned(
      left: particle.x * MediaQuery.of(context).size.width,
      top: particle.y * MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: particle.rotation + (_rotationController.value * 2 * pi),
            child: Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                color: particle.color,
                borderRadius: BorderRadius.circular(particle.size / 2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWishCard(String emoji, String title, String message) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationButton() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.white70],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              // Add celebration effect
              _triggerCelebration();
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🎊',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Celebrate!',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF667EEA),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '🎊',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _triggerCelebration() {
    // Restart animations for celebration effect
    _scaleController.reset();
    _scaleController.forward();

    // Add more confetti
    for (int i = 0; i < 20; i++) {
      _confetti.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: 0,
        color: _getRandomColor(),
        size: _random.nextDouble() * 8 + 4,
        speed: _random.nextDouble() * 3 + 2,
        rotation: _random.nextDouble() * 360,
      ));
    }

    setState(() {});
  }

  void _togglePhotoManagement() {
    setState(() {
      _showPhotoManagement = !_showPhotoManagement;
    });
  }

  Future<void> _addPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        setState(() {
          _isUploading = true;
        });

        try {
          final uploadedUrl = await SupabaseService.uploadFile(
            fileBytes: file.bytes!,
            fileName:
                'bday_${DateTime.now().millisecondsSinceEpoch}.${file.extension ?? 'jpg'}',
            contentType: 'image/${file.extension ?? 'jpg'}',
          );

          if (uploadedUrl != null) {
            setState(() {
              _backgroundPhotos.add(uploadedUrl);
              _isUploading = false;
            });

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Photo added to collage!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            setState(() {
              _isUploading = false;
            });

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to upload photo'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } catch (e) {
          setState(() {
            _isUploading = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      }
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _backgroundPhotos.removeAt(index);
    });

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

class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double speed;
  final double rotation;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.rotation,
  });
}
