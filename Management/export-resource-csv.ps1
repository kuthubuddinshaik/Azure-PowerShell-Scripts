#Export all Azure resources in a subscription to a CSV file
$subs = Get-AzSubscription

if(-not $subs){
    Write-Host "There are no subscriptions"
    exit
}

$result = @()

foreach($sub in $subs){
    Set-AzContext -Subscription $sub.Id | Out-Null

    $resources = Get-AzResource

    if(-not $resources){
        Write-Host "There are no resources in this subscription $($sub.Name)"
        continue
    }

    foreach($res in $resources){
        $result+=[PSCustomObject]@{
            Name = $res.Name
            ResourceGroupName = $res.ResourceGroupName
            Type = $res.ResourceType
            Location = $res.Location
        }
    }
}

$result | Export-Csv -Path ".../AzResources.csv"