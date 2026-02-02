# 🚀 Backend Deployment Guide

## Prerequisites
- GitHub account
- Paystack live key (already configured)
- One of: Railway, Render, or Heroku account

## Step 1: Create GitHub Repository

1. Go to https://github.com and sign in
2. Click "New repository"
3. Name it: `translator-backend` or `translator-payment-backend`
4. Make it **Public** (required for free deployment)
5. **DO NOT** initialize with README (we already have one)
6. Click "Create repository"

## Step 2: Push Code to GitHub

Run these commands in your backend folder:

```bash
# Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/translator-backend.git

# Push to GitHub
git push -u origin master
```

## Step 3: Deploy to Hosting Service

### Option A: Railway (Easiest - FREE)

1. **Sign up:** Go to https://railway.app
2. **Connect GitHub:** Click "Connect GitHub" and authorize
3. **Deploy:** Find your `translator-backend` repo and click "Deploy"
4. **Environment Variables:** Click on your project → "Variables" tab
   - Add: `PAYSTACK_SECRET_KEY` = `YOUR_PAYSTACK_LIVE_SECRET_KEY`
   - Add: `NODE_ENV` = `production`
5. **Wait for deployment** (usually 2-3 minutes)
6. **Get your URL:** Click "Settings" tab → Copy the "Public URL"

### Option B: Render (FREE)

1. **Sign up:** Go to https://render.com
2. **Connect GitHub:** Authorize Render to access your GitHub
3. **Create Service:** Click "New" → "Web Service"
4. **Connect Repo:** Select your `translator-backend` repository
5. **Configure:**
   - **Runtime:** Node
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
6. **Environment:** Add the same variables as above
7. **Deploy:** Click "Create Web Service"
8. **Get URL:** Copy the service URL when deployment completes

### Option C: Heroku

1. **Install Heroku CLI:** Download from https://devcenter.heroku.com/articles/heroku-cli
2. **Login:** `heroku login`
3. **Create app:** `heroku create translator-backend-YOURNAME`
4. **Set variables:**
   ```bash
   heroku config:set PAYSTACK_SECRET_KEY=YOUR_PAYSTACK_LIVE_SECRET_KEY
   heroku config:set NODE_ENV=production
   ```
5. **Deploy:** `git push heroku master`
6. **Get URL:** `heroku open` or check Heroku dashboard

## Step 4: Test Your Deployed Backend

Visit: `https://your-deployed-url.com/api/health`

You should see: `{"status":"ok","message":"Payment server is running"}`

## Step 5: Update Extension Code

Once you have your deployed URL (e.g., `https://translator-backend.up.railway.app`), update ALL popup.js files:

Replace:
```javascript
const BACKEND_URL = 'https://your-deployed-backend-url.com';
```

With:
```javascript
const BACKEND_URL = 'https://translator-backend.up.railway.app'; // Your actual URL
```

Files to update:
- `popup.js` (root)
- `new translate/popup.js`
- `Translator Extension V1.1/popup.js`

## Step 6: Update CORS (Optional but Recommended)

In `backend/server.js`, replace:
```javascript
'https://your-deployed-extension-backend.com'
```

With your actual deployed URL.

## Step 7: Republish Extension

1. **Package your extension** with the updated popup.js files
2. **Submit to Edge Store** for review
3. **Wait for approval** (usually 1-2 days)

## Troubleshooting

### Backend won't deploy:
- Check that `.env` is NOT committed (it's in .gitignore)
- Make sure all dependencies are in package.json
- Check build logs for errors

### Extension still shows localhost error:
- Double-check ALL popup.js files have the correct deployed URL
- Clear browser cache and reload extension

### CORS errors:
- Make sure your deployed URL is added to the CORS origins in server.js
- Restart your deployed service after CORS changes

## Support

If you get stuck on any step, share the error message and I'll help you fix it!

🎉 **Congratulations!** Once deployed, your extension will work perfectly on the Edge Store.