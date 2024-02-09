function Set-MerakiDevice {
    <#
    .SYNOPSIS
    Updates a device in the Meraki Dashboard using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiDevice function allows you to update a device in the Meraki Dashboard by providing the authentication token, device serial number, and a device configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER DeviceSerial
    The serial number of the device you want to update.

    .PARAMETER DeviceConfig
    A string containing the device configuration. The string should be in JSON format and should include the following properties: "address", "floorPlanId", "name", "notes", "switchProfileId", "moveMapMarker", "lat", "lng", and "tags".

    .EXAMPLE
    $config = [PSCustomObject]@{
        address = "123 Main St"
        floorPlanId = "123456"
        name = "My Device"
        notes = "This is my device"
        switchProfileId = "789012"
        moveMapMarker = $true
        lat = 37.7749
        lng = -122.4194
        tags = @("tag1", "tag2")
    }

    $config = $config | ConvertTo-Json -Compress
    Set-MerakiDevice -AuthToken "your-api-token" -DeviceSerial "Q2HP-XXXX-XXXX" -DeviceConfig $config

    This example updates the device with serial number "Q2HP-XXXX-XXXX" in the Meraki Dashboard with the specified configuration.

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
        [string]$DeviceConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $DeviceConfig

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial"

        $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}