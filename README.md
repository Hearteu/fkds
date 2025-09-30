# 🌍 Adventure Gallery - Your Personal Memory Collection

A beautiful, modern Flutter web application to showcase your adventure photos and videos. Built with Supabase backend and a clean, light theme with smooth animations.

![Flutter](https://img.shields.io/badge/Flutter-3.9.0-blue)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue)
![Supabase](https://img.shields.io/badge/Supabase-Backend-green)

## ✨ Features

- **Beautiful Card-Based Gallery** - Elegant grid layout showcasing your adventures
- **Supabase Backend** - Cloud storage and database for your media files
- **Upload Functionality** - Easily add new adventures with photos and videos
- **Smooth Animations** - Hover effects and transitions for a premium feel
- **Responsive Design** - Works beautifully on all screen sizes
- **Adventure Collections** - Group photos/videos by trips or events
- **Full-Screen Viewer** - Interactive image viewer with zoom and navigation
- **Clean Light Theme** - Modern, optimized interface that's easy on the eyes
- **Sample Data Fallback** - Beautiful placeholder images when database is empty

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.0 or higher
- A web browser
- Supabase account (free tier works great!)

### Installation

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Set up Supabase:**
   - Your credentials are already configured in the app
   - Follow the detailed setup guide: [SUPABASE_SETUP.md](SUPABASE_SETUP.md)
   - You'll need to:
     - Create database tables (copy/paste SQL)
     - Create storage bucket named "adventures"
     - Set up storage policies

3. **Run on web:**
   ```bash
   flutter run -d chrome
   ```

4. **Add your first adventure:**
   - Click the "Add Adventure" button
   - Fill in details and upload photos
   - Your files will be stored in Supabase!

## 📸 Adding Your Own Photos & Videos

### Method 1: Using the Upload Feature (Recommended!)

1. **Click "Add Adventure"** button in the app
2. Fill in:
   - Adventure title and description
   - Location and date
   - Upload a cover image
   - Upload multiple photos/videos
3. Click **"Create Adventure"**
4. Your files are automatically uploaded to Supabase!

### Method 2: Manual Database Entry

Use the Supabase Dashboard to directly insert data into the `adventures` and `media_items` tables.

### Method 3: Sample Data

If no data exists in Supabase, the app automatically shows beautiful sample images from Unsplash as a fallback.

## 🎨 Customization

Make it yours! Full customization guide available: **[CUSTOMIZATION.md](CUSTOMIZATION.md)**

### Quick Customizations

**Change header image** (`lib/screens/gallery_screen.dart`):
```dart
Image.network('YOUR_IMAGE_URL', fit: BoxFit.cover)
```

**Change main color** (`lib/main.dart`):
```dart
seedColor: const Color(0xFF667EEA), // Try: 0xFF0EA5E9 for ocean blue
```

**Change title** (`lib/screens/gallery_screen.dart`):
```dart
'Our Adventures' // Change to anything you want!
```

**See [CUSTOMIZATION.md](CUSTOMIZATION.md) for complete guide**

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── config/
│   └── supabase_config.dart            # Supabase credentials
├── services/
│   └── supabase_service.dart           # Backend operations
├── models/
│   ├── adventure.dart                  # Adventure data model
│   └── media_item.dart                 # Media item model
├── screens/
│   ├── gallery_screen.dart             # Main gallery view
│   ├── add_adventure_screen.dart       # Upload interface
│   ├── adventure_detail_screen.dart    # Adventure detail page
│   └── media_viewer_screen.dart        # Full-screen media viewer
└── data/
    └── sample_data.dart                # Sample/fallback data
```

## 🛠️ Built With

- **Flutter** - UI framework
- **Supabase** - Backend (database + storage)
- **Google Fonts** - Beautiful typography
- **Cached Network Image** - Efficient image loading
- **File Picker** - Upload files from device
- **Intl** - Date formatting
- **UUID** - Unique file naming

## 📱 Platform Support

Currently optimized for:
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Desktop (Windows, macOS, Linux)
- ⚠️ Mobile (Needs responsive refinements)

## 🎯 Future Enhancements

- [x] Upload functionality for new photos ✅
- [x] Supabase backend integration ✅
- [ ] Edit and delete adventures
- [ ] Search and filter adventures
- [ ] Tags and categories
- [ ] User authentication
- [ ] Share adventures with friends
- [ ] Export as slideshow
- [ ] Dark mode toggle
- [ ] Video playback support
- [ ] Bulk upload
- [ ] Image editing before upload

## 💡 Tips

1. **Image Optimization**: Compress large images before adding them for faster loading
2. **Consistent Naming**: Use descriptive filenames for better organization
3. **Regular Backups**: Keep backups of your media files
4. **Mobile Testing**: Test on different screen sizes for responsive behavior
5. **Customize**: Check [CUSTOMIZATION.md](CUSTOMIZATION.md) to personalize your gallery!
6. **Free Hosting**: Deploy to GitHub Pages - it's free and automatic!

## 🌐 Deployment

Ready to share your gallery with the world?

### Deploy to GitHub Pages (Free!)

**Quick Deploy:**
```bash
flutter build web --base-href "/fkds/"
# Follow the guide: DEPLOY_GITHUB_PAGES.md
```

**Resources:**
- 📘 [Complete Deployment Guide](DEPLOY_GITHUB_PAGES.md)
- ⚡ [Quick Reference](DEPLOY_QUICK.md)
- 🤖 GitHub Actions workflow included (automatic deployment)

**Your site will be live at:**
```
https://YOUR-USERNAME.github.io/fkds/
```

### Other Hosting Options

- **Vercel**: Connect GitHub repo, auto-deploy
- **Netlify**: Drag & drop `build/web` folder
- **Firebase Hosting**: `firebase deploy`
- **Custom Server**: Upload `build/web` contents

## 📄 License

This project is open source and available for personal use.

## 🤝 Contributing

Feel free to fork this project and customize it for your needs!

---

**Enjoy showcasing your adventures! 🎉📷🎥**

**Live Demo**: Deploy yours and share the link!