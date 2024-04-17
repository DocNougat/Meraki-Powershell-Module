function Invoke-MerakiDeviceLiveToolsPing {
    <#
    .SYNOPSIS
    Creates a ping test for a device using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiDeviceLiveToolsPing function allows you to create a ping test for a specified device by providing the authentication token, device serial number, and a ping configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device for which you want to create a ping test.

    .PARAMETER PingConfig
    A string containing the ping configuration. The string should be in JSON format and should include the "target" and "count" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        target = "75.75.75.75"
        count = 2
    }

    $config = $config | ConvertTo-Json -Compress
    Invoke-MerakiDeviceLiveToolsPing -AuthToken "your-api-token" -Serial "Q2HP-XXXX-XXXX" -PingConfig $config

    This example creates a ping test for the device with serial number "Q2HP-XXXX-XXXX", targeting the IP address "75.75.75.75" and sending 2 packets.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the ping test creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$Serial,
        [parameter(Mandatory=$true)]
        [string]$PingConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $PingConfig

        $uri = "https://api.meraki.com/api/v1/devices/$Serial/liveTools/ping"
        $response = Invoke-RestMethod -Method Post -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}