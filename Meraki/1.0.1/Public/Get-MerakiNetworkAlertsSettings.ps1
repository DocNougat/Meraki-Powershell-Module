function Get-MerakiNetworkAlertsSettings {
    <#
    .SYNOPSIS
    Retrieves the alert settings for a Meraki network.

    .DESCRIPTION
    This function retrieves the alert settings for a Meraki network using the Meraki Dashboard API. It requires an API key and a network ID.

    .PARAMETER AuthToken
    The API key for the Meraki Dashboard API.

    .PARAMETER NetworkID
    The ID of the network to retrieve the alert settings for.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkAlertsSettings -AuthToken "1234" -NetworkID "L_1234"

    Retrieves the alert settings for the network with ID "L_1234" using the API key "1234".

    .NOTES
    For more information about the Meraki Dashboard API, see https://developer.cisco.com/meraki/api-v1/.
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkID
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkID/alerts/settings" -Header $header
        return $response
    }
    catch {
        Write-Error $_
        return $null
    }
}
