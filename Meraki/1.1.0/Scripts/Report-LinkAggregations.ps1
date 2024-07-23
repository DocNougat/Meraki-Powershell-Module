<#
.SYNOPSIS
    Generates a report of link aggregations for Meraki switch networks.

.DESCRIPTION
    This script retrieves link aggregation information for Meraki switch networks and generates a report in CSV format.

.PARAMETER APIKey
    The API key used to authenticate with the Meraki Dashboard API.

.PARAMETER CSVExportPath
    The path where the generated CSV report will be saved.

.EXAMPLE
    Report-LinkAggregations -APIKey "your-api-key" -CSVExportPath "C:\Reports\LinkAggregations.csv"
    Generates a report of link aggregations for Meraki switch networks using the specified API key and saves it to the specified CSV file.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$APIKey,
    [Parameter(Mandatory = $true)]
    [string]$CSVExportPath
)

$Networks = Get-MerakiOrganizationNetworks -AuthToken $APIKey | Where-Object {$_.productTypes -contains 'switch'}
$Report = @()

ForEach($Network in $Networks){
    $NetworkName = $Network.name
    $NetworkID = $Network.id
    $LinkAggregations = Get-MerakiNetworkSwitchLinkAggregations -AuthToken $APIKey -networkId $NetworkID

    If($LinkAggregations.count -gt 0){
        Write-Host "Network: $NetworkName" -BackgroundColor DarkGreen
        Write-Host "ID: $NetworkID"

        ForEach($LinkAggregation in $LinkAggregations){
            $LinkID = $LinkAggregation.id
            $SwitchPorts = $LinkAggregation.switchPorts

            Write-Host "Link Aggregation: $LinkID"
            Write-Host "Aggregated Ports:"

            ForEach($Port in $SwitchPorts){
                Write-Host "Switch: $($Port.serial) - Port: $($Port.portId)"

                $Report += [PSCustomObject]@{
                    NetworkName = $NetworkName
                    NetworkID = $NetworkID
                    LinkAggregationID = $LinkID
                    Switch = $Port.serial
                    Port = $Port.portId
                }
            }
        }
    }
}

$Report | Export-CSV $CSVExportPath -NoTypeInformation