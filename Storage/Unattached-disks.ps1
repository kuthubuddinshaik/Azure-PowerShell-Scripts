#Fetch all disks that are **unattached** and output their name, size, and cost estimate

$disks = Get-AzDisk

if (-not $disks) {
    Write-Host "there are no disks, exiting"
    exit
}

foreach ($disk in $disks) {
    if (-not $disk.ManagedBy) {
        Write-Host "Name:$($disk.Name)"
        Write-Host "Location: $($disk.Location)"
        Write-Host "RG Name: $($disk.ResourceGroupName)"
        Write-Host "Size: $($disk.DiskSizeGB)"
        Write-Host "Attached: $($disk.ManagedBy)"
    }
}