function Invoke-MerakiRefreshNetworkSmDevices {
    <#
    .SYNOPSIS
    Refreshes the details of a specific device in a network.

    .DESCRIPTION
    This function allows you to refresh the details of a specific device in a given network by providing the authentication token, network ID, and device ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER DeviceId
    The ID of the device whose details are to be refreshed.

    .EXAMPLE
    Invoke-MerakiRefreshNetworkSmDevices -AuthToken "your-api-token" -NetworkId "123456" -DeviceId "deviceId1"

    This example refreshes the details of the specified device in the network with ID "123456".

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

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/refreshDetails"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
