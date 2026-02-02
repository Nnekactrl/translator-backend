@echo off
echo 🚀 Pushing Translator Backend to GitHub
echo ========================================

echo Checking if repository exists...
git ls-remote --exit-code origin >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Repository not found!
    echo.
    echo 📋 Please create the repository first:
    echo 1. Go to https://github.com/new
    echo 2. Repository name: translator-backend
    echo 3. Make it PUBLIC
    echo 4. DO NOT initialize with README
    echo 5. Click "Create repository"
    echo.
    echo Then run this script again.
    pause
    exit /b 1
)

echo ✅ Repository found! Pushing code...
git push -u origin master

if %errorlevel% neq 0 (
    echo ❌ Push failed! Please check the error above.
    pause
    exit /b 1
)

echo.
echo 🎉 SUCCESS! Code pushed to GitHub
echo.
echo 🌐 Repository: https://github.com/Nnekactrl/translator-backend
echo.
echo 🚀 Next: Deploy to Railway
echo 1. Go to https://railway.app
echo 2. Connect GitHub account
echo 3. Deploy 'translator-backend'
echo 4. Add environment variables
echo.
pause