# Supabase Database Setup Instructions

Follow these steps to set up your Supabase database for the Adventure Gallery app.

## Step 1: Create Tables

Go to your Supabase dashboard > SQL Editor and run these SQL commands:

### 1. Create Adventures Table

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

-- Enable Row Level Security
ALTER TABLE adventures ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Allow public read access" ON adventures
  FOR SELECT USING (true);

-- Create policy to allow public insert access
CREATE POLICY "Allow public insert access" ON adventures
  FOR INSERT WITH CHECK (true);

-- Create policy to allow public delete access
CREATE POLICY "Allow public delete access" ON adventures
  FOR DELETE USING (true);
```

### 2. Create Media Items Table

```sql
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

-- Enable Row Level Security
ALTER TABLE media_items ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Allow public read access" ON media_items
  FOR SELECT USING (true);

-- Create policy to allow public insert access
CREATE POLICY "Allow public insert access" ON media_items
  FOR INSERT WITH CHECK (true);

-- Create policy to allow public delete access
CREATE POLICY "Allow public delete access" ON media_items
  FOR DELETE USING (true);

-- Create index for faster queries
CREATE INDEX media_items_adventure_id_idx ON media_items(adventure_id);
```

## Step 2: Create Storage Bucket

1. Go to Storage in your Supabase dashboard
2. Click "Create new bucket"
3. Name it: `adventures`
4. Make it **PUBLIC** so images can be accessed directly
5. Click "Create bucket"

### Set Storage Policies

Go to Storage > adventures bucket > Policies and create these:

```sql
-- Allow public to read files
CREATE POLICY "Allow public read access" ON storage.objects
  FOR SELECT USING (bucket_id = 'adventures');

-- Allow public to upload files
CREATE POLICY "Allow public upload access" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'adventures');

-- Allow public to delete files
CREATE POLICY "Allow public delete access" ON storage.objects
  FOR DELETE USING (bucket_id = 'adventures');
```

## Step 3: (Optional) Add Sample Data

```sql
-- Insert a sample adventure
INSERT INTO adventures (title, description, date, location, cover_image)
VALUES (
  'Beach Getaway',
  'Amazing weekend at the beach with friends',
  '2025-08-15 10:00:00+00',
  'Malibu, California',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800'
);

-- Get the ID of the adventure you just created
-- Replace <adventure-id> below with the actual UUID returned

-- Insert sample media items
INSERT INTO media_items (adventure_id, path, type, date, description, location)
VALUES (
  '<adventure-id>',
  'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
  'image',
  '2025-08-15 10:00:00+00',
  'Sunset at the beach',
  'Malibu Beach'
);
```

## Step 4: Verify Setup

1. Check that both tables are created in the Table Editor
2. Check that the storage bucket "adventures" exists and is public
3. Try uploading a test image to the bucket

## Done! 🎉

Your database is now ready to use with the Adventure Gallery app!
