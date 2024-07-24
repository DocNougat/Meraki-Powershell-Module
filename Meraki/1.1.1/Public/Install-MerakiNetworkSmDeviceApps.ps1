function Install-MerakiNetworkSmDeviceApps {
    <#
    .SYNOPSIS
    Installs applications on a specific device in a network.

    .DESCRIPTION
    This function allows you to install applications on a specific device in a given network by providing the authentication token, network ID, device ID, and the application IDs to be installed.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network.

    .PARAMETER DeviceId
    The ID of the device.

    .PARAMETER AppIds
    A list of application IDs to be installed.

    .PARAMETER Force
    An optional boolean parameter to force the installation of apps even if they are believed to be present on the device.

    .EXAMPLE
    $AppIds = @("appId1", "appId2")
    Install-MerakiNetworkSmDeviceApps -AuthToken "your-api-token" -NetworkId "123456" -DeviceId "7890" -AppIds $AppIds -Force $true

    This example installs the specified applications on the device with ID "7890" in the network with ID "123456", forcing the installation even if the apps are believed to be present.

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
        [string[]]$AppIds,
        [parameter(Mandatory=$false)]
        [bool]$Force = $false
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = @{
            appIds = $AppIds
            force = $Force
        }

        $bodyJson = $body | ConvertTo-Json -Compress

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/installApps"

        $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $bodyJson
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}