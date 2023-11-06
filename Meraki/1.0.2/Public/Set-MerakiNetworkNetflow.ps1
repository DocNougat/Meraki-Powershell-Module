function Set-MerakiNetworkNetflow {
    <#
    .SYNOPSIS
    Updates the NetFlow settings for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkNetflow function allows you to update the NetFlow settings for a specified Meraki network by providing the authentication token, network ID, and a JSON string containing the NetFlow configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network in which the NetFlow settings are to be updated.

    .PARAMETER NetflowConfig
    A JSON string containing the NetFlow configuration. The JSON string should conform to the schema definition provided by the Meraki Dashboard API.

    .EXAMPLE
    $NetflowConfig = '{
        "collectorPort": 2055,
        "etaDstPort": 2056,
        "collectorIp": "192.168.1.1",
        "etaEnabled": true,
        "reportingEnabled": true
    }'
    $NetflowConfig = $NetflowConfig | ConvertTo-JSON -compress

    Set-MerakiNetworkNetflow -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -NetflowConfig $NetflowConfig

    This example updates the NetFlow settings for the Meraki network with ID "L_123456789012345678" by setting the NetFlow collector IP address to "192.168.1.1", the collector port to 2055, the Encrypted Traffic Analytics (ETA) destination port to 2056, and enabling both ETA and NetFlow traffic reporting.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the NetFlow settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$NetflowConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $NetflowConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/netflow"

        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
    }
}