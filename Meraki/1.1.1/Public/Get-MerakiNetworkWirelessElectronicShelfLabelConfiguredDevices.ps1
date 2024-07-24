function Get-MerakiNetworkWirelessElectronicShelfLabelConfiguredDevices {
    <#
    .SYNOPSIS
    Retrieves the list of devices configured for electronic shelf label in a specific network.

    .DESCRIPTION
    This function allows you to retrieve the list of devices configured for electronic shelf label in a specific network by providing the authentication token and the network ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .EXAMPLE
    Get-MerakiNetworkWirelessElectronicShelfLabelConfiguredDevices -AuthToken "your-api-token" -NetworkId "L_123456789012345678"

    This example retrieves the list of devices configured for electronic shelf label in the network with the ID "L_123456789012345678".

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

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/electronicShelfLabel/configuredDevices"

        $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
