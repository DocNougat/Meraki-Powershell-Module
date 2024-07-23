function Get-MerakiNetworkApplianceSsids {
    <#
    .SYNOPSIS
    Gets a list of the SSIDs configured for a Meraki network's appliance.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve a list of the SSIDs configured for a Meraki network's appliance.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose SSIDs are being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceSsids -AuthToken '1234' -NetworkId '5678'
    Retrieves a list of the SSIDs configured for the Meraki network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/ssids" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
