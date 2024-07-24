function Set-MerakiNetworkWirelessElectronicShelfLabel {
    <#
    .SYNOPSIS
    Updates the electronic shelf label settings for a specific network.

    .DESCRIPTION
    This function allows you to update the electronic shelf label settings for a specific network by providing the authentication token, network ID, and the configuration as a JSON string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER RuleConfig
    A JSON string containing the configuration for the electronic shelf label settings.

    .EXAMPLE
    $config = [PSCustomObject]@{
        hostname = "esl.network"
        enabled = $true
    } | ConvertTo-Json -Compress

    Set-MerakiNetworkWirelessElectronicShelfLabel -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -RuleConfig $config

    This example updates the electronic shelf label settings for the network with the ID "L_123456789012345678".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$RuleConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RuleConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/electronicShelfLabel"

        $response = Invoke-RestMethod -Method Put -Uri $url -Headers $header -Body $body -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
