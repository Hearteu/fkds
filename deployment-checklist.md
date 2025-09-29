# ✅ Deployment Checklist

Use this checklist to ensure smooth deployment to GitHub Pages.

## 📋 Pre-Deployment

- [ ] App works locally (`flutter run -d chrome`)
- [ ] Supabase is set up and working
- [ ] All features tested
- [ ] No console errors
- [ ] Images load correctly
- [ ] Mobile responsive (test with browser dev tools)

## 🔧 Build Configuration

- [ ] Know your GitHub username: `_______________`
- [ ] Know your repository name: `_______________`
- [ ] Updated base-href in build command:
  ```bash
  flutter build web --base-href "/YOUR-REPO-NAME/"
  ```
- [ ] Build completed successfully
- [ ] Checked `build/web/index.html` has correct base href

## 📤 GitHub Setup

- [ ] Created GitHub repository
- [ ] Repository is **Public** (required for free GitHub Pages)
- [ ] Initialized git locally
- [ ] Added remote origin
- [ ] Pushed to main branch
- [ ] GitHub Actions workflow committed (`.github/workflows/deploy.yml`)

## 🚀 GitHub Pages Configuration

- [ ] Went to repository Settings → Pages
- [ ] Selected source: `gh-pages` branch
- [ ] Selected folder: `/ (root)`
- [ ] Clicked Save
- [ ] Waited 2-5 minutes

## ✅ Verification

- [ ] Site loads at: `https://YOUR-USERNAME.github.io/YOUR-REPO/`
- [ ] No 404 errors
- [ ] Images display
- [ ] Navigation works
- [ ] Can view adventure details
- [ ] Full-screen viewer works
- [ ] Supabase connection active
- [ ] Can upload new adventures
- [ ] Mobile layout works

## 🎨 Final Polish

- [ ] Tested on Chrome
- [ ] Tested on Firefox
- [ ] Tested on Safari (if available)
- [ ] Tested on mobile device
- [ ] Shared link with friends
- [ ] Added link to README
- [ ] Pinned repository on GitHub profile (optional)

## 🔄 Maintenance

- [ ] Know how to update:
  ```bash
  git add .
  git commit -m "Update"
  git push
  # GitHub Actions deploys automatically!
  ```

## 📝 Notes

**Your Site URL:**
```
https://_____________________.github.io/_____________________/
       (your GitHub username)      (repository name)
```

**Deployment Status:**
Check at: `https://github.com/YOUR-USERNAME/YOUR-REPO/actions`

**If something goes wrong:**
1. Check GitHub Actions logs
2. Review browser console (F12)
3. Verify base-href matches repo name exactly
4. Hard refresh: `Ctrl+Shift+R`

---

## 🎉 Success Criteria

✅ **You're done when:**
1. Site is live and accessible
2. All features work online
3. No console errors
4. Looks good on desktop AND mobile
5. You can upload new adventures
6. Friends can view it

---

**Deployment Date:** `_______________`

**Live URL:** `_______________`

**Last Updated:** `_______________`

---

Need help? Check:
- [DEPLOY_GITHUB_PAGES.md](DEPLOY_GITHUB_PAGES.md) - Full guide
- [DEPLOY_QUICK.md](DEPLOY_QUICK.md) - Quick commands
- GitHub Actions logs for errors
