function Uninstall-MerakiNetworkSmDeviceApps {
    <#
    .SYNOPSIS
    Uninstalls applications from a specific device in a network.

    .DESCRIPTION
    This function allows you to uninstall applications from a specific device in a given network by providing the authentication token, network ID, device ID, and the application IDs to be uninstalled.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER DeviceId
    The ID of the device from which the applications will be uninstalled.

    .PARAMETER AppIds
    A list of application IDs to be uninstalled.

    .EXAMPLE
    $AppIds = @("appId1", "appId2")
    Uninstall-MerakiNetworkSmDeviceApps -AuthToken "your-api-token" -NetworkId "123456" -DeviceId "7890" -AppIds $AppIds

    This example uninstalls the specified applications from the device with ID "7890" in the network with ID "123456".

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
        [string]$DeviceId,
        [parameter(Mandatory=$true)]
        [string[]]$AppIds
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            appIds = $AppIds
        }

        $bodyJson = $body | ConvertTo-Json -Compress

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/uninstallApps"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
