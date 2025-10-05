# Birthday Photos Database Setup

## SQL Script to Create birthday_photos Table

Run this SQL script in your Supabase SQL Editor to create the birthday_photos table:

```sql
-- Create birthday_photos table
CREATE TABLE IF NOT EXISTS public.birthday_photos (
    id BIGSERIAL PRIMARY KEY,
    photo_url TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_birthday_photos_created_at ON public.birthday_photos(created_at);
CREATE INDEX IF NOT EXISTS idx_birthday_photos_photo_url ON public.birthday_photos(photo_url);

-- Enable Row Level Security (RLS)
ALTER TABLE public.birthday_photos ENABLE ROW LEVEL SECURITY;

-- Create policies for birthday_photos table
-- Allow anyone to read birthday photos (public access)
CREATE POLICY "Allow public read access to birthday_photos" ON public.birthday_photos
    FOR SELECT USING (true);

-- Allow anyone to insert birthday photos (public access)
CREATE POLICY "Allow public insert access to birthday_photos" ON public.birthday_photos
    FOR INSERT WITH CHECK (true);

-- Allow anyone to delete birthday photos (public access)
CREATE POLICY "Allow public delete access to birthday_photos" ON public.birthday_photos
    FOR DELETE USING (true);

-- Allow anyone to update birthday photos (public access)
CREATE POLICY "Allow public update access to birthday_photos" ON public.birthday_photos
    FOR UPDATE USING (true);

-- Insert some default birthday photos (optional)
INSERT INTO public.birthday_photos (photo_url) VALUES
('https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&auto=format&fit=crop'),
('https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&auto=format&fit=crop');
```

## How It Works

1. **Database Table**: `birthday_photos` stores all background photos with timestamps
2. **Automatic Loading**: Birthday screen loads photos from database on startup
3. **Persistent Storage**: Photos persist across page reloads and sessions
4. **Real-time Updates**: Adding/removing photos updates both database and UI
5. **Fallback**: If no photos in database, uses default Unsplash photos

## Features

- ✅ **Persistent photos** across reloads
- ✅ **Database storage** with timestamps
- ✅ **Public access** (no authentication required)
- ✅ **Performance optimized** with indexes
- ✅ **Default photos** included for immediate use
