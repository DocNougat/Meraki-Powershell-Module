function Invoke-MerakiDeviceLiveToolsPingDevice {
    <#
    .SYNOPSIS
    Creates a ping test for a device using the Meraki Dashboard API.

    .DESCRIPTION
    The Invoke-MerakiDeviceLiveToolsPingDevice function allows you to create a ping test for a specified device by providing the authentication token, device serial number, and an optional count of packets to send.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device for which you want to create a ping test.

    .PARAMETER Count
    The number of packets to send in the ping test. This parameter is optional.

    .EXAMPLE
    Invoke-MerakiDeviceLiveToolsPingDevice -AuthToken "your-api-token" -Serial "Q2HP-XXXX-XXXX" -Count 2

    This example creates a ping test for the device with serial number "Q2HP-XXXX-XXXX", sending 2 packets.

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
        [parameter(Mandatory=$false)]
        [int]$Count
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        if ($Count) {
            $body = @{
                "count" = $Count
            } | ConvertTo-Json -Compress
        }

        $uri = "https://api.meraki.com/api/v1/devices/$Serial/liveTools/pingDevice"
        if ($Count) {
            $response = Invoke-RestMethod -Method Post -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
        } else {
            $response = Invoke-RestMethod -Method Post -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        }
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}