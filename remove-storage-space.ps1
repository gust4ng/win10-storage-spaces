#Variables names here MUST MATCH create-storage-space.ps1
$StoragePoolName = "My Storage Pool"
$SSDTierName = "SSDTier"
$HDDTierName = "HDDTier"
$TieredDiskName = "My Tiered VirtualDisk"

# In reverse order of creation
if ((Get-VirtualDisk -FriendlyName $TieredDiskName) -ne $null){
    Write-Output "Removing drive: $TieredDiskName"
    Get-VirtualDisk -FriendlyName $TieredDiskName
    Remove-virtualdisk -friendlyName $TieredDiskName -Confirm:$false
} else {
    Write-Output "Drive does not exist: $TieredDiskName"
}

# Remove Storage Tier
if ((Get-StorageTier -FriendlyName $HDDTierName) -ne $null){
    Write-Output "Removing storage tiers: $HDDTierName"
    Get-StorageTier -FriendlyName $HDDTierName | FT FriendlyName, MediaType, Size -AutoSize
    Remove-StorageTier -FriendlyName $HDDTierName -Confirm:$false
} else {
    Write-Output "Tier does not exist: $HDDTierName"
}
if ((Get-StorageTier -FriendlyName $SSDTierName) -ne $null){
    Write-Output "Removing storage tiers: $SSDTierName"
    Get-StorageTier -FriendlyName $SSDTierName | FT FriendlyName, MediaType, Size -AutoSize
    Remove-StorageTier -FriendlyName $SSDTierName -Confirm:$false
} else {
    Write-Output "Tier does not exist: $SSDTierName"
}
Get-StorageTier

# Remove the Storage Pool
if ((Get-StoragePool -FriendlyName $StoragePoolName) -ne $null){
    Write-Output "Removing storage pool: $StoragePoolName"
    Get-StoragePool -FriendlyName $StoragePoolName | Get-PhysicalDisk | FT FriendlyName, MediaType
    Remove-StoragePool -FriendlyName $StoragePoolName -Confirm:$false
} else {
    Write-Output "Storage Pool does not exist: $StoragePoolName"
}
# Show just the primoridal pool
Write-Output "Poolable drives after cleanup"
Get-StoragePool | Get-PhysicalDisk -CanPool:$True

Write-Output "Operation complete"