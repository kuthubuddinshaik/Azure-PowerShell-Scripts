#Automate snapshot creation for all managed disks in a Resource Group with a timestamp-based naming convention

$rgName = Read-Host "Enter the name of the RG"

$disks = Get-AzDisk -ResourceGroupName $rgName

if(-not $disks){
    
    Write-Host "There are no disks in this RG"
    exit
}

$timestamp = Get-Date -Format "yyyyMMddHHmm"

foreach($disk in $disks){

    $snapshotConfig = New-AzSnapshotConfig `
        -SourceResourceId $disk.Id `
        -Location $disk.Location `
        -CreateOption Copy

    $snapshotName = "$($disk.Name)-snapshot-$timestamp"

    New-AzSnapshot `
        -Snapshot $snapshotConfig `
        -SnapshotName $snapshotName `
        -ResourceGroupName $rgName

    Write-Host "Snapshot created for disk: $($disk.Name)"
}