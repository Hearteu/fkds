# 🚀 Supabase Setup Guide

Your Adventure Gallery app is now configured to use Supabase! Follow these steps to complete the setup.

## ✅ Already Done

Your Supabase credentials are already configured:
- **URL**: `https://sdjrhytfnhxzadiiekux.supabase.co`
- **Anon Key**: Already stored in the app

## 📋 What You Need to Do

### Step 1: Set Up Database Tables

1. Go to your [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Go to **SQL Editor** (left sidebar)
4. Copy and run the following SQL script:

```sql
-- Create adventures table
CREATE TABLE adventures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  location TEXT,
  cover_image TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create media_items table
CREATE TABLE media_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  adventure_id UUID REFERENCES adventures(id) ON DELETE CASCADE,
  path TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('image', 'video')),
  thumbnail TEXT,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  description TEXT,
  location TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX media_items_adventure_id_idx ON media_items(adventure_id);

-- Enable Row Level Security
ALTER TABLE adventures ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_items ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (you can customize these later)
CREATE POLICY "Allow public read access" ON adventures
  FOR SELECT USING (true);

CREATE POLICY "Allow public insert access" ON adventures
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public delete access" ON adventures
  FOR DELETE USING (true);

CREATE POLICY "Allow public read access" ON media_items
  FOR SELECT USING (true);

CREATE POLICY "Allow public insert access" ON media_items
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public delete access" ON media_items
  FOR DELETE USING (true);
```

5. Click **Run** (or press F5)

### Step 2: Create Storage Bucket

1. In your Supabase Dashboard, go to **Storage** (left sidebar)
2. Click **"New bucket"**
3. Set the name to: **`adventures`** (exactly this name)
4. Make it **Public** (toggle the public option)
5. Click **"Create bucket"**

### Step 3: Configure Storage Policies

1. Click on the **`adventures`** bucket you just created
2. Go to the **Policies** tab
3. Click **"New Policy"**
4. Create the following policies:

#### Policy 1: Allow Public Reads
- Policy name: `Allow public to read files`
- Target roles: `public`
- Operation: `SELECT`
- Policy definition: Leave as default or use:
  ```sql
  bucket_id = 'adventures'
  ```

#### Policy 2: Allow Public Uploads
- Policy name: `Allow public to upload files`
- Target roles: `public`
- Operation: `INSERT`
- Policy definition:
  ```sql
  bucket_id = 'adventures'
  ```

#### Policy 3: Allow Public Deletes
- Policy name: `Allow public to delete files`
- Target roles: `public`
- Operation: `DELETE`
- Policy definition:
  ```sql
  bucket_id = 'adventures'
  ```

### Step 4: (Optional) Add Test Data

If you want to test with sample data, run this in SQL Editor:

```sql
-- Insert a test adventure
INSERT INTO adventures (title, description, date, location, cover_image)
VALUES (
  'Test Beach Trip',
  'Testing the adventure gallery app',
  '2025-09-15 10:00:00+00',
  'California',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800'
);

-- Get the adventure ID (it will be shown in the results)
-- Then insert a media item using that ID
INSERT INTO media_items (adventure_id, path, type, date)
VALUES (
  '<paste-the-adventure-id-here>',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
  'image',
  '2025-09-15 10:00:00+00'
);
```

## 🎉 You're Done!

Now you can:

1. **Run the app**: `flutter run -d chrome`
2. **Click "Add Adventure"** to upload your first adventure with photos!
3. The app will:
   - Store photos/videos in Supabase Storage
   - Save adventure metadata in Supabase Database
   - Display everything in your beautiful gallery

## 📝 How It Works

- **When you add an adventure**: Files are uploaded to Supabase Storage, and metadata is saved to the database
- **When viewing gallery**: The app fetches adventures from Supabase
- **Fallback**: If no data exists, sample data is shown (with a notice)

## 🔒 Security Note

The current setup allows public access for simplicity. For production:

1. Consider adding authentication
2. Update RLS policies to restrict access based on user ID
3. Add proper validation and file size limits

## 💡 Tips

- Images should be under 5MB for best performance
- Supported formats: JPG, PNG, GIF, WebP
- Video formats: MP4, MOV
- The storage bucket is public, so files can be accessed directly via URL

## 🆘 Troubleshooting

**Error: "Table does not exist"**
- Make sure you ran Step 1 SQL script

**Error: "Storage bucket not found"**
- Make sure the bucket is named exactly `adventures`

**Files not uploading:**
- Check that storage policies are set correctly
- Verify the bucket is set to public

**No data showing:**
- The app will show sample data if Supabase is empty
- Check browser console for any errors

Need help? Check the Supabase documentation or the database setup file in `lib/database/setup_instructions.md`
