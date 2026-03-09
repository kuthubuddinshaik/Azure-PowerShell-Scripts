#script to check VM CPU metrics
$rgname = Read-Host "Enter the Resource Group Name"

$vms = Get-AzVM -ResourceGroupName $rgname

$startdate = (Get-Date).AddDays(-1)
$enddate = Get-Date

foreach($vm in $vms){

    Write-Host "Fetching metrics for VM: $($vm.Name)"

    $metrics = Get-AzMetric `
        -ResourceId $vm.Id `
        -MetricName "Percentage CPU" `
        -StartTime $startdate `
        -EndTime $enddate `
        -AggregationType Average

    foreach($metric in $metrics){

        foreach($data in $metric.Data){

            Write-Output "VM: $($vm.Name) | Time: $($data.TimeStamp) | Avg CPU: $($data.Average)"

        }

    }

}