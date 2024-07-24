function Invoke-MerakiCheckinNetworkSmDevices {
    <#
    .SYNOPSIS
    Checks in devices in a network.

    .DESCRIPTION
    This function allows you to check in devices in a given network by providing the authentication token, network ID, and optional parameters for device IDs, scope, serials, and wifi MAC addresses.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER Ids
    The IDs of the devices to be checked-in.

    .PARAMETER Scope
    The scope (one of all, none, withAny, withAll, withoutAny, or withoutAll) and a set of tags of the devices to be checked-in.

    .PARAMETER Serials
    The serials of the devices to be checked-in.

    .PARAMETER WifiMacs
    The wifi MAC addresses of the devices to be checked-in.

    .EXAMPLE
    $DeviceIds = @("deviceId1", "deviceId2")
    $Serials = @("serial1", "serial2")
    Invoke-MerakiCheckinNetworkSmDevices -AuthToken "your-api-token" -NetworkId "123456" -Ids $DeviceIds -Serials $Serials

    This example checks in the specified devices in the network with ID "123456".

    .NOTES
    For more information about the Meraki API, visit https://developer.cisco.com/meraki/api-v1/.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$false)]
        [string[]]$Ids,
        [parameter(Mandatory=$false)]
        [string[]]$Scope,
        [parameter(Mandatory=$false)]
        [string[]]$Serials,
        [parameter(Mandatory=$false)]
        [string[]]$WifiMacs
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{}

        if ($Ids) {
            $body.ids = $Ids
        }

        if ($Scope) {
            $body.scope = $Scope
        }

        if ($Serials) {
            $body.serials = $Serials
        }

        if ($WifiMacs) {
            $body.wifiMacs = $WifiMacs
        }

        $bodyJson = $body | ConvertTo-Json -Compress

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/checkin"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
