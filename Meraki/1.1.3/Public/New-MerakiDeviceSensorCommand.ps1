function New-MerakiDeviceSensorCommand {
    <#
    .SYNOPSIS
    Sends a command to a sensor device.

    .DESCRIPTION
    This function allows you to send a command to a sensor device by providing the authentication token, device serial number, and a JSON string with the command details.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER CommandDetails
    A compressed JSON string representing the command details.

    .EXAMPLE
    $CommandDetails = @{
        operation = "refreshData"
    }
    $CommandDetailsJson = $CommandDetails | ConvertTo-Json -Compress -Depth 4
    New-MerakiDeviceSensorCommand -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -CommandDetails $CommandDetailsJson

    This example sends a command to refresh data on the sensor device with serial number "Q2XX-XXXX-XXXX".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$DeviceSerial,
        [parameter(Mandatory=$true)]
        [string]$CommandDetails
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/sensor/commands"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $CommandDetails
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
