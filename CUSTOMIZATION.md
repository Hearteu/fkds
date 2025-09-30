# 🎨 Customization Guide

Make this Adventure Gallery truly yours! Here's how to customize every aspect.

## 🖼️ Change Header Image

The main page header can be customized with your own image.

### Option 1: Use Online Image (Easiest)

Edit `lib/screens/gallery_screen.dart` around line 73-76:

```dart
Image.network(
  'YOUR_IMAGE_URL_HERE',  // Replace with your image URL
  fit: BoxFit.cover,
)
```

**Good image sources:**
- Unsplash: https://unsplash.com (free, high-quality)
- Your own hosted images
- Imgur, Google Photos shared links

**Recommended specs:**
- Size: 1200x400px or larger
- Format: JPG or PNG
- Aspect ratio: Wide/landscape

### Option 2: Use Local Asset

1. **Add your image** to `assets/images/header.jpg`

2. **Update** `lib/screens/gallery_screen.dart`:
```dart
Image.asset(
  'assets/images/header.jpg',
  fit: BoxFit.cover,
)
```

3. **Ensure** it's included in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
```

## 🎨 Change Colors

### Main Theme Color

Edit `lib/main.dart` line ~19:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF667EEA), // Change this!
  brightness: Brightness.light,
),
```

**Try these colors:**
- Ocean Blue: `Color(0xFF0EA5E9)`
- Forest Green: `Color(0xFF10B981)`
- Sunset Orange: `Color(0xFFF59E0B)`
- Purple: `Color(0xFF8B5CF6)`
- Pink: `Color(0xFFEC4899)`

### Background Colors

Edit `lib/main.dart` line ~25:

```dart
scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Change this
```

### Card Colors

Edit `lib/screens/gallery_screen.dart` around line 214:

```dart
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: Colors.white, // Change card background
  boxShadow: [...],
),
```

## ✏️ Change Text

### Main Title

Edit `lib/screens/gallery_screen.dart` line ~65:

```dart
title: Text(
  'Our Adventures', // Change this!
  style: GoogleFonts.playfairDisplay(...),
),
```

### Subtitle

Edit `lib/screens/gallery_screen.dart` around line 100:

```dart
Text(
  'A collection of our favorite moments', // Change this!
  textAlign: TextAlign.center,
  ...
),
```

### Button Text

Edit `lib/screens/gallery_screen.dart` around line 189:

```dart
label: Text(
  'Add Adventure', // Change this!
  style: GoogleFonts.lato(...),
),
```

## 🔤 Change Fonts

### Current Fonts:
- **Titles**: Playfair Display (elegant serif)
- **Body**: Lato (clean sans-serif)

### To Change Fonts:

1. Browse fonts: https://fonts.google.com

2. Update `lib/main.dart`:
```dart
textTheme: GoogleFonts.robotoTextTheme(), // Change 'roboto' to your font
```

3. Update specific text in `gallery_screen.dart`:
```dart
style: GoogleFonts.yourFontName( // Change this
  fontSize: 28,
  fontWeight: FontWeight.bold,
),
```

**Popular alternatives:**
- `montserrat` - Modern and clean
- `openSans` - Very readable
- `raleway` - Elegant
- `poppins` - Friendly and modern
- `inter` - Professional

## 🖼️ Change Icons

### Header Icon (if not using image)

Edit `lib/screens/gallery_screen.dart` line ~86-88:

```dart
Icon(
  Icons.photo_library_rounded, // Change this!
  size: 80,
  color: Colors.white.withOpacity(0.3),
),
```

**Try these icons:**
- `Icons.camera_alt`
- `Icons.explore`
- `Icons.flight_takeoff`
- `Icons.landscape`
- `Icons.beach_access`

### Floating Button Icon

Edit `lib/screens/gallery_screen.dart` line ~188:

```dart
icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
```

## 📐 Change Layouts

### Grid Spacing

Edit `lib/screens/gallery_screen.dart` around line 148:

```dart
gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 400,  // Max card width
  mainAxisSpacing: 20,      // Vertical space between cards
  crossAxisSpacing: 20,     // Horizontal space between cards
  childAspectRatio: 0.85,   // Card height ratio
),
```

### Card Border Radius

Edit `lib/screens/gallery_screen.dart` around line 214:

```dart
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(20), // Change this number
  ...
),
```

### Header Height

Edit `lib/screens/gallery_screen.dart` line ~60:

```dart
SliverAppBar(
  floating: true,
  pinned: true,
  expandedHeight: 200, // Change this!
  ...
),
```

## 🌈 Create Different Themes

### Example: Dark Mode Header

```dart
background: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF1a1a2e),
        Color(0xFF16213e),
        Color(0xFF0f3460),
      ],
    ),
  ),
),
```

### Example: Pastel Theme

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFFFB3BA), // Pastel pink
  brightness: Brightness.light,
),
scaffoldBackgroundColor: const Color(0xFFFFF8F0),
```

### Example: Nature Theme

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF2D6A4F), // Forest green
  brightness: Brightness.light,
),
```

## 🎯 Advanced Customization

### Add Blur Effect to Header

```dart
import 'dart:ui';

// In the header background:
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  child: Container(...),
),
```

### Add Animations

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  // Your widget properties
)
```

### Change Card Shadows

```dart
boxShadow: [
  BoxShadow(
    color: Colors.blue.withOpacity(0.3), // Change color
    blurRadius: 20,                       // Change blur
    offset: Offset(0, 10),                // Change position
  ),
],
```

## 📱 Responsive Design

### Different Header for Mobile

```dart
expandedHeight: MediaQuery.of(context).size.width > 600 ? 250 : 150,
```

### Adjust Grid for Screen Size

```dart
maxCrossAxisExtent: MediaQuery.of(context).size.width > 900 ? 400 : 300,
```

## 🔄 Quick Style Presets

Copy one of these into your `lib/main.dart`:

### Preset 1: Ocean Blue
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF0EA5E9),
  brightness: Brightness.light,
),
```

### Preset 2: Sunset
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFFFF6B6B),
  brightness: Brightness.light,
),
```

### Preset 3: Forest
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF10B981),
  brightness: Brightness.light,
),
```

## 💾 Save Your Changes

After making changes:

```bash
# Test locally
flutter run -d chrome

# Deploy to GitHub Pages
git add .
git commit -m "Customized design"
git push
```

## 🎨 Design Tips

1. **Keep it simple** - Don't use too many colors
2. **Maintain contrast** - Ensure text is readable
3. **Test on mobile** - Check responsiveness
4. **Use high-quality images** - Better visuals = better experience
5. **Stay consistent** - Use the same fonts and colors throughout

## 📸 Recommended Header Images

**Free image sources:**
- Unsplash: https://unsplash.com/s/photos/adventure
- Pexels: https://www.pexels.com/search/travel/
- Pixabay: https://pixabay.com/images/search/mountains/

**What makes a good header:**
- Landscape/wide orientation
- Not too busy (text needs to be readable)
- High resolution (1200px+ width)
- Represents your adventures!

---

**Questions?** Check out the main [README.md](README.md) or other guides!
