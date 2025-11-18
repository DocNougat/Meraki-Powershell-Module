function Invoke-MerakiUnenrollNetworkSmDevices {
    <#
    .SYNOPSIS
    Unenrolls a specific device from a network.

    .DESCRIPTION
    This function allows you to unenroll a specific device from a given network by providing the authentication token, network ID, and device ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER DeviceId
    The ID of the device to be unenrolled.

    .EXAMPLE
    Invoke-MerakiUnenrollNetworkSmDevices -AuthToken "your-api-token" -NetworkId "123456" -DeviceId "deviceId1"

    This example unenrolls the specified device from the network with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$DeviceId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/unenroll"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
