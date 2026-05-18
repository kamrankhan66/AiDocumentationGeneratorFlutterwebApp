@echo off
echo ========================================
echo  Building Flutter Web with API Key
echo ========================================

REM Replace YOUR_API_KEY_HERE with your actual Gemini API key
set API_KEY=AIzaSyC2EJEgvp6vfvzuH_naORfjmnjiK7rOdlc

echo Building Flutter web with --dart-define...
flutter build web --release --dart-define=GEMINI_API_KEY=%API_KEY%

if %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Deploying to Firebase
echo ========================================
firebase deploy --only hosting

if %ERRORLEVEL% NEQ 0 (
    echo Deployment failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo  SUCCESS! App deployed successfully
echo ========================================
pause

@REM Made with Bob
