function Get-MerakiNetworkClientSplashAuthorization {
    <#
    .SYNOPSIS
    Retrieve the splash authorization status for a client on a Meraki network.

    .DESCRIPTION
    This function retrieves the splash authorization status for a specific client on a Meraki network. The function requires the network ID and client ID as mandatory parameters, and the Meraki API token as an authentication parameter.

    .PARAMETER AuthToken
    The Meraki API token for authentication.

    .PARAMETER NetworkID
    The Meraki network ID.

    .PARAMETER ClientID
    The Meraki client ID.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkClientSplashAuthorization -AuthToken "12345" -NetworkID "N_1234567890" -ClientID "1234567890"

    This example retrieves the splash authorization status for a client with ID "1234567890" on the Meraki network with ID "N_1234567890" using the Meraki API token "12345".

    .NOTES
    For more information on the Meraki Dashboard API, visit: https://developer.cisco.com/meraki/api-v1/

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkID,
        [parameter(Mandatory=$true)]
        [string]$ClientID
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkID/clients/$ClientID/splashAuthorizationStatus" -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}