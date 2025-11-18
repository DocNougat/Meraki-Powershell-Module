function Invoke-MerakiMoveNetworkSmDevices {
    <#
    .SYNOPSIS
    Moves devices to a new network.

    .DESCRIPTION
    This function allows you to move devices to a new network by providing the authentication token, network ID, the new network ID, and optional parameters for device IDs, scope, serials, and wifi MAC addresses.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the current network.

    .PARAMETER NewNetwork
    The new network to which the devices will be moved.

    .PARAMETER Ids
    The IDs of the devices to be moved.

    .PARAMETER Scope
    The scope (one of all, none, withAny, withAll, withoutAny, or withoutAll) and a set of tags of the devices to be moved.

    .PARAMETER Serials
    The serials of the devices to be moved.

    .PARAMETER WifiMacs
    The wifi MAC addresses of the devices to be moved.

    .EXAMPLE
    $DeviceIds = @("deviceId1", "deviceId2")
    Invoke-MerakiMoveNetworkSmDevices -AuthToken "your-api-token" -NetworkId "123456" -NewNetwork "654321" -Ids $DeviceIds

    This example moves the specified devices from the network with ID "123456" to the network with ID "654321".

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
        [string]$NewNetwork,
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

        $body = @{
            newNetwork = $NewNetwork
        }

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

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/move"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}