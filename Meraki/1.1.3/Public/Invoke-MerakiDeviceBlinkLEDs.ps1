function Invoke-MerakiDeviceBlinkLEDs {
    <#
    .SYNOPSIS
    Blink the LEDs of a device in Meraki dashboard.

    .DESCRIPTION
    This function allows you to blink the LEDs of a device in Meraki dashboard.

    .PARAMETER AuthToken
    The authentication token for the Meraki API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER BlinkLEDConfig
    The JSON configuration for the LED blink. Refer to the JSON schema for required parameters and their format.

    .EXAMPLE
    $BlinkLEDConfig = [PSCustomObject]@{
        duration = 20
        period = 160
        duty = 50
    }
    $BlinkLEDConfig = ConvertTo-Json -Compress
    Invoke-MerakiDeviceBlinkLEDs -AuthToken "1234" -Serial "Q2HP-XXXX-XXXX" -BlinkLEDConfig $BlinkLEDConfig

    This example blinks the LEDs of the device with serial number 'Q2HP-XXXX-XXXX' with the specified configuration.

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$false)]
        [string]$BlinkLEDConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $BlinkLEDConfig

        $uri = "https://api.meraki.com/api/v1/devices/$DeviceSerial/blinkLeds"
        $response = Invoke-RestMethod -Method Post -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}