#List all NSG rules across all VNets in a subscription and flag any that allow inbound `0.0.0.0/0`

$subs = Get-AzSubscription

if(-not $subs){
    Write-Host "There are no subscriptions. Exiting."
    exit
}

foreach($sub in $subs){

    Set-AzContext -Subscription $sub.Id | Out-Null

    $nsgs = Get-AzNetworkSecurityGroup

    if(-not $nsgs){
        Write-Host "No NSGs found in subscription $($sub.Name)"
        continue
    }

    foreach($nsg in $nsgs){

        foreach($rule in $nsg.SecurityRules){

            if($rule.Direction -eq "Inbound" -and
               $rule.Access -eq "Allow" -and
               ($rule.SourceAddressPrefix -eq "0.0.0.0/0" -or $rule.SourceAddressPrefix -eq "*")){

                Write-Host "Insecure Rule Found"

                [PSCustomObject]@{
                    Subscription = $sub.Name
                    NSG          = $nsg.Name
                    RuleName     = $rule.Name
                    Source       = $rule.SourceAddressPrefix
                    Destination  = $rule.DestinationAddressPrefix
                    Port         = $rule.DestinationPortRange
                }

            }

        }

    }

}