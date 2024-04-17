function Get-MerakiNetworkApplianceSsid {
    <#
    .SYNOPSIS
    Gets the configuration for a Meraki network's SSID.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve the configuration for a Meraki network's SSID.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose SSID configuration is being retrieved.
    .PARAMETER SSIDNumber
    The number of the SSID whose configuration is being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceSsid -AuthToken '1234' -NetworkId '5678' -SSIDNumber '1'
    Retrieves the configuration for SSID number '1' in the Meraki network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$SSIDNumber
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/ssids/$SSIDNumber" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
