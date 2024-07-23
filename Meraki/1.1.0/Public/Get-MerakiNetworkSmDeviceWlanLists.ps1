function Get-MerakiNetworkSmDeviceWlanLists {
    <#
    .SYNOPSIS
    Retrieves the list of SSID whitelist and blacklist for a given device.

    .DESCRIPTION
    This function retrieves the list of SSID whitelist and blacklist for a given device.

    .PARAMETER AuthToken
    Required. The Meraki Dashboard API authentication token.

    .PARAMETER NetworkId
    Required. The network ID.

    .PARAMETER DeviceId
    Required. The device ID.

    .EXAMPLE
    PS C:\> Get-MerakiNetworkSmDeviceWlanLists -AuthToken "12345" -NetworkId "L_1234" -DeviceId "1234567890"

    Retrieves the list of SSID whitelist and blacklist for the device with ID "1234567890" in the network "L_1234".
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$AuthToken,
        [parameter(Mandatory = $true)]
        [string]$NetworkId,
        [parameter(Mandatory = $true)]
        [string]$DeviceId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/wlanLists"
        $response = Invoke-RestMethod -Method Get -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"

        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
