function Get-MerakiDeviceLiveToolsWakeOnLan {
    <#
    .SYNOPSIS
    Retrieves the details of a Wake-on-LAN action for a specified device.

    .DESCRIPTION
    This function allows you to retrieve the details of a Wake-on-LAN action for a specified device by providing the authentication token, device serial number, and the Wake-on-LAN ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER Serial
    The serial number of the device.

    .PARAMETER WakeOnLanId
    The ID of the Wake-on-LAN action.

    .EXAMPLE
    Get-MerakiDeviceLiveToolsWakeOnLan -AuthToken "your-api-token" -Serial "Q2XX-XXXX-XXXX" -WakeOnLanId "wakeOnLanId1"

    This example retrieves the details of the Wake-on-LAN action with ID "wakeOnLanId1" for the device with serial number "Q2XX-XXXX-XXXX".

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
        [string]$WakeOnLanId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/liveTools/wakeOnLan/$WakeOnLanId"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
