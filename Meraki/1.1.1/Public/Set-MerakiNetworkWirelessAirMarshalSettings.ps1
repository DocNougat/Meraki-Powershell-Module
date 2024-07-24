function Set-MerakiNetworkWirelessAirMarshalSettings {
    <#
    .SYNOPSIS
    Updates the Air Marshal settings for a network.

    .DESCRIPTION
    This function allows you to update the Air Marshal settings for a network by providing the authentication token, network ID, and settings configuration.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER SettingsConfig
    A string containing the settings configuration in JSON format.

    .EXAMPLE
    $settingsConfig = [PSCustomObject]@{
        defaultPolicy = "block"
    } | ConvertTo-Json -Compress

    Set-MerakiNetworkWirelessAirMarshalSettings -AuthToken "your-api-token" -NetworkId "N_123456789012345678" -SettingsConfig $settingsConfig

    This example updates the Air Marshal settings for the network with ID "N_123456789012345678".
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SettingsConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $SettingsConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/airMarshal/settings"

        $response = Invoke-RestMethod -Method Put -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
