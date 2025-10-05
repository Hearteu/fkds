import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/supabase_service.dart';
import 'photo_management_screen.dart';

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

  // Hover state management
  Set<int> _hoveredPhotos = <int>{};

  // Pre-calculated photo positions for consistency
  List<Map<String, double>> _photoPositions = [];

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
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop',
  ];

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
    _loadBirthdayPhotos();
    _calculatePhotoPositions();
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

  Future<void> _loadBirthdayPhotos() async {
    try {
      final savedPhotos = await SupabaseService.getBirthdayPhotos();
      if (savedPhotos.isNotEmpty) {
        setState(() {
          _backgroundPhotos = savedPhotos;
        });
        // Recalculate positions with new photos
        _calculatePhotoPositions();
      }
    } catch (e) {
      print('Error loading birthday photos: $e');
    }
  }

  void _calculatePhotoPositions() {
    _photoPositions.clear();
    for (int i = 0; i < _backgroundPhotos.length; i++) {
      final row = i ~/ 4;
      final col = i % 4;

      final offsetX = (_random.nextDouble() - 0.5) * 100;
      final offsetY = (_random.nextDouble() - 0.5) * 100;
      final basePhotoWidth = 200 + _random.nextInt(100).toDouble();
      final basePhotoHeight = 150 + _random.nextInt(100).toDouble();
      final rotation = (_random.nextDouble() - 0.5) * 0.3;

      _photoPositions.add({
        'row': row.toDouble(),
        'col': col.toDouble(),
        'offsetX': offsetX,
        'offsetY': offsetY,
        'width': basePhotoWidth,
        'height': basePhotoHeight,
        'rotation': rotation,
      });
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
          // Photo collage background (non-interactive)
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

          // Animated background elements
          ...List.generate(20, (index) => _buildFloatingBalloon(index)),

          // Confetti particles
          ..._confetti.map((particle) => _buildConfettiParticle(particle)),

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
                              fontSize: 25,
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
                            'You deserve all the love, laughter, and happiness in the world today. \nI hope your heart feels as full and bright as your smile as you make life a little sweeter just by being you. \nI’m so lucky to have you in my life, and I’ll keep being there for you with every day that comes.',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Photo management button - positioned last for proper z-index
          Positioned(
            top: 60,
            right: 30,
            child: _buildPhotoManagementButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCollage() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Ensure photo positions are calculated
    try {
      if ((_photoPositions.isEmpty || _photoPositions.length == 0) &&
          _backgroundPhotos.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _calculatePhotoPositions();
        });
      }
    } catch (e) {
      // If _photoPositions is not initialized, initialize it
      _photoPositions = [];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculatePhotoPositions();
      });
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Photo grid with overlapping effect and hover animations
          ...List.generate(_backgroundPhotos.length, (index) {
            return _buildCollagePhoto(index, screenWidth, screenHeight);
          }),
        ],
      ),
    );
  }

  Widget _buildCollagePhoto(
      int index, double screenWidth, double screenHeight) {
    final isHovered = _hoveredPhotos.contains(index);

    // Ensure _photoPositions is initialized and has data
    try {
      if (_photoPositions.isEmpty || index >= _photoPositions.length) {
        return const SizedBox.shrink();
      }
    } catch (e) {
      // If _photoPositions is not initialized, return empty widget
      return const SizedBox.shrink();
    }

    final position = _photoPositions[index];
    final row = position['row']!.toInt();
    final col = position['col']!.toInt();

    // Base positions with minimal spacing
    final baseLeft = (col * screenWidth / 4) - 50; // Start slightly off-screen
    final baseTop = (row * screenHeight / 5) - 50; // Start slightly off-screen

    // Use pre-calculated offsets and dimensions
    final offsetX = position['offsetX']!;
    final offsetY = position['offsetY']!;
    final basePhotoWidth = position['width']!;
    final basePhotoHeight = position['height']!;
    final rotation = position['rotation']!;

    // Hover dimensions (larger)
    final hoverPhotoWidth = basePhotoWidth * 1.5;
    final hoverPhotoHeight = basePhotoHeight * 1.5;

    return Positioned(
      left: baseLeft + offsetX,
      top: baseTop + offsetY,
      child: GestureDetector(
        onTap: () {
          print('Photo $index tapped'); // Debug print
          setState(() {
            if (_hoveredPhotos.contains(index)) {
              _hoveredPhotos.remove(index);
            } else {
              _hoveredPhotos.add(index);
            }
            print('Hovered photos: $_hoveredPhotos'); // Debug print
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isHovered ? hoverPhotoWidth : basePhotoWidth,
          height: isHovered ? hoverPhotoHeight : basePhotoHeight,
          child: Transform.rotate(
            angle: isHovered ? 0.0 : rotation,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isHovered ? 8 : 12),
                border: isHovered
                    ? Border.all(
                        color: Colors.yellow.withOpacity(0.8),
                        width: 3,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isHovered ? 0.6 : 0.4),
                    blurRadius: isHovered ? 15 : 8,
                    offset: Offset(0, isHovered ? 8 : 3),
                  ),
                  if (isHovered)
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isHovered ? 8 : 12),
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
        ),
      ),
    );
  }

  Widget _buildPhotoManagementButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          print('Opening photo management screen'); // Debug print
          final updatedPhotos = await Navigator.push<List<String>>(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoManagementScreen(
                backgroundPhotos: _backgroundPhotos,
                onPhotosChanged: (photos) {
                  setState(() {
                    _backgroundPhotos = photos;
                  });
                },
              ),
            ),
          );

          if (updatedPhotos != null) {
            setState(() {
              _backgroundPhotos = updatedPhotos;
            });
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
          ),
          child: Icon(
            Icons.photo_library,
            color: Colors.white,
            size: 18,
          ),
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
