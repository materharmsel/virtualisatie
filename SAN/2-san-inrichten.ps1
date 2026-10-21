# Maarten ter Harmsel
# Studentnummer: 587328
# Week 7 - SAN, stap 2: netwerk, iSCSI Target Server, LUN, en NFS/SMB uit
# Gemaakt met hulp van Claude (Anthropic), 19-20 oktober 2026
# Draaien op: SXN-SAN-587328, als Administrator
#
# De SAN deelt opslag als blokken via iSCSI (target).
# De initiator is de domain controller SXN-DC-01 (10.21.2.101).

$SanIP  = "10.21.2.110"
$DcIP   = "10.21.2.101"
$Target = "target-587328"
$Lun    = "E:\iSCSI\lun-587328.vhdx"

# --- 1. Netwerk ---------------------------------------------------------
# De kaart op het netwerk "CCS Virtualisatie" is de kaart zonder default gateway
# (de andere kaart is NAT en krijgt via DHCP een gateway).
$kaart = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -eq $null -and $_.NetAdapter.Status -eq "Up" } | Select-Object -First 1
$naam  = $kaart.InterfaceAlias
Write-Host "Kaart op 10.21.2.x: $naam"

Get-NetIPAddress -InterfaceAlias $naam -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetIPAddress -Confirm:$false
Set-NetIPInterface -InterfaceAlias $naam -Dhcp Disabled
New-NetIPAddress -InterfaceAlias $naam -IPAddress $SanIP -PrefixLength 24 | Out-Null
Set-DnsClientServerAddress -InterfaceAlias $naam -ServerAddresses $DcIP

# Ping blijft toegestaan, ook als File and Printer Sharing straks uit staat
New-NetFirewallRule -DisplayName "Ping toestaan 587328" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow | Out-Null

# --- 2. iSCSI Target Server ----------------------------------------------
Install-WindowsFeature FS-iSCSITarget-Server -IncludeManagementTools

# Poort 3260 open voor iSCSI
New-NetFirewallRule -DisplayName "iSCSI Target 587328 (TCP 3260)" -Protocol TCP -LocalPort 3260 -Direction Inbound -Action Allow | Out-Null

# --- 3. Tweede schijf klaarmaken als E: ----------------------------------
Get-Disk | Where-Object IsOffline -eq $true | Set-Disk -IsOffline $false
Get-Disk | Where-Object PartitionStyle -eq "RAW" |
  Initialize-Disk -PartitionStyle GPT -PassThru |
  New-Partition -DriveLetter E -UseMaximumSize |
  Format-Volume -FileSystem NTFS -NewFileSystemLabel "SAN-587328" -Confirm:$false

New-Item -ItemType Directory -Path E:\iSCSI -Force | Out-Null

# --- 4. LUN en target ----------------------------------------------------
New-IscsiVirtualDisk -Path $Lun -SizeBytes 5GB
New-IscsiServerTarget -TargetName $Target -InitiatorIds "IPAddress:$DcIP"
Add-IscsiVirtualDiskTargetMapping -TargetName $Target -Path $Lun

# --- 5. NFS en SMB uit ---------------------------------------------------
# NFS: de rol wordt niet geinstalleerd (Install State moet "Available" zijn)
Get-WindowsFeature FS-NFS-Service, NFS-Client

# SMB: SMB 1 en SMB 2/3 uit op de server, en de firewall dicht voor bestandsdeling
Set-SmbServerConfiguration -EnableSMB1Protocol $false -EnableSMB2Protocol $false -Force
Disable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

# --- 6. Controle ---------------------------------------------------------
hostname
Get-NetIPAddress -InterfaceAlias $naam -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress, PrefixLength
Get-IscsiServerTarget | Format-List TargetName, TargetIqn, InitiatorIds, Status, LunMappings
Get-IscsiVirtualDisk | Format-List Path, Size, Status
Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol, EnableSMB2Protocol
Test-Connection $DcIP -Count 2
