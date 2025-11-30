# simulate_ransomware.ps1
# Description:
#  This script SIMULATES ransomware behavior for academic demonstration.
#  It does NOT perform any real cryptography. It only:
#    - Renames .txt files with a .locked extension
#    - Creates a ransom note text file

$TargetFolder = "C:\Users\Public\Documents\critical"
$RansomNotePath = Join-Path $TargetFolder "README_RESTORE_FILES.txt"

Write-Host "Simulated ransomware starting..."
Write-Host "Target folder: $TargetFolder"

if (-Not (Test-Path $TargetFolder)) {
    Write-Host "Target folder does not exist. Creating it for demo..."
    New-Item -ItemType Directory -Path $TargetFolder | Out-Null
    "This is a demo file." | Out-File (Join-Path $TargetFolder "demo1.txt")
    "This is another demo file." | Out-File (Join-Path $TargetFolder "demo2.txt")
}

# Rename *.txt files to *.txt.locked
Get-ChildItem -Path $TargetFolder -Filter "*.txt" -File | ForEach-Object {
    $newName = "$($_.Name).locked"
    Write-Host "Renaming $($_.Name) -> $newName"
    Rename-Item -Path $_.FullName -NewName $newName
}

# Create a ransom note
$ransomText = @"
Your files have been SIMULATED as encrypted for a security demonstration.

This is a harmless academic simulation used in a network security lab.
No actual encryption has been performed.

- Network Security Project
"@

$ransomText | Out-File -Encoding UTF8 $RansomNotePath

Write-Host "Simulation complete. Check the 'critical' folder for .locked files and ransom note."
