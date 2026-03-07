#List all VMs across all Resource Groups in a subscription with their sizes and power states

$subs = Get-AzSubscription

if (-not $subs) {
    Write-Warning "No subscriptions found."
    exit
}

$results = @()

foreach ($sub in $subs) {
    Set-AzContext -SubscriptionId $sub.Id | Out-Null
    Write-Host "`n=== Subscription: $($sub.Name) ===" -ForegroundColor Cyan

    $rgs = Get-AzResourceGroup

    if (-not $rgs) {
        Write-Warning "No Resource Groups found in: $($sub.Name)"
        continue
    }

    foreach ($rg in $rgs) {
        $vms = Get-AzVM -ResourceGroupName $rg.ResourceGroupName -Status

        if (-not $vms) {
            Write-Host "  No VMs in RG: $($rg.ResourceGroupName)" -ForegroundColor Yellow
            continue
        }

        foreach ($vm in $vms) {
            $results += [PSCustomObject]@{ 
                Subscription  = $sub.Name
                ResourceGroup = $rg.ResourceGroupName
                VMName        = $vm.Name
                Size          = $vm.HardwareProfile.VmSize
                PowerState    = $vm.PowerState
            }
        }
    }
}

$results | Format-Table -AutoSize