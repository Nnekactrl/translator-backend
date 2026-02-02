@echo off
echo 🚀 Translator Backend GitHub Setup
echo ===================================

set /p GITHUB_USERNAME="Enter your GitHub username: "

if "%GITHUB_USERNAME%"=="" (
    echo ❌ GitHub username is required!
    pause
    exit /b 1
)

echo.
echo 📝 Creating GitHub repository...
echo Visit: https://github.com/new
echo Repository name: translator-backend
echo Make it PUBLIC
echo DO NOT initialize with README
echo.
echo Press any key when you've created the repository...
pause >nul

echo.
echo 🔗 Connecting to GitHub repository...
git remote add origin https://github.com/%GITHUB_USERNAME%/translator-backend.git

echo.
echo 📤 Pushing code to GitHub...
git push -u origin master

if %errorlevel% neq 0 (
    echo ❌ Push failed! Check your GitHub repository URL and try again.
    echo You might need to run: git remote set-url origin https://github.com/%GITHUB_USERNAME%/translator-backend.git
    pause
    exit /b 1
)

echo.
echo ✅ Success! Your backend code is now on GitHub
echo.
echo 🎯 Next Steps:
echo 1. Go to https://railway.app (recommended)
echo 2. Connect your GitHub account
echo 3. Deploy the 'translator-backend' repository
echo 4. Add environment variables in Railway dashboard
echo 5. Get your deployed URL and update the extension
echo.
echo 📋 Deployment Guide: Check DEPLOYMENT.md for detailed instructions
echo.
pause