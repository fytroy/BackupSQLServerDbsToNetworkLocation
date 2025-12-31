@echo off
echo Starting database backup to server...
echo.

powershell -ExecutionPolicy Bypass -Command "& {
    `$ServerShare = '\\192.168.0.100\C_Drive\DatabasePreservation\'
    `$LaptopSQL = 'localhost\FYT'

    # Create directory on server
    if (!(Test-Path `$ServerShare)) {
        Write-Host 'Creating backup directory on server...'
        New-Item -ItemType Directory -Path `$ServerShare -Force
    }

    try {
        Write-Host 'Starting database backup to server...' -ForegroundColor Yellow
        
        # Get all user databases
        `$Databases = Invoke-Sqlcmd -ServerInstance `$LaptopSQL -Query 'SELECT name FROM sys.databases WHERE database_id > 4 AND state = 0'
        
        if (`$Databases.Count -eq 0) {
            Write-Host 'No user databases found.' -ForegroundColor Yellow
            exit
        }
        
        Write-Host ('Found ' + `$Databases.Count + ' databases to backup...') -ForegroundColor Green
        
        foreach (`$db in `$Databases) {
            `$DatabaseName = `$db.name
            `$Timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
            `$BackupFile = `$ServerShare + `$DatabaseName + '_' + `$Timestamp + '.bak'
            
            Write-Host ('Backing up: ' + `$DatabaseName) -ForegroundColor Cyan
            
            try {
                # Backup database directly to server share
                Backup-SqlDatabase -ServerInstance `$LaptopSQL -Database `$DatabaseName -BackupFile `$BackupFile -CompressionOption On
                
                # Get file size
                `$BackupSize = (Get-Item `$BackupFile).Length / 1MB
                `$BackupSizeMB = [math]::Round(`$BackupSize, 2)
                
                Write-Host ('SUCCESS: ' + `$DatabaseName + ' (' + `$BackupSizeMB + ' MB)') -ForegroundColor Green
            }
            catch {
                Write-Host ('FAILED: ' + `$DatabaseName + ' - ' + `$_.Exception.Message) -ForegroundColor Red
            }
        }
        
        Write-Host 'Backup completed! All databases preserved on server.' -ForegroundColor Green
        Write-Host ('Backup location: ' + `$ServerShare) -ForegroundColor Yellow
    }
    catch {
        Write-Host ('Error: ' + `$_.Exception.Message) -ForegroundColor Red
    }
}"

echo.
echo Backup process completed.
pause