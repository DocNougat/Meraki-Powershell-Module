function Get-MerakiNetworkSmDeviceRestrictions {
    <#
        .SYNOPSIS
        Retrieve the restrictions associated with a device.

        .DESCRIPTION
        Use this API endpoint to retrieve the restrictions associated with a device in a given network.

        .PARAMETER AuthToken
        Meraki Dashboard API token.

        .PARAMETER NetworkId
        Network ID.

        .PARAMETER DeviceId
        Device ID.

        .EXAMPLE
        PS C:\> Get-MerakiNetworkSmDeviceRestrictions -AuthToken "YOUR_API_KEY" -NetworkId "L_123456789012345678" -DeviceId "Q2XX-XXXX-XXXX"
        Returns the restrictions associated with the specified device.

        .NOTES
        For more information, please refer to the following documentation:
        https://developer.cisco.com/meraki/api-v1/#!get-network-sm-device-restrictions
    #>
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
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/sm/devices/$DeviceId/restrictions" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    } catch {
        Write-Error "Error: $_"
    }
}
