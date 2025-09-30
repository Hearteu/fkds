# ✏️ Editing Guide - How to Edit Your Adventures

Complete guide to editing adventures and customizing your gallery app.

## 🎯 What You Can Edit

### 1. **Header Image & App Title** (Settings Screen)
- Header background image
- App title ("Our Adventures")
- App subtitle

### 2. **Individual Adventures** (Edit Screen)
- Adventure title
- Description
- Location
- Date
- Cover image
- Delete entire adventure

### 3. **Media Items** (Coming soon)
- Individual photos/videos within adventures

---

## 🖼️ Edit Header Image

### Access Settings

1. **Open your live gallery**
2. **Click the settings icon** (⚙️) in the top-right corner
3. **Settings screen opens**

### Change Header Image

1. In Settings screen, click **"Change Header Image"**
2. Select a new image from your device
3. Preview appears immediately
4. Click **"Save Settings"**
5. Header updates across the entire app!

### Change App Title/Subtitle

1. In Settings screen, edit the text fields:
   - **App Title**: Main heading (default: "Our Adventures")
   - **Subtitle**: Description text below title
2. Click **"Save Settings"**
3. Changes appear immediately!

**Note:** Settings are stored in Supabase and persist across sessions.

---

## ✏️ Edit an Adventure

### Access Edit Screen

**Method 1: From Gallery**
1. Hover over any adventure card
2. Click the **edit icon** (✏️) in the top-right corner of the card
3. Edit screen opens

**Method 2: From Details**
(Coming soon - edit button on detail screen)

### What You Can Edit

#### 1. **Cover Image**
- Click **"Change Cover"** button
- Select new image
- Old cover is replaced (new URL stored)

#### 2. **Title**
- Edit the adventure title
- Must not be empty

#### 3. **Description**
- Update description text
- Can be multiple lines
- Must not be empty

#### 4. **Location**
- Update location name
- Optional field
- Clear to remove location

#### 5. **Date**
- Click date field to open calendar
- Select new date
- Cannot be in the future

### Save Changes

1. Make your edits
2. Click **"Save Changes"** button
3. Success message appears
4. Returns to gallery
5. Changes are live!

### Cancel Editing

- Use back button/arrow
- Changes are NOT saved
- Adventure remains unchanged

---

## 🗑️ Delete an Adventure

### From Edit Screen

1. Open the adventure for editing
2. Click the **delete icon** (🗑️) in the top-right
3. Confirmation dialog appears:
   - Shows adventure title
   - Warns it's permanent
   - Lists what will be deleted
4. Click **"Delete"** to confirm OR **"Cancel"** to abort
5. If confirmed:
   - Adventure deleted from database
   - All photos removed from that adventure
   - Returns to gallery
   - Gallery refreshes

**⚠️ Warning:** Deletion is permanent and cannot be undone!

---

## 🎨 Where Changes Are Stored

### Supabase Database Tables

**app_settings table:**
- Header image URL
- App title
- App subtitle

**adventures table:**
- Adventure title, description, date, location
- Cover image URL
- Created/updated timestamps

**media_items table:**
- Individual photos/videos
- Linked to specific adventure
- Deleted when adventure is deleted (cascade)

---

## 💡 Editing Best Practices

### 1. **Test Before Deleting**
- Review adventure details first
- Make sure you want to delete it
- Consider editing instead

### 2. **Use Good Images**
- Header: 1200x400px or larger
- Cover: 800x600px or larger
- High quality, well-lit photos

### 3. **Write Clear Descriptions**
- Be descriptive but concise
- Mention key highlights
- Include interesting details

### 4. **Keep Dates Accurate**
- Use actual adventure date
- Helps with chronological sorting
- Better for memories!

### 5. **Add Locations**
- Helps remember where you were
- Great for organization
- Good for storytelling

---

## 🔒 Permissions & Access

### Current Setup (Public Access)

Anyone can:
- ✅ View all adventures
- ✅ Edit any adventure
- ✅ Delete any adventure
- ✅ Change app settings

### Securing Your App (Optional)

To restrict editing:

1. **Add Supabase Authentication**
   - Users must log in
   - Only authenticated users can edit

2. **Update RLS Policies**
   ```sql
   -- Only authenticated users can update
   CREATE POLICY "Authenticated users can update" ON adventures
     FOR UPDATE USING (auth.role() = 'authenticated');
   ```

3. **Hide Edit Buttons**
   - Show edit buttons only when logged in
   - Check auth status in Flutter

**See Supabase documentation for authentication setup.**

---

## ⌨️ Keyboard Shortcuts

### In Edit Forms

- **Tab**: Move to next field
- **Shift+Tab**: Move to previous field
- **Enter**: Submit form (when in text field)
- **Esc**: Cancel/go back

### In Dialogs

- **Enter**: Confirm action
- **Esc**: Cancel action

---

## 🐛 Troubleshooting

### Edit Button Not Showing

**Problem:** No edit icon on adventure cards

**Solutions:**
1. Check if using sample data (edit disabled for samples)
2. Add real adventures from Supabase
3. Sample adventures can't be edited

### Changes Not Saving

**Problem:** Edits don't persist

**Solutions:**
1. Check internet connection
2. Verify Supabase is set up correctly
3. Check browser console (F12) for errors
4. Verify RLS policies allow updates

### Delete Not Working

**Problem:** Can't delete adventure

**Solutions:**
1. Check RLS policies include DELETE permission
2. Verify you have internet connection
3. Check console for error messages
4. Ensure adventure exists in database

### Images Not Uploading

**Problem:** New cover/header images fail

**Solutions:**
1. Check image file size (< 5MB recommended)
2. Use supported formats (JPG, PNG, GIF, WebP)
3. Verify storage bucket exists and is public
4. Check storage policies allow INSERT

---

## 📝 Quick Reference

### Edit Adventure Flow

```
Gallery → Click Edit Icon → Edit Screen
  → Make Changes → Save → Success!
  → Gallery Refreshes → See Updates
```

### Delete Adventure Flow

```
Edit Screen → Click Delete Icon → Confirm Dialog
  → Click Delete → Success → Gallery
  → Adventure Gone → Media Deleted
```

### Edit Settings Flow

```
Gallery → Click Settings Icon → Settings Screen
  → Change Image/Text → Save Settings
  → Success → Gallery → Updates Visible
```

---

## 🎯 Examples

### Example 1: Update Adventure Title

1. Click edit icon on "Beach Trip"
2. Change title to "Malibu Beach Getaway"
3. Click "Save Changes"
4. ✅ Title updated!

### Example 2: Change Header Image

1. Click settings icon (⚙️)
2. Click "Change Header Image"
3. Select your favorite landscape photo
4. Click "Save Settings"
5. ✅ Header updated across entire app!

### Example 3: Delete Old Adventure

1. Click edit on "Test Adventure"
2. Click delete icon (🗑️)
3. Confirm deletion
4. ✅ Adventure and all photos removed!

---

## 🔄 Undo Changes

**Currently:** No undo feature

**Workaround:**
- Keep original info in notes
- Take screenshots before major edits
- Regular database backups (Supabase dashboard)

**Coming Soon:** Edit history and undo functionality

---

## 📚 Related Guides

- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - Change colors, fonts, layouts
- **[SUPABASE_SETUP.md](SUPABASE_SETUP.md)** - Database setup
- **[README.md](README.md)** - Main project overview

---

**Happy Editing! ✨**

Your adventure gallery is now fully editable!
