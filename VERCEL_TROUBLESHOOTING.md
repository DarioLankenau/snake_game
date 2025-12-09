# Vercel 404 Troubleshooting

If you're getting a 404 error, try these steps:

## Step 1: Verify Vercel Project Settings

In your Vercel dashboard:
1. Go to your project settings
2. Go to "Settings" → "General"
3. Verify:
   - **Root Directory**: Leave empty or set to `./`
   - **Build Command**: Leave **empty** (no build needed)
   - **Output Directory**: Must be exactly `build/web`
   - **Install Command**: Leave empty

## Step 2: Check File Structure

Make sure the files are in the right place. The structure should be:
```
build/web/
  ├── index.html
  ├── main.dart.js
  ├── assets/
  ├── canvaskit/
  └── ...
```

## Step 3: Redeploy

After fixing settings:
1. Go to "Deployments" tab
2. Click the "..." menu on the latest deployment
3. Click "Redeploy"
4. Or trigger a new deployment by pushing a commit

## Step 4: Check Deployment Logs

In the deployment page, check:
- If files are being uploaded correctly
- If there are any errors in the build logs
- If the output directory is correctly detected

## Alternative: Manual Verification

You can verify the files are accessible by checking:
- Your Vercel URL + `/index.html` (should work)
- Your Vercel URL + `/main.dart.js` (should download the JS file)

If index.html works but the root URL doesn't, it's a routing issue.

