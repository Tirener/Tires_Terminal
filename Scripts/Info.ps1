# Save to: SystemInfoGather.ps1
# Run as administrator for full info (optional)

Write-Host "`n===== SYSTEM INFORMATION =====`n"

# Basic System Info
Write-Host "Hostname:" $env:COMPUTERNAME
Write-Host "Username:" $env:USERNAME
Write-Host "Domain:" $env:USERDOMAIN
Write-Host "Architecture:" (Get-CimInstance Win32_OperatingSystem).OSArchitecture
Write-Host "Boot Time:" (Get-CimInstance Win32_OperatingSystem).LastBootUpTime

# OS Info
Write-Host "`n===== OS INFORMATION ====="
Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, InstallDate | Format-List

# CPU Info
Write-Host "`n===== CPU INFORMATION ====="
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed | Format-List

# RAM Info
Write-Host "`n===== MEMORY ====="
Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed | Format-Table -AutoSize
$totalRAM = [math]::round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
Write-Host "Total Installed RAM: $totalRAM GB"

# Disk Info
Write-Host "`n===== DISK DRIVES ====="
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | 
Select-Object DeviceID, VolumeName, FileSystem, @{Name="Size(GB)";Expression={"{0:N2}" -f ($_.Size/1GB)}}, @{Name="Free(GB)";Expression={"{0:N2}" -f ($_.FreeSpace/1GB)}} |
Format-Table -AutoSize

# Network Info
Write-Host "`n===== NETWORK INFORMATION ====="
Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.IPAddress -notlike '169.*' } |
Select-Object InterfaceAlias, IPAddress | Format-Table -AutoSize

Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4DefaultGateway, DNSServer | Format-Table -AutoSize

# Installed Software (Optional: Comment out if not needed)
Write-Host "`n===== INSTALLED PROGRAMS ====="
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* 2>$null |
Where-Object { $_.DisplayName } |
Select-Object DisplayName, DisplayVersion, Publisher |
Sort-Object DisplayName | Format-Table -AutoSize

Write-Host "`n===== END ====="
