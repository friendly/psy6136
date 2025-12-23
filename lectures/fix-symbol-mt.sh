#!/bin/bash

# Script to replace Symbol MT font with Symbol font in PowerPoint files
# Usage: ./fix-symbol-mt.sh filename.pptx

set -e  # Exit on error

# Check if filename was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <powerpoint-file.pptx>"
    echo "Example: $0 myfile.pptx"
    exit 1
fi

PPTX_FILE="$1"

# Check if file exists
if [ ! -f "$PPTX_FILE" ]; then
    echo "Error: File '$PPTX_FILE' not found!"
    exit 1
fi

# Check if file has .pptx extension
if [[ ! "$PPTX_FILE" =~ \.pptx$ ]]; then
    echo "Error: File must have .pptx extension"
    exit 1
fi

# Get the base filename without extension
BASENAME=$(basename "$PPTX_FILE" .pptx)
DIRNAME=$(dirname "$PPTX_FILE")

# Create temporary directory
TEMP_DIR="${DIRNAME}/temp_${BASENAME}_$$"

echo "Processing: $PPTX_FILE"
echo "Checking for Symbol MT font..."

# Check if file contains Symbol MT
if ! unzip -p "$PPTX_FILE" 2>/dev/null | grep -q "Symbol MT"; then
    echo "No 'Symbol MT' font found in this file. Nothing to fix."
    exit 0
fi

echo "Found Symbol MT font. Creating backup..."

# Create backup
BACKUP_FILE="${DIRNAME}/${BASENAME}-backup.pptx"
cp "$PPTX_FILE" "$BACKUP_FILE"
echo "Backup created: $BACKUP_FILE"

echo "Extracting PowerPoint file..."
unzip -q -o "$PPTX_FILE" -d "$TEMP_DIR"

echo "Replacing 'Symbol MT' with 'Symbol'..."

# Find all XML files and replace Symbol MT with Symbol
find "$TEMP_DIR" -type f -name "*.xml" -exec sed -i 's/Symbol MT/Symbol/g' {} \;

# Count how many files were affected
AFFECTED_FILES=$(grep -rl "Symbol" "$TEMP_DIR" --include="*.xml" | wc -l)
echo "Updated $AFFECTED_FILES XML file(s)"

echo "Repackaging PowerPoint file..."

# Create new PowerPoint file using PowerShell on Windows
if command -v powershell.exe &> /dev/null; then
    # Convert paths to Windows format
    TEMP_DIR_WIN=$(cygpath -w "$TEMP_DIR" 2>/dev/null || echo "$TEMP_DIR")
    OUTPUT_ZIP_WIN=$(cygpath -w "${DIRNAME}/${BASENAME}-fixed.zip" 2>/dev/null || echo "${DIRNAME}/${BASENAME}-fixed.zip")

    powershell.exe -Command "Compress-Archive -Path '${TEMP_DIR_WIN}\*' -DestinationPath '${OUTPUT_ZIP_WIN}' -Force" 2>/dev/null

    # Replace original file with fixed version
    mv "${DIRNAME}/${BASENAME}-fixed.zip" "$PPTX_FILE"
else
    echo "Error: PowerShell not found. Cannot repackage PowerPoint file."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up temporary directory
echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "✓ Done! Symbol MT has been replaced with Symbol in $PPTX_FILE"
echo "Original file backed up as: $BACKUP_FILE"

# Verify the fix
if unzip -p "$PPTX_FILE" 2>/dev/null | grep -q "Symbol MT"; then
    echo "⚠ Warning: Symbol MT still found in file. Manual inspection recommended."
    exit 1
else
    echo "✓ Verified: No Symbol MT references found in the fixed file."
fi
