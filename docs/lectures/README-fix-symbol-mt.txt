Symbol MT Font Fixer for PowerPoint Files
==========================================

This script automatically replaces "Symbol MT" font references with "Symbol"
in PowerPoint (.pptx) files, fixing the save error that occurs when PowerPoint
cannot embed the Symbol MT font.

USAGE
-----

Basic usage:
    ./fix-symbol-mt.sh filename.pptx

Example:
    ./fix-symbol-mt.sh lecture-05.pptx

The script will:
1. Check if the file contains Symbol MT font
2. Create a backup (filename-backup.pptx)
3. Replace all Symbol MT references with Symbol
4. Save the fixed file with the same name
5. Verify the fix was successful

REQUIREMENTS
------------

- Bash shell (Git Bash on Windows, or WSL)
- unzip command
- PowerShell (for repackaging on Windows)
- sed command

NOTES
-----

- Original files are backed up with "-backup.pptx" suffix
- If Symbol MT is not found, the script exits without making changes
- The script verifies the fix after completion
- Safe to run multiple times on the same file

TROUBLESHOOTING
---------------

If you get "permission denied":
    chmod +x fix-symbol-mt.sh

If the script reports Symbol MT still exists after fixing:
    - Manually inspect the file in PowerPoint
    - Check the backup file is intact
    - Report the issue

BATCH PROCESSING
----------------

To fix multiple files at once:

    for file in *.pptx; do
        ./fix-symbol-mt.sh "$file"
    done

Or specific files:

    for file in 01-*.pptx 02-*.pptx; do
        ./fix-symbol-mt.sh "$file"
    done
