# Create a new Resource Group and deploy a storage account with specific redundancy settings

$locs = @("east us", "west us", "canada central", "north europe", "southeast asia")

# Resource Group 
$rgName = (Read-Host "Enter the name for the Resource Group").ToLower()

$location = (Read-Host "Enter the Location for the Resource Group (e.g. east us, west us)").ToLower()

if ($location -notin $locs) {
    Write-Warning "Invalid location '$location'. Exiting."
    exit
}

$confirmRG = (Read-Host "Confirm creating RG '$rgName' in '$location' (yes/no)").ToLower()
if ($confirmRG -ne "yes") {
    Write-Host "RG creation cancelled." -ForegroundColor Yellow
    exit
}

$rg = New-AzResourceGroup -Name $rgName -Location $location

if (-not $rg) {
    Write-Warning "Failed to create Resource Group. Exiting."
    exit
}

Write-Host "Resource Group '$rgName' created successfully." -ForegroundColor Green

# Storage Account
$saName     = (Read-Host "Enter the name for the Storage Account").ToLower()
$saLocation = (Read-Host "Enter the location for the Storage Account").ToLower()


if ($saLocation -notin $locs) {
    Write-Warning "Invalid location '$saLocation'. Exiting."
    exit
}

$skuOptions = @("Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS")

Write-Host "`nAvailable Redundancy Options:" -ForegroundColor Cyan
$skuOptions | ForEach-Object { Write-Host "  - $_" }

$sku = (Read-Host "Enter the redundancy SKU").ToUpper()

if ($sku -notin $skuOptions) {
    Write-Warning "Invalid SKU '$sku'. Exiting."
    exit
}

$confirmSA = (Read-Host "Confirm creating SA '$saName' in '$saLocation' with SKU '$sku' (yes/no)").ToLower()

if ($confirmSA -ne "yes") {
    Write-Host "Storage Account creation cancelled." -ForegroundColor Yellow
    exit
}


New-AzStorageAccount -ResourceGroupName $rgName `
                     -Name $saName `
                     -Location $saLocation `
                     -SkuName $sku

Write-Host "Storage Account '$saName' created successfully with SKU: $sku" -ForegroundColor Green