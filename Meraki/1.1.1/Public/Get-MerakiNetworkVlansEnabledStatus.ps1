function Get-MerakiNetworkVlansEnabledStatus {
    <#
    .SYNOPSIS
    Retrieves the VLANs enabled state for a specified network.

    .DESCRIPTION
    This function allows you to retrieve the VLANs enabled state for a specified network by providing the authentication token and network ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .EXAMPLE
    Get-MerakiNetworkVLANSEnabledStatus -AuthToken "your-api-token" -NetworkId "N_123456"

    This example retrieves the VLANs enabled state for the network with ID "N_123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/vlansEnabledState"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
