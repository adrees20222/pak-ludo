# Pak Ludo - Desktop Installer Build Script
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Pak Ludo - Windows Installer Builder  " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

$DesktopDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PublishDir = Join-Path $DesktopDir "publish"
$InstallerScript = Join-Path $DesktopDir "installer\setup.iss"

# Find Inno Setup Compiler
$IsccPath = "C:\Users\Muhammad Adrees\AppData\Local\Programs\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $IsccPath)) {
    $IsccCmd = Get-Command iscc.exe -ErrorAction SilentlyContinue
    if ($IsccCmd) {
        $IsccPath = $IsccCmd.Source
    } else {
        Write-Error "Inno Setup compiler (ISCC.exe) not found!"
    }
}

Write-Host "`n[1/2] Publishing lightweight .NET 8.0 WPF release..." -ForegroundColor Cyan
dotnet publish $DesktopDir\PakLudo.csproj -c Release -r win-x64 --self-contained false -o $PublishDir

Write-Host "`n[2/2] Compiling Inno Setup Windows Installer..." -ForegroundColor Cyan
& $IsccPath $InstallerScript

Write-Host "`n🎉 Build completed successfully!" -ForegroundColor Green
Write-Host "Installer created at: $DesktopDir\installer\output\PakLudo-Setup-v1.0.1.exe" -ForegroundColor Yellow
