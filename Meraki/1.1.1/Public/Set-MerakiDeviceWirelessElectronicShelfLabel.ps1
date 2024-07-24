function Set-MerakiDeviceWirelessElectronicShelfLabel {
    <#
    .SYNOPSIS
    Updates the electronic shelf label settings for a specific device.

    .DESCRIPTION
    This function allows you to update the electronic shelf label settings for a specific device by providing the authentication token, device serial, and the configuration as a JSON string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER RuleConfig
    A JSON string containing the configuration for the electronic shelf label settings.

    .EXAMPLE
    $config = [PSCustomObject]@{
        channel = "Auto"
        enabled = $true
    } | ConvertTo-Json -Compress

    Set-MerakiDeviceWirelessElectronicShelfLabel -AuthToken "your-api-token" -Serial "Q2XX-1234-ABCD" -RuleConfig $config

    This example updates the electronic shelf label settings for the device with the serial number "Q2XX-1234-ABCD".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$Serial,
        [parameter(Mandatory=$true)]
        [string]$RuleConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RuleConfig

        $url = "https://api.meraki.com/api/v1/devices/$Serial/wireless/electronicShelfLabel"

        $response = Invoke-RestMethod -Method Put -Uri $url -Headers $header -Body $body -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
