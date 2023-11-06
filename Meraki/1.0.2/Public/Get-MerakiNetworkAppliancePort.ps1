function Get-MerakiNetworkAppliancePort {
    <#
    .SYNOPSIS
    Gets information about a specific port on a Meraki network's appliance.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve information about a specific port on a Meraki network's appliance.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose appliance port information is being retrieved.
    .PARAMETER PortId
    The ID of the Meraki network's appliance port being retrieved.
    .EXAMPLE
    Get-MerakiNetworkAppliancePort -AuthToken '1234' -NetworkId '5678' -PortId '1'
    Retrieves information about the Meraki network's appliance port with ID '1' for the network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$PortId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/ports/$PortId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Error "An error occurred while retrieving information for port '$PortId' on network '$NetworkId': $_"
    }
}
