function Get-MerakiNetworkWirelessSsids {
    <#
    .SYNOPSIS
    Retrieves a list of SSIDs for a given network.

    .DESCRIPTION
    This function retrieves a list of SSIDs for a given network using the Meraki Dashboard API.

    .PARAMETER AuthToken
    The Meraki Dashboard API key.

    .PARAMETER networkId
    The ID of the network.

    .EXAMPLE
    Get-MerakiNetworkWirelessSsids -AuthToken $AuthToken -networkId $networkId

    This example retrieves a list of SSIDs for the specified network.

    .NOTES
    For more information about the Meraki Dashboard API, visit https://developer.cisco.com/meraki/api/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$networkId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
       
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/wireless/ssids" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
