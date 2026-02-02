@echo off
echo 🔄 Extension URL Updater
echo ========================

set /p DEPLOYED_URL="Enter your deployed backend URL (e.g., https://translator-backend.up.railway.app): "

if "%DEPLOYED_URL%"=="" (
    echo ❌ Deployed URL is required!
    pause
    exit /b 1
)

echo.
echo Updating popup.js files...

REM Update main popup.js
powershell -Command "(Get-Content '..\popup.js') -replace 'https://your-deployed-backend-url\.com', '%DEPLOYED_URL%' | Set-Content '..\popup.js'"

REM Update new translate popup.js
powershell -Command "(Get-Content '..\new translate\popup.js') -replace 'https://your-deployed-backend-url\.com', '%DEPLOYED_URL%' | Set-Content '..\new translate\popup.js'"

REM Update Translator Extension V1.1 popup.js
powershell -Command "(Get-Content '..\Translator Extension V1.1\popup.js') -replace 'https://your-deployed-backend-url\.com', '%DEPLOYED_URL%' | Set-Content '..\Translator Extension V1.1\popup.js'"

echo.
echo ✅ Extension URLs updated!
echo.
echo 📋 Next Steps:
echo 1. Test the extension locally (load unpacked in Chrome)
echo 2. Package the extension for Edge Store
echo 3. Submit to Edge Store for review
echo.
echo 🎉 Your extension is now ready for production!
echo.
pause