 Backup SQL Server Databases to Network Location

This project provides automated scripts to backup SQL Server databases to a network share location.

 Overview

The scripts backup all user databases from a SQL Server instance to a network share, with timestamped filenames for version control.

 Files

- BackupToServer.bat - Batch file wrapper that executes the PowerShell backup script with proper execution policy
- BackupToServer.ps1 - PowerShell script for database backup operations

-BackupToServer.ps1 -This PowerShell script performs a backup of SQL Server databases to a network location.
-BackupToServer.bat -This is a batch file that calls PowerShell to perform SQL Server database backups with significant improvements over the previous version.

 Features

- Automatically discovers all user databases (excludes system databases)
- Creates timestamped backup files (`DatabaseName_yyyyMMdd_HHmmss.bak`)
- Backup compression enabled (in .bat version)
- Creates backup directory if it doesn't exist
- Color-coded console output for easy monitoring
- Error handling with detailed logging

 Configuration

Before running, update the following variables in the scripts:

```powershell
$ServerShare = "\\192.168.0.100\C_Drive\DatabasePreservation\"   Network share path
$LaptopSQL = "localhost\FYT"                                      SQL Server instance
```

 Requirements

- Windows PowerShell
- SQL Server PowerShell module (SqlServer)
- Network access to the backup destination
- Appropriate permissions for:
  - SQL Server database backups
  - Writing to network share

 Installation

1. Install SQL Server PowerShell module if not already installed:
   ```powershell
   Install-Module -Name SqlServer -AllowClobber
   ```

2. Update the configuration variables in the scripts to match your environment

3. Ensure you have network connectivity to the target share

 Usage

 Option 1: Run the Batch File (Recommended)
```cmd
BackupToServer.bat
```

The batch file automatically sets the execution policy and runs the PowerShell script.

 Option 2: Run PowerShell Script Directly
```powershell
.\BackupToServer.ps1
```

 Output

The script will:
1. Check/create the backup directory on the network share
2. Query for all user databases
3. Backup each database with compression
4. Display progress with color-coded status messages
5. Show backup file size (in .bat version)

Example output:
```
Starting database backup to server...
Found 5 databases to backup...
Backing up: MyDatabase
SUCCESS: MyDatabase (125.43 MB)
...
Backup completed! All databases preserved on server.
```

 Backup Location

Backups are stored at: `\\192.168.0.100\C_Drive\DatabasePreservation\`

Each backup file follows the naming convention: `DatabaseName_yyyyMMdd_HHmmss.bak`

 Notes

- Only user databases are backed up (system databases like master, model, msdb, tempdb are excluded)
- The .bat version includes compression and file size reporting
- The .ps1 version is a simpler implementation without compression
- Both scripts skip offline databases

 Troubleshooting

Error: "Backup-SqlDatabase command not found"
- Install the SqlServer PowerShell module: `Install-Module -Name SqlServer`

Error: "Access denied to network path"
- Verify network share permissions
- Check network connectivity to the server

Error: "Cannot backup database"
- Ensure SQL Server service account has permissions
- Verify the database is online and accessible

 License

This project is provided as-is for database backup automation purposes.
