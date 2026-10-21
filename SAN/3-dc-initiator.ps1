# Maarten ter Harmsel
# Studentnummer: 587328
# Week 7 - SAN, stap 3: iSCSI Initiator op SXN-DC-01, schijf S: en een bestand opslaan
# Gemaakt met hulp van Claude (Anthropic), 19-20 oktober 2026
# Draaien op: SXN-DC-01, als Administrator

$SanIP = "10.21.2.110"

# iSCSI Initiator-service aan, ook na een herstart
Set-Service MSiSCSI -StartupType Automatic
Start-Service MSiSCSI

# De SAN toevoegen als target portal en verbinden
New-IscsiTargetPortal -TargetPortalAddress $SanIP
Get-IscsiTarget
Connect-IscsiTarget -NodeAddress (Get-IscsiTarget).NodeAddress -IsPersistent $true

# De nieuwe iSCSI-schijf klaarmaken als S:
Start-Sleep -Seconds 5
$schijf = Get-Disk | Where-Object BusType -eq "iSCSI"
if ($schijf.IsOffline) { $schijf | Set-Disk -IsOffline $false }
if ($schijf.PartitionStyle -eq "RAW") {
  $schijf | Initialize-Disk -PartitionStyle GPT -PassThru |
    New-Partition -DriveLetter S -UseMaximumSize |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel "SAN-587328" -Confirm:$false
}

# Een bestand op de SAN zetten
"Opgeslagen op de SAN door Maarten ter Harmsel 587328 op $(Get-Date)" | Out-File S:\bewijs-587328.txt
Get-Content S:\bewijs-587328.txt

# Controle
Get-IscsiSession | Format-List TargetNodeAddress, IsConnected, IsPersistent
Get-Disk | Where-Object BusType -eq "iSCSI" | Format-Table Number, FriendlyName, BusType, Size, OperationalStatus
