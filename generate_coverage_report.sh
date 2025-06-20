#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Inform the user about what the script is doing
echo "Generating mocks (if any)..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "Running tests and generating coverage data..."
flutter test --coverage

# Check if lcov.info was created
if [ ! -f "coverage/lcov.info" ]; then
    echo ""
    echo "Error: coverage/lcov.info not found. Coverage data might not have been generated."
    exit 1
fi

echo ""
echo "Generating HTML coverage report..."

# Check if genhtml is available
if ! command -v genhtml &> /dev/null
then
    echo "Error: genhtml command not found. Please install lcov."
    echo "On Debian/Ubuntu: sudo apt-get install lcov"
    echo "On macOS (Homebrew): brew install lcov"
    exit 1
fi

genhtml coverage/lcov.info -o coverage/html

echo ""
echo "HTML coverage report generated successfully."
echo "Open coverage/html/index.html in your browser to view it."
