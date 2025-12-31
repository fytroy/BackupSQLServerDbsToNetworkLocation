# Simple Database Backup
$ServerShare = "\\192.168.0.100\C_Drive\DatabasePreservation\"
$LaptopSQL = "localhost\FYT"

# Create directory
if (!(Test-Path $ServerShare)) {
    Write-Host "Creating backup directory..."
    New-Item -ItemType Directory -Path $ServerShare -Force
}

Write-Host "Starting database backup to server..." -ForegroundColor Yellow

# Get databases
$Databases = Invoke-Sqlcmd -ServerInstance $LaptopSQL -Query "SELECT name FROM sys.databases WHERE database_id > 4"

Write-Host "Found $($Databases.Count) databases to backup" -ForegroundColor Green

foreach ($db in $Databases) {
    $BackupFile = "$ServerShare$($db.name)_$(Get-Date -Format 'yyyyMMdd_HHmmss').bak"
    Write-Host "Backing up: $($db.name)" -ForegroundColor Cyan
    Backup-SqlDatabase -ServerInstance $LaptopSQL -Database $db.name -BackupFile $BackupFile
    Write-Host "Completed: $($db.name)" -ForegroundColor Green
}

Write-Host "All databases backed up successfully!" -ForegroundColor Green
Write-Host "Location: $ServerShare" -ForegroundColor Yellow