function Set-MerakiDeviceApplianceRadioSettings {
    <#
    .SYNOPSIS
    Updates the radio settings of a Meraki device using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiDeviceApplianceRadioSettings function allows you to update the radio settings of a specified Meraki device by providing the authentication token, device serial number, and a radio configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER DeviceSerial
    The serial number of the Meraki device for which you want to update the radio settings.

    .PARAMETER RadioConfig
    A string containing the radio configuration. The string should be in JSON format and should include the "rfProfileId", "twoFourGhzSettings", and "fiveGhzSettings" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        rfProfileId = "1234"
        twoFourGhzSettings = @{
            channel = 11
            targetPower = 21
        }
        fiveGhzSettings = @{
            channel = 149
            channelWidth = 20
            targetPower = 15
        }
    }
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiDeviceApplianceRadioSettings -AuthToken "your-api-token" -DeviceSerial "your-device-serial" -RadioConfig $config
    This example updates the radio settings of the Meraki device with serial number "your-device-serial", using the specified radio configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$RadioConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $RadioConfig

        $uri = "https://api.meraki.com/api/v1/devices/$DeviceSerial/appliance/radio/settings"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}