@echo off
setlocal
cd /d "%~dp0"

set "FLUTTER=C:\develop\flutter\bin\flutter.bat"

if not exist "%FLUTTER%" (
  where flutter >nul 2>nul
  if errorlevel 1 (
    echo Flutter was not found.
    echo Expected path: C:\develop\flutter\bin\flutter.bat
    pause
    exit /b 1
  )
  set "FLUTTER=flutter"
)

echo Creating Flutter Android project...
call "%FLUTTER%" create --platforms=android --project-name=mvvm_elementary_app --no-pub .
if errorlevel 1 (
  echo Flutter project creation failed.
  pause
  exit /b 1
)

echo Copying source files...
if exist "lib" rmdir /S /Q "lib"
xcopy /E /I /Y "project_files\lib" "lib" >nul
copy /Y "project_files\pubspec.yaml" "pubspec.yaml" >nul
copy /Y "project_files\README.md" "README.md" >nul
if exist "test" rmdir /S /Q "test"

echo Loading packages...
call "%FLUTTER%" pub get
if errorlevel 1 (
  echo flutter pub get failed.
  pause
  exit /b 1
)

rmdir /S /Q "project_files"

echo.
echo DONE.
echo Open this folder in Android Studio:
echo %CD%
pause
