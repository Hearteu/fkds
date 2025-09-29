# ⚡ Quick Deploy Reference

Copy-paste commands for fast GitHub Pages deployment.

## 🚀 First Time Setup

```bash
# 1. Build (replace 'fkds' with your repo name)
flutter build web --base-href "/fkds/"

# 2. Initialize Git
git init
git add .
git commit -m "Initial commit"

# 3. Connect to GitHub (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/fkds.git
git branch -M main
git push -u origin main

# 4. Deploy
cd build/web
git init
git add .
git commit -m "Deploy"
git branch -M gh-pages
git remote add origin https://github.com/YOUR-USERNAME/fkds.git
git push -f origin gh-pages
cd ../..
```

## ✅ Enable GitHub Pages

1. Go to: `github.com/YOUR-USERNAME/fkds/settings/pages`
2. Select branch: `gh-pages`
3. Click Save
4. Visit: `https://YOUR-USERNAME.github.io/fkds/`

---

## 🔄 Update Your Site (After Changes)

### Using GitHub Actions (Automatic)
```bash
git add .
git commit -m "Update"
git push
# Done! GitHub Actions deploys automatically
```

### Manual Update
```bash
# 1. Build
flutter build web --release --base-href "/fkds/"

# 2. Deploy
cd build/web
git init
git add .
git commit -m "Update"
git branch -M gh-pages
git remote add origin https://github.com/YOUR-USERNAME/fkds.git
git push -f origin gh-pages
cd ../..
```

---

## 🐛 Fix Common Issues

**404 Error:**
```bash
flutter build web --base-href "/YOUR-EXACT-REPO-NAME/"
```

**Blank Page:**
```bash
# Hard refresh browser
Ctrl+Shift+R (Windows)
Cmd+Shift+R (Mac)
```

**Changes Not Showing:**
```bash
# Check GitHub Actions completed
# Visit: github.com/YOUR-USERNAME/fkds/actions
```

---

## 📋 Checklist

- [ ] Built with correct base-href
- [ ] Pushed to GitHub
- [ ] Enabled GitHub Pages
- [ ] Waited 2-5 minutes
- [ ] Tested URL: `https://YOUR-USERNAME.github.io/fkds/`

---

Full guide: [DEPLOY_GITHUB_PAGES.md](DEPLOY_GITHUB_PAGES.md)
