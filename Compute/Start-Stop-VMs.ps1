#Start or Stop a VM based on user input, with confirmation prompts

$vmname = Read-Host "Enter the Name of the VM that you would like to start or stop"

$vm = Get-AzVM -Name $vmname -Status

if(-not $vm){
    Write-Warning "No VM with the name"
    exit
}

Write-Host "VM has been found $($vm.Name) | $($vm.ResourceGroupName) | $($vm.PowerState)"

$operation = (Read-Host "What would you like to perform start/stop").ToLower()

if($operation -notin @("start","stop")){
    Write-Warning "Invalid Input $operation Please enter start or stop"
    exit
}

$confirm =(Read-Host "Are you sure you would like to perform $operation on $($vm.Name) - yes/no").TOLower()

if($confirm -eq "no"){
    Write-Warning "Operation has been cancelled"
    exit
}

if($operation -eq "start"){
    if($vm.PowerState -match "dealloc"){
        Write-Host "VM is deallocated, starting the VM"
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
        Write-Host "$($vm.Name) has been started successfully"
    }else{
        Write-Host "$($vm.Name) is already running. No action take"
    }
}elseif ($operation -eq "stop") {
    if($vm.PowerState -match "runn"){
        Write-Host "VM is running, stopping the VM"
        Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force
        Write-Host "$($vm.Name) has been stopped"
    }else{
        Write-Host "VM is already deallocated. No action take"
    }
}
