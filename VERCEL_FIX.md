# Vercel 404 Fix Guide

## Critical: Check Vercel Dashboard Settings

The 404 error is most likely due to incorrect settings in the Vercel dashboard. Follow these steps:

### Step 1: Verify Project Settings

1. Go to your project on [vercel.com](https://vercel.com)
2. Click **Settings** → **General**
3. Scroll to **Build & Development Settings**
4. Make sure these are set EXACTLY as follows:

   - **Root Directory**: `./` (or leave completely empty)
   - **Build Command**: Leave **completely empty**
   - **Output Directory**: `build/web` (must be exact, no trailing slash)
   - **Install Command**: Leave **completely empty**
   - **Development Command**: Leave empty

### Step 2: Clear Build Cache and Redeploy

1. Go to **Settings** → **General**
2. Scroll to **Danger Zone**
3. Click **Clear Build Cache**
4. Go to **Deployments** tab
5. Click the **...** menu on the latest deployment
6. Click **Redeploy**

### Step 3: Verify Files Are Present

In your deployment logs, check that files are being uploaded:
- `index.html` should be at the root
- `main.dart.js` should be present
- `assets/` folder should exist

### Step 4: Test Direct Access

Try accessing these URLs directly:
- `https://your-app.vercel.app/index.html` - Should load the game
- `https://your-app.vercel.app/main.dart.js` - Should download the JS file

If `/index.html` works but the root doesn't, it's a routing issue (which should be fixed by vercel.json).

### Alternative: Manual Verification

If still not working, the issue might be that Vercel isn't detecting the files correctly. Try:

1. In Vercel dashboard, go to your project
2. Click **Settings** → **Git**
3. Make sure the repository is correctly linked
4. Trigger a new deployment by making a small commit

