# GitHub Repository Setup Instructions

Your code is committed and ready to push to GitHub!

## Step 1: Create a GitHub Repository

1. Go to [github.com](https://github.com) and sign in
2. Click the **+** icon in the top right corner
3. Select **New repository**
4. Fill in the details:
   - **Repository name**: `snake-game-flutter` (or any name you prefer)
   - **Description**: "A simple Snake game built with Flutter and Flame"
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click **Create repository**

## Step 2: Push Your Code

After creating the repository, GitHub will show you commands. Use these commands in your terminal:

```bash
cd /Users/dariojauregui/gameFlutter

# Add the remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/snake-game-flutter.git

# Push to GitHub
git push -u origin main
```

Or if you prefer SSH:
```bash
git remote add origin git@github.com:YOUR_USERNAME/snake-game-flutter.git
git push -u origin main
```

## Step 3: Verify

Visit your repository on GitHub - you should see all your files there!

## Next Steps (Optional)

After pushing to GitHub, you can:
- Connect it to Vercel for automatic deployments
- Add more collaborators
- Set up GitHub Actions for CI/CD

