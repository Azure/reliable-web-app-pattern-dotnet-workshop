# add synopsis, description, example, notes block
<#
.SYNOPSIS
This script will show the Front Door URI for the first endpoint in the first Front Door profile in the specified resource group.

.DESCRIPTION
This script will show the Front Door URI for the first endpoint in the first Front Door profile in the specified resource group.

.EXAMPLE
ShowFrontDoorUri.ps1 -ResourceGroupName "MyResourceGroup"

.NOTES
This script requires the Azure CLI to be installed.
    
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $ResourceGroupName
)

# Check if resource group exists
$resourceGroupExists = az group exists --name $ResourceGroupName
if ($resourceGroupExists -eq "false") {
    Write-Error "Resource group $ResourceGroupName does not exist."
    exit
}

$frontDoorProfileName = az resource list --resource-group $ResourceGroupName --query "[? type=='Microsoft.Cdn/profiles'].name" -o tsv

$frontDoorEndpoint = az afd endpoint list --profile-name $frontDoorProfileName --resource-group $ResourceGroupName --query "[0].hostName" -o tsv --only-show-errors

Write-Host "Front Door URI: https://$frontDoorEndpoint"