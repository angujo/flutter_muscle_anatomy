@echo off

echo Running pre-publish checks...

echo Running 'flutter pub get'...
call flutter pub get || exit /b 1

echo Running 'flutter analyze'...
call flutter analyze || exit /b 1

echo Running 'flutter test'...
call flutter test || exit /b 1

echo Running 'flutter pub publish --dry-run'...
call flutter pub publish --dry-run || exit /b 1

echo Running 'pana .'...
call pana . || exit /b 1

echo Pre-publish checks completed successfully!