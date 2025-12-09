# Deploying to Vercel

## Method 1: Deploy via Vercel Dashboard (Recommended)

1. **Go to [vercel.com](https://vercel.com)** and sign in (or create an account)

2. **Click "Add New Project"** or go to [vercel.com/new](https://vercel.com/new)

3. **Import your GitHub repository**:
   - Click "Import Git Repository"
   - Find and select `DarioLankenau/snake_game`
   - Click "Import"

4. **Configure the project**:
   - **Framework Preset**: Other
   - **Root Directory**: `./` (leave as default)
   - **Build Command**: Leave empty (we're deploying pre-built files)
   - **Output Directory**: `build/web`
   - **Install Command**: Leave empty

5. **Click "Deploy"**

6. **Wait for deployment** - Vercel will deploy your app and give you a URL!

## Method 2: Deploy via Vercel CLI

If you prefer using the command line:

```bash
cd /Users/dariojauregui/gameFlutter

# Login to Vercel (first time only)
vercel login

# Deploy to production
vercel --prod
```

## Important Notes

- The `build/web` folder is now committed to git and will be deployed
- When you make code changes:
  1. Make your changes
  2. Run `flutter build web --release`
  3. Commit and push: `git add build/web && git commit -m "Update build" && git push`
  4. Vercel will automatically redeploy (if connected via GitHub)

## After Deployment

Once deployed, you'll get a URL like: `https://snake-game-xxxxx.vercel.app`

Update your README.md with the deployment URL!

