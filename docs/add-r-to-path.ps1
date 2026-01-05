# Add R to user PATH
$rBinPath = "C:\R\R-4.4.1\bin"

# Get current user PATH
$currentPath = [Environment]::GetEnvironmentVariable('Path', 'User')

# Check if R is already in PATH
if ($currentPath -notlike "*$rBinPath*") {
    # Add R to PATH
    $newPath = $currentPath + ";$rBinPath"
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "✓ R bin directory added to user PATH: $rBinPath" -ForegroundColor Green
    Write-Host "Please restart your PowerShell session for changes to take effect." -ForegroundColor Yellow
} else {
    Write-Host "R bin directory already in PATH: $rBinPath" -ForegroundColor Cyan
}

# Show current PATH
Write-Host "`nCurrent user PATH:" -ForegroundColor Cyan
[Environment]::GetEnvironmentVariable('Path', 'User') -split ';' | Where-Object {$_ -like '*R*'}
