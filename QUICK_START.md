# ⚡ Quick Start Guide

Get your Adventure Gallery up and running in 5 minutes!

## ✅ Step-by-Step Setup

### 1️⃣ Install Dependencies (30 seconds)
```bash
flutter pub get
```

### 2️⃣ Set Up Supabase Database (2 minutes)

1. Open [Supabase Dashboard](https://supabase.com/dashboard)
2. Go to **SQL Editor**
3. Copy & paste this entire script and click **Run**:

```sql
-- Tables
CREATE TABLE adventures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  location TEXT,
  cover_image TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

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

CREATE INDEX media_items_adventure_id_idx ON media_items(adventure_id);

-- Security
ALTER TABLE adventures ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access" ON adventures FOR SELECT USING (true);
CREATE POLICY "Allow public insert access" ON adventures FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete access" ON adventures FOR DELETE USING (true);

CREATE POLICY "Allow public read access" ON media_items FOR SELECT USING (true);
CREATE POLICY "Allow public insert access" ON media_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete access" ON media_items FOR DELETE USING (true);
```

### 3️⃣ Create Storage Bucket (1 minute)

1. In Supabase Dashboard, go to **Storage**
2. Click **"New bucket"**
3. Name: `adventures` (exactly!)
4. Toggle **Public**: ON
5. Click **"Create bucket"**

### 4️⃣ Set Storage Policies (1 minute)

1. Click on `adventures` bucket
2. Go to **Policies** tab
3. Add these 3 policies (use "Create policy" button):

**Policy 1**: SELECT (Read)
```sql
bucket_id = 'adventures'
```

**Policy 2**: INSERT (Upload)
```sql
bucket_id = 'adventures'
```

**Policy 3**: DELETE
```sql
bucket_id = 'adventures'
```

### 5️⃣ Run the App! (30 seconds)
```bash
flutter run -d chrome
```

## 🎉 You're Done!

The app will:
- Show sample data initially (with a notice)
- Let you upload your own adventures by clicking "Add Adventure"
- Store everything in Supabase automatically

## 📱 How to Add Your First Adventure

1. Click the **"Add Adventure"** floating button (bottom right)
2. Upload a cover image
3. Fill in title, description, location, date
4. Upload your photos/videos
5. Click **"Create Adventure"**
6. Done! It's now in your gallery

## 🆘 Troubleshooting

**App shows "Showing sample data"**
- This is normal! It means your database is empty
- Click "Add Adventure" to add real data

**Upload fails**
- Check that storage bucket is named `adventures`
- Verify bucket is set to **Public**
- Confirm storage policies are set

**Can't see new adventure**
- Wait a moment and refresh
- Check Supabase dashboard > Table Editor to verify data

**"Table does not exist" error**
- Rerun the SQL script from Step 2

## 💡 Next Steps

- Customize colors in `lib/main.dart`
- Add authentication (see Supabase docs)
- Deploy to web hosting (Firebase, Vercel, Netlify)

For detailed setup, see [SUPABASE_SETUP.md](SUPABASE_SETUP.md)
