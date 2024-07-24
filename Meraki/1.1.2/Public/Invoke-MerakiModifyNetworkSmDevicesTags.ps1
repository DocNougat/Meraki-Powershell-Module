function Invoke-MerakiModifyNetworkSmDevicesTags {
    <#
    .SYNOPSIS
    Modifies tags for devices in a network.

    .DESCRIPTION
    This function allows you to modify tags for devices in a given network by providing the authentication token, network ID, update action, and optional parameters for device IDs, scope, serials, tags, and wifi MAC addresses.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER UpdateAction
    One of add, delete, or update. Only devices that have been modified will be returned.

    .PARAMETER Ids
    The IDs of the devices to be modified.

    .PARAMETER Scope
    The scope (one of all, none, withAny, withAll, withoutAny, or withoutAll) and a set of tags of the devices to be modified.

    .PARAMETER Serials
    The serials of the devices to be modified.

    .PARAMETER Tags
    The tags to be added, deleted, or updated.

    .PARAMETER WifiMacs
    The wifi MAC addresses of the devices to be modified.

    .EXAMPLE
    $DeviceIds = @("deviceId1", "deviceId2")
    $Tags = @("tag1", "tag2")
    Invoke-MerakiModifyNetworkSmDevicesTags -AuthToken "your-api-token" -NetworkId "123456" -UpdateAction "add" -Ids $DeviceIds -Tags $Tags

    This example adds the specified tags to the devices in the network with ID "123456".

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
        [string]$UpdateAction,
        [parameter(Mandatory=$true)]
        [string[]]$Tags,
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
            updateAction = $UpdateAction
            tags = $Tags
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

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/modifyTags"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
