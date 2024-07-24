function Get-MerakiDeviceWirelessElectronicShelfLabel {
    <#
    .SYNOPSIS
    Retrieves the electronic shelf label settings for a specific device.

    .DESCRIPTION
    This function allows you to retrieve the electronic shelf label settings for a specific device by providing the authentication token and the device serial.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .EXAMPLE
    Get-MerakiDeviceWirelessElectronicShelfLabel -AuthToken "your-api-token" -Serial "Q2XX-1234-ABCD"

    This example retrieves the electronic shelf label settings for the device with the serial number "Q2XX-1234-ABCD".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$Serial
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$Serial/wireless/electronicShelfLabel"

        $response = Invoke-RestMethod -Method Get -Uri $url -Headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
