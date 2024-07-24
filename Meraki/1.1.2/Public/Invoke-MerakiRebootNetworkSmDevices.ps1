function Invoke-MerakiRebootNetworkSmDevices {
    <#
    .SYNOPSIS
    Reboots devices in a network.

    .DESCRIPTION
    This function allows you to reboot devices in a given network by providing the authentication token, network ID, and optional parameters for notifying the user, rebuilding the kernel cache, requiring network tethering, device IDs, scope, serials, and wifi MAC addresses.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER NotifyUser
    Whether or not to notify the user before rebooting the endpoint. Available for macOS 11.3+.

    .PARAMETER RebuildKernelCache
    Whether or not to rebuild the kernel cache when rebooting the endpoint. Available for macOS 11+.

    .PARAMETER RequestRequiresNetworkTether
    Whether or not the request requires network tethering. Available for macOS and supervised iOS or tvOS.

    .PARAMETER Ids
    The IDs of the endpoints to be rebooted.

    .PARAMETER KextPaths
    The KextPaths of the endpoints to be rebooted. Available for macOS 11+.

    .PARAMETER Scope
    The scope (one of all, none, withAny, withAll, withoutAny, or withoutAll) and a set of tags of the endpoints to be rebooted.

    .PARAMETER Serials
    The serials of the endpoints to be rebooted.

    .PARAMETER WifiMacs
    The wifi MAC addresses of the endpoints to be rebooted.

    .EXAMPLE
    $DeviceIds = @("deviceId1", "deviceId2")
    Invoke-MerakiRebootNetworkSmDevices -AuthToken "your-api-token" -NetworkId "123456" -Ids $DeviceIds -NotifyUser $true

    This example reboots the specified devices in the network with ID "123456" and notifies the user before rebooting.

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
        [bool]$NotifyUser,
        [parameter(Mandatory=$false)]
        [bool]$RebuildKernelCache,
        [parameter(Mandatory=$false)]
        [bool]$RequestRequiresNetworkTether,
        [parameter(Mandatory=$false)]
        [string[]]$Ids,
        [parameter(Mandatory=$false)]
        [string[]]$KextPaths,
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

        if ($NotifyUser) {
            $body.notifyUser = $NotifyUser
        }

        if ($RebuildKernelCache) {
            $body.rebuildKernelCache = $RebuildKernelCache
        }

        if ($RequestRequiresNetworkTether) {
            $body.requestRequiresNetworkTether = $RequestRequiresNetworkTether
        }

        if ($Ids) {
            $body.ids = $Ids
        }

        if ($KextPaths) {
            $body.kextPaths = $KextPaths
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

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/reboot"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
