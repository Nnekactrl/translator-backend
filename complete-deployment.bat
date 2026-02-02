@echo off
echo 🎯 COMPLETE DEPLOYMENT GUIDE
echo ============================

echo.
echo 📋 STEP 1: Create GitHub Repository
echo -----------------------------------
echo 1. Go to: https://github.com/new
echo 2. Repository name: translator-backend
echo 3. Make it PUBLIC
echo 4. UNCHECK "Add a README file"
echo 5. Click "Create repository"
echo.
echo Press any key when done...
pause >nul

echo.
echo 📤 STEP 2: Push Code to GitHub
echo -------------------------------
call push-to-github.bat
if %errorlevel% neq 0 exit /b 1

echo.
echo 🚀 STEP 3: Deploy to Railway
echo ----------------------------
echo 1. Go to: https://railway.app
echo 2. Sign up/Login with GitHub
echo 3. Click "Connect GitHub account"
echo 4. Find "translator-backend" repository
echo 5. Click "Deploy"
echo.
echo Press any key when deployment starts...
pause >nul

echo.
echo ⚙️ STEP 4: Configure Environment Variables
echo -------------------------------------------
echo In Railway dashboard:
echo 1. Click on your project
echo 2. Go to "Variables" tab
echo 3. Add these variables:
echo    PAYSTACK_SECRET_KEY = YOUR_PAYSTACK_LIVE_SECRET_KEY
echo    NODE_ENV = production
echo.
echo Press any key when variables are added...
pause >nul

echo.
echo ⏳ STEP 5: Wait for Deployment
echo ------------------------------
echo Railway will show "Building..." then "Active"
echo This takes 2-3 minutes.
echo.
echo Press any key when deployment is complete...
pause >nul

echo.
echo 🔗 STEP 6: Get Your Deployed URL
echo ---------------------------------
echo In Railway dashboard:
echo 1. Click "Settings" tab
echo 2. Copy the "Public URL" (e.g., https://translator-backend.up.railway.app)
echo.
set /p DEPLOYED_URL="Paste your deployed URL here: "

if "%DEPLOYED_URL%"=="" (
    echo ❌ URL is required!
    pause
    exit /b 1
)

echo.
echo 🔄 STEP 7: Update Extension Files
echo ----------------------------------
echo Updating all popup.js files with your deployed URL...

powershell -Command "(Get-Content '..\popup.js') -replace 'https://your-deployed-backend-url\.com', '%DEPLOYED_URL%' | Set-Content '..\popup.js'"
powershell -Command "(Get-Content '..\new translate\popup.js') -replace 'https://your-deployed-backend-url\.com', '%DEPLOYED_URL%' | Set-Content '..\new translate\popup.js'"
powershell -Command "(Get-Content '..\Translator Extension V1.1\popup.js') -replace 'https://your-deployed-backend-url\.com', '%DEPLOYED_URL%' | Set-Content '..\Translator Extension V1.1\popup.js'"

echo ✅ Extension files updated!

echo.
echo 🧪 STEP 8: Test Backend
echo -----------------------
echo Visit: %DEPLOYED_URL%/api/health
echo You should see: {"status":"ok","message":"Payment server is running"}
echo.
echo Press any key when tested...
pause >nul

echo.
echo 📦 STEP 9: Package Extension
echo ----------------------------
echo 1. Go to Edge browser
echo 2. Open extensions: edge://extensions/
echo 3. Enable "Developer mode"
echo 4. Click "Load unpacked"
echo 5. Select the "Translate" folder (parent folder)
echo 6. Test the extension works
echo.
echo Press any key when tested...
pause >nul

echo.
echo 🚀 STEP 10: Submit to Edge Store
echo ---------------------------------
echo 1. Go to: https://microsoftedge.microsoft.com/addons/
echo 2. Click "Publish" in top right
echo 3. Sign in with Microsoft account
echo 4. Click "Add new extension"
echo 5. Upload your extension package (.zip)
echo 6. Fill in extension details
echo 7. Submit for review
echo.
echo 📅 Review takes 1-2 days
echo.

echo 🎉 CONGRATULATIONS!
echo ===================
echo Your extension is now ready for the Edge Store!
echo Users will be able to make payments successfully.
echo.
echo 📞 Support: If you have issues, check DEPLOYMENT.md
echo.
pause