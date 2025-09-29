# 🚀 Deploy to GitHub Pages

Complete guide to deploy your Adventure Gallery to GitHub Pages (free hosting!).

## 📋 Prerequisites

- Git installed
- GitHub account
- Your app working locally

## 🎯 Deployment Methods

Choose one:
- **Method 1**: Manual deployment (quick, one-time)
- **Method 2**: Automatic deployment with GitHub Actions (recommended)

---

## 🔧 Method 1: Manual Deployment (Quick Start)

### Step 1: Build Your App

```bash
flutter build web --base-href "/fkds/"
```

**Important**: Replace `/fkds/` with your repository name! 
- If your repo is `my-gallery`, use `--base-href "/my-gallery/"`
- Keep the forward slashes: `/repo-name/`

### Step 2: Create GitHub Repository

1. Go to [GitHub.com](https://github.com/new)
2. Repository name: `fkds` (or your choice)
3. Make it **Public** (required for free GitHub Pages)
4. Don't initialize with README (you already have one)
5. Click **"Create repository"**

### Step 3: Initialize Git & Push

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - Adventure Gallery"

# Add remote (replace YOUR-USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR-USERNAME/fkds.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### Step 4: Deploy Build Folder

```bash
# Install gh-pages tool globally (one-time)
npm install -g gh-pages

# Deploy the build folder
cd build/web
git init
git add .
git commit -m "Deploy to GitHub Pages"
git branch -M gh-pages
git remote add origin https://github.com/YOUR-USERNAME/fkds.git
git push -f origin gh-pages
cd ../..
```

### Step 5: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** (top menu)
3. Scroll to **Pages** (left sidebar)
4. Under "Source", select branch: `gh-pages`
5. Select folder: `/ (root)`
6. Click **Save**

### Step 6: Access Your Site! 🎉

Your site will be live at:
```
https://YOUR-USERNAME.github.io/fkds/
```

Wait 2-5 minutes for first deployment.

---

## ⚙️ Method 2: Automatic Deployment (Recommended)

This sets up automatic deployment whenever you push changes.

### Step 1: Create GitHub Repository

Same as Method 1, Step 2.

### Step 2: Create GitHub Actions Workflow

Create this file in your project:

**.github/workflows/deploy.yml**

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Build web
      run: flutter build web --release --base-href "/fkds/"
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build/web
        cname: false
```

**Important**: Change `/fkds/` to your repository name!

### Step 3: Push to GitHub

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit with GitHub Actions"

# Add remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/fkds.git

# Push
git branch -M main
git push -u origin main
```

### Step 4: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Under "Source", select branch: `gh-pages`
4. Select folder: `/ (root)`
5. Click **Save**

### Step 5: Check Deployment Status

1. Go to **Actions** tab in your repository
2. You should see the workflow running
3. Wait for green checkmark ✅
4. Your site is live!

### Step 6: Future Updates

Now whenever you push changes:

```bash
git add .
git commit -m "Update gallery"
git push
```

GitHub Actions automatically rebuilds and deploys! 🎉

---

## 🔗 Custom Domain (Optional)

Want to use your own domain like `mysite.com`?

1. Buy a domain (Namecheap, Google Domains, etc.)
2. Add file `build/web/CNAME` with your domain:
   ```
   mysite.com
   ```
3. In your domain's DNS settings, add:
   - Type: `A` Record
   - Points to:
     - `185.199.108.153`
     - `185.199.109.153`
     - `185.199.110.153`
     - `185.199.111.153`
4. Update workflow YAML:
   ```yaml
   cname: mysite.com
   ```

---

## 🎨 Update Base Path After Deployment

If images/routes don't work, you may need to adjust:

**pubspec.yaml** - Ensure assets are included:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/videos/
```

**web/index.html** - Check base href:
```html
<base href="/fkds/">
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Site loads at `https://YOUR-USERNAME.github.io/fkds/`
- [ ] Images display correctly
- [ ] Navigation works
- [ ] Supabase connection works
- [ ] Can upload adventures
- [ ] Mobile responsive

---

## 🐛 Troubleshooting

### **404 Error**
- Check base-href matches repository name
- Verify branch is `gh-pages`
- Wait 5 minutes after first deploy

### **Blank Page**
```bash
# Rebuild with correct base-href
flutter build web --base-href "/YOUR-REPO-NAME/"
```

### **Images Not Loading**
- Check browser console (F12)
- Verify Supabase bucket is public
- Check network requests

### **Deployment Failed**
- Check Actions tab for errors
- Verify Flutter version in workflow
- Try manual deployment first

### **Changes Not Showing**
- Hard refresh: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)
- Clear browser cache
- Check GitHub Actions completed successfully

---

## 🔄 Workflow Overview

```
Local Development
    ↓
git push
    ↓
GitHub Actions triggered
    ↓
Flutter builds web app
    ↓
Deploys to gh-pages branch
    ↓
GitHub Pages serves it
    ↓
Live at github.io! 🎉
```

---

## 📝 Quick Commands Reference

```bash
# Build for production
flutter build web --release --base-href "/REPO-NAME/"

# Test locally before deploying
flutter run -d chrome --release

# Check if gh-pages branch exists
git branch -a

# Force push to gh-pages (if needed)
git push -f origin gh-pages

# View live site
https://YOUR-USERNAME.github.io/REPO-NAME/
```

---

## 🎯 Best Practices

1. **Always test locally before deploying**
   ```bash
   flutter run -d chrome --release
   ```

2. **Use semantic commits**
   ```bash
   git commit -m "feat: add new adventure upload feature"
   git commit -m "fix: resolve image loading issue"
   ```

3. **Keep main branch clean**
   - Don't commit build files to main
   - Build folder is auto-generated

4. **Monitor Actions**
   - Check Actions tab if deployment fails
   - Read error logs for debugging

---

## 💡 What Gets Deployed

✅ **Deployed:**
- `build/web/` folder contents
- All compiled Flutter web files
- Assets (images, fonts, etc.)

❌ **Not deployed:**
- Source code (`lib/` folder)
- Development files
- Git history

Your source code stays in `main` branch, built files in `gh-pages` branch.

---

## 🎉 Success!

Your Adventure Gallery is now live! Share the link:
```
https://YOUR-USERNAME.github.io/fkds/
```

---

## 📚 Resources

- [GitHub Pages Docs](https://docs.github.com/en/pages)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

**Need Help?**
- Check browser console (F12) for errors
- Review GitHub Actions logs
- Verify Supabase setup is complete
- Test locally first with `flutter run -d chrome`
