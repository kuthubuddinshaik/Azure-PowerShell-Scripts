#script to resize a VM (change SKU) with pre/post validation of its running state


$vmname = (Read-Host "Enter the name of vm that you would like to resize:").ToLower()
$vm = Get-AzVM -Name $vmname -Status
$powerState = ($vm.Statuses | Where-Object Code -match "PowerState").DisplayStatus
Write-Host "The status of the vm is $powerState"

do {
    $vm = Get-AzVM -Name $vmname -Status
    $powerState = ($vm.Statuses | Where-Object Code -match "PowerState").DisplayStatus

    if ($powerState -notmatch "deallocated") {
        Write-Host "The VM is up and running. Would you like to deallocate the VM to proceed with SKU change?"
        $x = Read-Host "y/n:"
        if ($x -eq "y") {
            Write-Host "Deallocating the VM..."
            Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force
        } else {
            Write-Host "Exiting the program."
            exit
        }
    }
} until ($powerState -match "deallocated")

if ($powerState -match "deallocated") {
    Write-Host "Proceeding with SKU change y/n:"
    $y = Read-Host "y/n"
    if ($y -eq "y") {


        $location = $vm.Location
        Get-AzVMSize -Location $location | Sort-Object Name | Format-Table Name, NumberOfCores, MemoryInMB, MaxDataDiskCount -AutoSize

        Write-Host "Pick one from the list above."
        $size = Read-Host "Enter the size:"

        $validSize = Get-AzVMSize -Location $location | Where-Object Name -eq $size
        if (-not $validSize) {
            Write-Host "ERROR: '$size' is not a valid VM size for location '$location'. Exiting."
            exit
        }


        $vmObj = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
        $vmObj.HardwareProfile.VmSize = $size
        Update-AzVM -VM $vmObj -ResourceGroupName $vm.ResourceGroupName

        Write-Host "VM size has been updated! Restarting the VM now..."
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name

        $updatedVM  = Get-AzVM -Name $vmname -Status
        $finalState = ($updatedVM.Statuses | Where-Object Code -match "PowerState").DisplayStatus
        $finalSize  = (Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name).HardwareProfile.VmSize

        Write-Host "--- Post-resize validation ---"
        Write-Host "Power State : $finalState"
        Write-Host "VM Size     : $finalSize"

        if ($finalState -match "running" -and $finalSize -eq $size) {
            Write-Host "SUCCESS: VM is running with the new SKU '$size'."
        } else {
            Write-Host "WARNING: VM may not have resized correctly. Please verify in the portal."
        }

    } else {
        Write-Host "Exiting the code."
        exit
    }
}