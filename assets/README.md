# Assets Folder

This folder is where you can place your adventure photos and videos!

## Structure

- **images/** - Place your photos here
- **videos/** - Place your videos here

## How to Add Your Own Content

1. **Add your media files:**
   - Copy your photos to `assets/images/`
   - Copy your videos to `assets/videos/`

2. **Update the data:**
   - Open `lib/data/sample_data.dart`
   - Replace the sample URLs with paths to your local assets
   - Example: `'assets/images/beach_sunset.jpg'`

3. **For local files:**
   ```dart
   MediaItem(
     id: '1',
     path: 'assets/images/your_photo.jpg', // Local asset
     type: MediaType.image,
     date: DateTime(2025, 8, 15),
     description: 'Your description',
   )
   ```

4. **For online images (already configured):**
   The app currently uses Unsplash URLs for demo purposes. You can keep using URLs or switch to local assets.

## Tips

- Supported image formats: JPG, PNG, GIF, WebP
- Supported video formats: MP4, MOV
- Optimize large images before adding them for better performance
- Use descriptive filenames to stay organized

Enjoy your adventure gallery! 🎉
